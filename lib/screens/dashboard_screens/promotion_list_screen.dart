import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_bloc.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_event.dart';
import 'package:san_sprito/bloc/promotion_bloc/promotion_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/navigation_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/promotion_list_response.dart';
import 'package:san_sprito/screens/dashboard_screens/add_promotion_screen.dart';

class PromotionListScreen extends StatefulWidget {
  const PromotionListScreen({super.key});

  @override
  State<PromotionListScreen> createState() => _PromotionListScreenState();
}

class _PromotionListScreenState extends State<PromotionListScreen> {
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  bool isLoad = false;
  String? userId;

  List<PromotionListData>? assignedShopListData;
  List<Map<String, String>>? _data; // Original full data
  List<Map<String, String>> _filteredData =
      []; // Filtered data for search & pagination

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> get _paginatedData {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    return _filteredData.sublist(
      start,
      end > _filteredData.length ? _filteredData.length : end,
    );
  }

  void _applySearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _currentPage = 0;
      _filteredData =
          (_data ?? []).where((shop) {
            final shopName = shop["shopName"]?.toLowerCase() ?? '';
            return shopName.contains(query);
          }).toList();
    });
  }

  void _nextPage() {
    if ((_currentPage + 1) * _rowsPerPage < _filteredData.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserIdAndLoadData();
  }

  Future<void> getUserIdAndLoadData() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId') ?? "";
    debugPrint("gettingUserId: $userId");

    if (userId != null && userId!.isNotEmpty && mounted) {
      context.read<CreatePromotionBloc>().add(PromotionListEvent());
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePromotionBloc, CreatePromotionState>(
      listener: (context, state) {
        if (state is CreatePromotionLoading) {
          isLoad = true;
        } else if (state is PromotionListSuccess) {
          assignedShopListData = state.promotionListResponse.data ?? [];
          _data = List.generate(assignedShopListData?.length ?? 0, (index) {
            return {
              "id": assignedShopListData?[index].id ?? "",
              "shopId": assignedShopListData?[index].shopId ?? "",
              "salesmenId": assignedShopListData?[index].salesmanId ?? "",
              "brandName": assignedShopListData?[index].brandName ?? "",
              "noOfBottles": assignedShopListData?[index].noOfBottles ?? "",
              "shopName": assignedShopListData?[index].shopName ?? "",
              "salesmenName": assignedShopListData?[index].salesmanName ?? "",
              "categoryName": assignedShopListData?[index].categoryName ?? "",
            };
          });
          _filteredData = List.from(_data!);
          isLoad = false;
        } else if (state is DeletePromotionSuccess) {
          Fluttertoast.showToast(
            msg:
                state.deletePromotionResponse.data?.message ??
                "Product Deleted Successfully",
          );
          context.read<CreatePromotionBloc>().add(PromotionListEvent());
        } else if (state is CreatePromotionFailure) {
          isLoad = false;
          ToastService.showError("Something went wrong");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CommonAppBar(title: "Promotion List"),
          body:
              isLoad
                  ? Center(
                    child: CircularProgressIndicator(
                      color: CommonColor.logoBGColor,
                    ),
                  )
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 300,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search by shop name',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) => _applySearch(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CommonButton(
                                onPressed: () {
                                  NavigationHelper.navigate(
                                    context,
                                    AddPromotionScreen(),
                                  ).then((val) {
                                    getUserIdAndLoadData();
                                  });
                                },
                                text: "Add Promotion",
                              ),
                            ),
                          ),
                          PaginatedDataTable(
                            header: const Text("Promotion List"),
                            rowsPerPage: _rowsPerPage,
                            availableRowsPerPage: const [10, 20, 30],
                            onPageChanged: (start) {
                              setState(() {
                                _currentPage = start ~/ _rowsPerPage;
                              });
                            },
                            columns: const [
                              DataColumn(label: Text("#")),
                              DataColumn(label: Text("Shop Name")),
                              DataColumn(label: Text("Brand Name")),
                              DataColumn(label: Text("No of bottles")),
                              DataColumn(label: Text("Salesman Name")),
                              DataColumn(label: Text("Category Name")),
                              DataColumn(label: Text("")),
                              // DataColumn(label: Text("Status")),
                              // DataColumn(label: Text("Shop")),
                              // DataColumn(label: Text("Remark")),
                            ],
                            source: ShopDataSource(
                              _paginatedData,
                              _currentPage * _rowsPerPage,
                              context,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Showing ${_paginatedData.length} of ${_filteredData.length} entries",
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: _previousPage,
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _nextPage,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }
}

class ShopDataSource extends DataTableSource {
  final List<Map<String, String>> data;
  final int offset;
  final BuildContext context;

  ShopDataSource(this.data, this.offset, this.context);

  final TextEditingController dialogCtrl = TextEditingController();

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final shop = data[index];
    final _ = shop["id"];
    dialogCtrl.text = shop["remark"] ?? "";
    return DataRow(
      cells: [
        DataCell(Text('${offset + index + 1}')),
        DataCell(
          InkWell(
            onTap: () {
              NavigationHelper.navigate(
                context,
                AddPromotionScreen(
                  promoId: shop["id"],
                  shop: shop,
                  comeFromPromoList: true,
                ),
              ).then((val) {
                if (context.mounted) {
                  context.read<CreatePromotionBloc>().add(PromotionListEvent());
                }
              });
              ;
            },
            child: Text(
              shop["shopName"] ?? "",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(Text(shop["brandName"] ?? "")),
        DataCell(Text(shop["noOfBottles"] ?? "")),
        DataCell(Text(shop["salesmenName"] ?? "")),
        DataCell(Text(shop["categoryName"] ?? "")),
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CommonColor.logoBGColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 15),
                    onPressed: () {
                      NavigationHelper.navigate(
                        context,
                        AddPromotionScreen(
                          promoId: shop["id"],
                          shop: shop,
                          comeFromPromoList: true,
                        ),
                      ).then((val) {
                        if (context.mounted) {
                          context.read<CreatePromotionBloc>().add(
                            PromotionListEvent(),
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CommonColor.logoBGColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white, size: 15),
                    onPressed: () async {
                      final bool confirmDelete =
                          await showDeleteConfirmationDialog(context, shop["id"] ?? "");
                      if (confirmDelete && context.mounted) {

                      } else {}
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context, String id) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // prevent closing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Confirm Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                CommonButton(onPressed: () {
                  context.read<CreatePromotionBloc>().add(
                    DeletePromotionEvent(
                      promotionId: int.parse(id),
                    ),
                  );
                  debugPrint("dsjhfgjh");
                  Navigator.pop(context);
                }, text: "Delete"),
              ],
            );
          },
        ) ??
        false; // returns false if dialog dismissed without pressing any button
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
