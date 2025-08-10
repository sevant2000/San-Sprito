import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/sales_target/sales_target_bloc.dart';
import 'package:san_sprito/bloc/sales_target/sales_target_event.dart';
import 'package:san_sprito/bloc/sales_target/sales_target_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/sales_target_response_model.dart';

class SalesTargetScreen extends StatefulWidget {
  const SalesTargetScreen({super.key});

  @override
  State<SalesTargetScreen> createState() => _SalesTargetScreenState();
}

class _SalesTargetScreenState extends State<SalesTargetScreen> {
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  bool isLoad = false;
  String? userId;
  List<SalesTargetListData>? salesTargetDataList;
  late List<Map<String, dynamic>> _targetData = [];

  List<Map<String, dynamic>> get _currentData {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    return _targetData.sublist(
      start,
      end > _targetData.length ? _targetData.length : end,
    );
  }

  void _nextPage() {
    if ((_currentPage + 1) * _rowsPerPage < _targetData.length) {
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
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
      // ignore: use_build_context_synchronously
      context.read<SalesTargetBloc>().add(SalesTargetEvent(userId: userId!));
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesTargetBloc, SalesTargetState>(
      listener: (context, state) {
        if (state is SalesTargetLoading) {
          setState(() => isLoad = true);
        } else if (state is SalesTargetSuccess) {
          salesTargetDataList = state.salesTargetResponseModel.data ?? [];
          _targetData = List.generate(salesTargetDataList?.length ?? 0, (index) {
            final assignedStr =
                salesTargetDataList?[index].assignedQuantity?.toString() ?? '0';
            final completedStr =
                salesTargetDataList?[index].completedQuantity?.toString() ?? '0';

            final assigned = num.tryParse(assignedStr) ?? 0;
            final completed = num.tryParse(completedStr) ?? 0;

            return {
              "#": index + 1,
              "salesman": salesTargetDataList?[index].salesmanName ?? '',
              "brand": salesTargetDataList?[index].brandName ?? '',
              "label": salesTargetDataList?[index].labelName ?? '',
              "assignedQty1": assigned,
              "completedQty": completed,
              "assignedQty2": assigned - completed,
            };
          });
          setState(() => isLoad = false);
        } else if (state is SalesTargetFailure) {
          setState(() => isLoad = false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          appBar: CommonAppBar(
            backgroundColor: CommonColor.logoBGColor,
            title: "Target",
          ),
          body: isLoad
              ? Center(
                  child: CircularProgressIndicator(
                    color: CommonColor.logoBGColor,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Sales Targets",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 36,
                                  margin: const EdgeInsets.only(left: 8),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      hintText: "Search",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Salesman name", style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Brand Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Label Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Assigned Quantity", style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Completed Quantity", style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text("Remaining Quantity", style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: _currentData.map((data) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(data["#"].toString())),
                                      DataCell(Text(data["salesman"])),
                                      DataCell(Text(data["brand"])),
                                      DataCell(Text(data["label"])),
                                      DataCell(Text(data["assignedQty1"].toString())),
                                      DataCell(Text(data["completedQty"].toString())),
                                      DataCell(Text(data["assignedQty2"].toString())),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Showing ${_currentData.length} of ${_targetData.length} entries",
                                ),
                                const SizedBox(width: 24),
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: _currentPage > 0 ? _prevPage : null,
                                ),
                                Text("${_currentPage + 1}"),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: (_currentPage + 1) * _rowsPerPage <
                                          _targetData.length
                                      ? _nextPage
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
