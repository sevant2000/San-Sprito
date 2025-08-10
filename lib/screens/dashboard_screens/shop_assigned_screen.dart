import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_event.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_alert_dialog.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_remark_dialog.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/navigation_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/assigned_shop_list_response.dart';
import 'package:san_sprito/screens/dashboard_screens/salesmen_dashboard_screen.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  bool isLoad = false;
  String? userId;

  List<AssignedShopListData>? assignedShopListData;
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

    if (userId != null && userId!.isNotEmpty) {
      context.read<AssignedShopListBloc>().add(
        AssignedShopListEvent(userId: userId!),
      );
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssignedShopListBloc, AssignedShopListState>(
      listener: (context, state) {
        if (state is AssignedShopListLoading) {
          isLoad = true;
        } else if (state is AssignedShopListSuccess) {
          assignedShopListData = state.assignedShopListResponseList.data ?? [];
          _data = List.generate(assignedShopListData?.length ?? 0, (index) {
            return {
              "id": assignedShopListData?[index].id ?? "",
              "shopName": assignedShopListData?[index].name ?? "",
              "licence": assignedShopListData?[index].licence ?? "",
              "district": assignedShopListData?[index].district ?? "",
              "licenceName": assignedShopListData?[index].contactPerson ?? "",
              "contact": assignedShopListData?[index].contactNumber ?? "",
              "status": assignedShopListData?[index].status ?? "",
              "shop": "LOGIN",
              "remark": assignedShopListData?[index].message ?? "",
            };
          });

          // Set filteredData to full list initially
          _filteredData = List.from(_data!);
          isLoad = false;
        } else if (state is SaveRemarkSuccessState) {
          ToastService.showSuccess("Remark saved successfully");
          getUserIdAndLoadData();
        } else if (state is UpdateStatusSuccessState) {
          ToastService.showSuccess("Status Updated Successfully");
          getUserIdAndLoadData();
        } else if (state is AssignedShopListFailure) {
          isLoad = false;
          ToastService.showError("Something went wrong");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CommonAppBar(title: "Shop List"),
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
                          PaginatedDataTable(
                            header: const Text("Shop List"),
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
                              DataColumn(label: Text("Licencee")),
                              DataColumn(label: Text("District")),
                              DataColumn(label: Text("Licence name")),
                              DataColumn(label: Text("Contact")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Shop")),
                              DataColumn(label: Text("Remark")),
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
    final shopId = shop["id"];
    dialogCtrl.text = shop["remark"] ?? "";
    return DataRow(
      cells: [
        DataCell(Text('${offset + index + 1}')),
        DataCell(
          InkWell(
            onTap: () {
              NavigationHelper.navigate(
                context,
                SalesmanStockDashboard(
                  shopId: shop["id"],
                  shopName: shop["shopName"],
                ),
              );
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
        DataCell(Text(shop["licence"] ?? "")),
        DataCell(Text(shop["district"] ?? "")),
        DataCell(Text(shop["licenceName"] ?? "")),
        DataCell(Text(shop["contact"] ?? "")),
        DataCell(
          InkWell(
            onTap: () {
              showConfirmationDialog(
                context: context,
                confirmText: "Yes",
                cancelText: "No",
                title: "Are you sure want to change the status",
                onDeletePressed: () {
                  context.read<AssignedShopListBloc>().add(
                    UpdateStatusEvent(shopId: shopId ?? ""),
                  );
                  Navigator.pop(context);
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    shop["status"] == "1" ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                shop["status"] == "1" ? "ACTIVE" : "NOT ACTIVE",
                style: TextStyle(
                  color: shop["status"] == "1" ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () {
              NavigationHelper.navigate(
                context,
                SalesmanStockDashboard(
                  shopId: shop["id"],
                  shopName: shop["shopName"],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text("LOGIN", style: TextStyle(color: Colors.blue)),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              Text(
                shop["remark"]?.isEmpty ?? false
                    ? "No Remark"
                    : shop["remark"] ?? "",
              ),
              shop["remark"]?.isNotEmpty ?? false
                  ? IconButton(
                    onPressed: () {
                      showRemarkDialog(
                        remarkController: dialogCtrl,
                        context: context,
                        onSave: (value) {
                          context.read<AssignedShopListBloc>().add(
                            SaveRemarkEvent(
                              shopId: shopId ?? "",
                              message: value,
                            ),
                          );
                          // Navigator.pop(context);
                        },
                        isLoading: false,
                      );
                    },
                    icon: Icon(
                      Icons.edit_calendar_rounded,
                      color: CommonColor.logoBGColor,
                      size: 18,
                    ),
                  )
                  : IconButton(
                    onPressed: () {
                      showRemarkDialog(
                        context: context,
                        remarkController: dialogCtrl,
                        onSave: (value) {
                          debugPrint("response ${dialogCtrl.text}");
                          debugPrint("id $shopId");

                          context.read<AssignedShopListBloc>().add(
                            SaveRemarkEvent(
                              shopId: shopId ?? "",
                              message: value,
                            ),
                          );
                        },
                        isLoading: false,
                      );
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: CommonColor.logoBGColor,
                      size: 18,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
