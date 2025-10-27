import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_event.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_state.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_bloc.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_event.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_state.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_bloc.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_event.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/common_input_field.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/assigned_shop_list_response.dart';
import 'package:san_sprito/models/create_shop_stock_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';

class AddPromotionScreen extends StatefulWidget {
  final String? promoId;
  final Map<String, String>? shop;
  final bool? comeFromPromoList;
  const AddPromotionScreen({
    super.key,
    this.promoId,
    this.shop,
    this.comeFromPromoList,
  });

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
  List<Shops>? shopList = []; // where Shop is your model class
  String? selectedShopId;
  String? selectedShopName;

  // Original full data
  TextEditingController selectedBrandOptionCtrl = TextEditingController();
  TextEditingController noOfBottlesCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.comeFromPromoList == true) {
      insertData();
    }
    getUserIdAndLoadData();
    debugPrint("promoId---${widget.promoId}");
    debugPrint("shopData---${widget.shop}");
    super.initState();
  }

  insertData() {
    selectedShopId = widget.shop?["shopId"] ?? "";
    selectedShopName = widget.shop?["shopName"] ?? "";
    noOfBottlesCtrl.text = widget.shop?["noOfBottles"] ?? "";
    selectedBrandOptionCtrl.text = widget.shop?["brandName"] ?? "";
    selectedBrand = widget.shop?["categoryName"] ?? "";
  }

  List<String> get allOptions =>
      getProductBrandList?.map((e) => e.name ?? "").toList() ?? [];

  Future<void> getUserIdAndLoadData() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId') ?? "";
    debugPrint("gettingUserId: $userId");
    // String? _ = await fetchLocation();

    if (userId != null && userId!.isNotEmpty && mounted) {
      context.read<AssignedShopListBloc>().add(
        AssignedShopListEvent(userId: userId!),
      );
    } else {
      debugPrint("UserId is null or empty");
    }
  }

  updatePromo() {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AssignedShopListBloc, AssignedShopListState>(
          listener: (context, state) {
            if (state is AssignedShopListSuccess) {
              assignedShopListData =
                  state.assignedShopListResponseList.data ?? [];
              shopNames =
                  state.assignedShopListResponseList.data
                      ?.map((e) => e.name ?? "")
                      .toList() ??
                  [];

              debugPrint("shopLength---${shopNames.length}");

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

              shopList = createShopStockData?.shops ?? [];
              // shopNames = shopList?.map((e) => e.name ?? "").toList() ?? [];
              debugPrint("shoplist---${shopList?.last.name}");
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
        BlocListener<CreatePromotionBloc, CreatePromotionState>(
          listener: (context, state) {
            if (state is CreatePromotionLoading) {
              isLoad = true;
            } else if (state is CreatePromotionSuccess) {
              Fluttertoast.showToast(
                msg: "Promotion Added Successfully",
                backgroundColor: CommonColor.logoBGColor,
              );
              Navigator.pop(context);
              isLoad = false;
            } else if (state is UpdatePromotionSuccess) {
              Fluttertoast.showToast(
                msg: "Promotion Updated Successfully",
                backgroundColor: CommonColor.logoBGColor,
              );
              Navigator.pop(context);
              // Navigator.pop(context);
              isLoad = false;
            } else if (state is CreatePromotionFailure) {
              ToastService.showError(state.error);
              isLoad = false;
            }
          },
        ),
      ],
      child: BlocBuilder<SalesmanDashBoardBloc, SalesmanDashBoardState>(
        builder: (context, state) {
          return BlocBuilder<CreatePromotionBloc, CreatePromotionState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: const CommonAppBar(title: "Add Promotion"),
                body:
                    isLoad ||
                            (categoryNames.isEmpty == true) ||
                            (shopList?.isEmpty == true)
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
                        : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  widget.comeFromPromoList ?? false
                                      ? "Update promotion"
                                      : "Add Promotion",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                _buildDropdown(
                                  enable:
                                      widget.comeFromPromoList ?? false
                                          ? false
                                          : true,
                                  hint: 'Select Shop',
                                  selectedValue: selectedShopName,
                                  items:
                                      assignedShopListData
                                          ?.map((e) => e.name ?? "")
                                          .toList() ??
                                      [],
                                  // items: shopNames,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedShopName = value ?? "";

                                      final selectedShop = assignedShopListData
                                          ?.where((shop) => shop.name == value)
                                          .map((shop) => shop.id);
                                      selectedShopId = (selectedShop ?? '')
                                          .toString()
                                          .replaceAll('(', '')
                                          .replaceAll(')', '');

                                      debugPrint(
                                        "Selected shop id: $selectedShopId",
                                      );
                                    });
                                  },
                                ),

                                SizedBox(height: 15),
                                _buildDropdown(
                                  enable:
                                      widget.comeFromPromoList ?? false
                                          ? false
                                          : true,
                                  hint: 'Select Brand',
                                  selectedValue: selectedBrand,
                                  items: categoryNames,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBrand = value ?? "";
                                    });
                                    if (value != null && value.isNotEmpty) {
                                      context.read<SalesmanDashBoardBloc>().add(
                                        GetBrandProductListEvent(
                                          brandName: value,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width:
                                      double.infinity, // or any width you want
                                  child: _buildSelectOptionField(
                                    0,
                                    selectedBrandOptionCtrl.text,
                                    () {
                                      widget.comeFromPromoList ?? false
                                          ? null
                                          : _openOptionsBottomSheet(
                                            controller: selectedBrandOptionCtrl,
                                            allOptions: allOptions,
                                          );
                                    },
                                    widget.comeFromPromoList ?? false,

                                    // () =>
                                  ),
                                ),
                                SizedBox(height: 15),
                                CommonInputField(
                                  controller: noOfBottlesCtrl,
                                  hintText: "Enter number of bottles",
                                  keyboardType: TextInputType.number,
                                  hintStyle: TextStyle(
                                    color: CommonColor.black,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 25),
                                CommonButton(
                                  width: double.infinity,
                                  onPressed: () {
                                    if (selectedShopName?.isEmpty ??
                                        false ||
                                            selectedBrand.isEmpty ||
                                            selectedBrandOptionCtrl
                                                .text
                                                .isEmpty ||
                                            noOfBottlesCtrl.text.isEmpty ||
                                            selectedShopId?.isEmpty == true) {
                                      ToastService.showError(
                                        "Please fill all mandatory fields",
                                      );
                                    } else if (widget.comeFromPromoList ??
                                        false) {
                                      context.read<CreatePromotionBloc>().add(
                                        UpdatePromotionEvent(
                                          brandName:
                                              widget.shop?["brandName"] ?? "",
                                          promotionId: int.parse(
                                            widget.promoId ?? "",
                                          ),
                                          noOfBottles: int.parse(
                                            noOfBottlesCtrl.text,
                                          ),
                                        ),
                                      );
                                    } else {
                                      context.read<CreatePromotionBloc>().add(
                                        CreatePromotionEvent(
                                          shopId: selectedShopId ?? "",
                                          brandName:
                                              selectedBrandOptionCtrl.text,
                                          noOfBottles: noOfBottlesCtrl.text,
                                          salesmanId: userId ?? "",
                                          categoryName: selectedBrand,
                                        ),
                                      );
                                    }
                                  },
                                  backgroundColor: CommonColor.logoBGColor,
                                  text:
                                      widget.comeFromPromoList ?? false
                                          ? "Update promotion"
                                          : "Add Promotion",
                                  isLoading: false,
                                  icon: Icons.done,
                                ),
                              ],
                            ),
                          ),
                        ),
              );
            },
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
    required bool enable,
  }) {
    final String? validValue =
        (selectedValue != null && items.contains(selectedValue))
            ? selectedValue
            : null;

    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: validValue,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(color: enable ? Colors.black : Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          // ✅ Border when enabled
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: CommonColor.black, // Your border color
              width: 1.2,
            ),
          ),
          // ✅ Border when focused (user taps on dropdown)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: CommonColor.black, width: 1.5),
          ),
          // ✅ Border when disabled
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: enable ? Colors.black : Colors.grey),
                ),
              );
            }).toList(),
        onChanged: enable ? onChanged : null, // Disable if false
      ),
    );
  }

  Widget _buildSelectOptionField(
    int index,
    String selectedOption,
    VoidCallback onTap,
    bool enable,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: (enable) ? Colors.grey : Colors.black),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          selectedOption.isNotEmpty ? selectedOption : "Select an option",
          style: TextStyle(
            color: (enable) ? Colors.grey : CommonColor.black,
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
                          filteredOptions.isNotEmpty
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
