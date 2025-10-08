import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_event.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_state.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_bloc.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_event.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/location_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/assigned_shop_list_response.dart';
import 'package:san_sprito/models/create_shop_stock_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';

class AddPromotionScreen extends StatefulWidget {
  const AddPromotionScreen({super.key});

  @override
  State<AddPromotionScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<AddPromotionScreen> {
  List<Map<String, dynamic>> productControllers = [];
  List<Categories>? categories;
  bool isLoad = false;

  CreateShopStockData? createShopStockData;
  final _searchController = TextEditingController();
  List<GetBrandProductListData>? getProductBrandList;
  List<Map<String, String>> mockData = [];
  String? userId;
  String selectedBrand = "";
  String selectedShop = "";
  String selectedOption = "";
  List<AssignedShopListData>? assignedShopListData;
  List<String> categoryNames = [];
  List<String> shopNames = [];
  // Original full data
  TextEditingController selectedBrandOptionCtrl = TextEditingController();

  @override
  void initState() {
    fetchLocation();
    getUserIdAndLoadData();
    super.initState();
  }

  List<String> get allOptions =>
      getProductBrandList?.map((e) => e.name ?? "").toList() ?? [];

  Future<String?> fetchLocation() async {
    final locationData = await LocationHelper.getCurrentLocation();
    final address = locationData?['address'];

    if (locationData?['error'] != null) {
      debugPrint("Error: ${locationData!['error']}");
    } else {
      debugPrint("Lat: ${locationData!['latitude']}");
      debugPrint("Lng: ${locationData['longitude']}");
      debugPrint("Address: $address");
    }

    return address;
  }

  Future<void> getUserIdAndLoadData() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId') ?? "";
    debugPrint("gettingUserId: $userId");
    String? address = await fetchLocation();

    if (userId != null && userId!.isNotEmpty && mounted) {
      context.read<AssignedShopListBloc>().add(
        AssignedShopListEvent(userId: userId!),
      );
    } else {
      debugPrint("UserId is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AssignedShopListBloc, AssignedShopListState>(
          listener: (context, state) {
            if (state is AssignedShopListSuccess) {
              assignedShopListData =
                  state.assignedShopListResponseList.data ?? [];
              // Set filteredData to full list initially
              isLoad = false;
              if (userId != null && userId!.isNotEmpty) {
                // ignore: use_build_context_synchronously
                context.read<SalesmanDashBoardBloc>().add(
                  SalesmanDashBoardEvent(
                    loginId: userId ?? "",
                    shopId: assignedShopListData?.first.id ?? "",
                    deviceName: "One Plus",
                    loginLocation: "Indore, M.P.",
                  ),
                );
              } else {
                debugPrint("UserId is null or empty — skipping API call");
              }
            }
          },
        ),
        BlocListener<SalesmanDashBoardBloc, SalesmanDashBoardState>(
          listener: (context, state) {
            if (state is SalesmanDashBoardLoading) {
              isLoad = true;
            } else if (state is SalesmanDashBoardSuccess) {
              createShopStockData = state.createShopStockResponseModel.data;
              shopNames =
                  createShopStockData?.shops
                      ?.map((e) => e.name ?? "")
                      .toList() ??
                  [];
              categories = createShopStockData?.categories ?? [];
              categoryNames =
                  categories?.map((e) => e.name ?? "").toList() ?? [];
              isLoad = false;
            } else if (state is GetBrandProductListSuccess) {
              _searchController.clear();
              getProductBrandList = state.getBrandProductResponseModel.data;
              isLoad = false;
            }
          },
        ),
      ],
      child: BlocBuilder<SalesmanDashBoardBloc, SalesmanDashBoardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CommonAppBar(title: "Add Promotion"),
            body:
                isLoad || (categoryNames.isEmpty == true)
                    // true
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: CommonColor.logoBGColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Fetching Data"),
                      ],
                    )
                    : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          _buildDropdown(
                            hint: 'Select Shop',
                            selectedValue: selectedShop,
                            items: shopNames,
                            onChanged: (value) {
                              setState(() {
                                selectedShop = value ?? "";
                              });
                            },
                          ),
                          _buildDropdown(
                            hint: 'Select Brand',
                            selectedValue: selectedBrand,
                            items: categoryNames,
                            onChanged: (value) {
                              setState(() {
                                selectedBrand = value ?? "";
                              });
                              if (value != null && value.isNotEmpty) {
                                context.read<SalesmanDashBoardBloc>().add(
                                  GetBrandProductListEvent(brandName: value),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: double.infinity, // or any width you want
                            child: _buildSelectOptionField(
                              0,
                              selectedBrandOptionCtrl.text,
                              () => _openOptionsBottomSheet(
                                controller: selectedBrandOptionCtrl,
                                allOptions: allOptions,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final String? validValue =
        (selectedValue != null && items.contains(selectedValue))
            ? selectedValue
            : null;

    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        initialValue: validValue,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(),
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSelectOptionField(
    int index,
    String selectedOption,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          selectedOption.isNotEmpty ? selectedOption : "Select an option",
          style: const TextStyle(
            color: Color.fromARGB(255, 32, 30, 30),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _openOptionsBottomSheet({
    required TextEditingController controller,
    required List<String> allOptions,
  }) {
    List<String> filteredOptions = List.from(allOptions);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterOptions(String query) {
              final lowerQuery = query.toLowerCase();

              filteredOptions =
                  allOptions.where((option) {
                    return option.toLowerCase().contains(lowerQuery);
                  }).toList();

              // Sort: prioritize matches starting with the query
              filteredOptions.sort((a, b) {
                bool aStarts = a.toLowerCase().startsWith(lowerQuery);
                bool bStarts = b.toLowerCase().startsWith(lowerQuery);
                if (aStarts && !bStarts) return -1;
                if (!aStarts && bStarts) return 1;
                return 0;
              });

              setModalState(() {});
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: "Search options",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: filterOptions,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          filteredOptions.isNotEmpty ?? false
                              ? ListView.builder(
                                itemCount: filteredOptions.length,
                                itemBuilder: (context, i) {
                                  final option = filteredOptions[i];
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () {
                                      setState(() {
                                        controller.text = option;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              )
                              : Text(
                                "Options not available please select brand name first",
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
