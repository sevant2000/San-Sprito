import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:san_sprito/bloc/priority_stock/priority_stock_bloc.dart';
import 'package:san_sprito/bloc/priority_stock/priority_stock_event.dart';
import 'package:san_sprito/bloc/priority_stock/priority_stock_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/priority_stock_response.dart';
import 'package:intl/intl.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  String? userId;
  PriorityStockData? priorityStockData;
  bool isLoad = false;

  late List<Map<String, dynamic>> stockData = [];
  List<Map<String, dynamic>> filteredStockData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    getUserIdAndLoadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getUserIdAndLoadData() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId') ?? "";
    debugPrint("gettingUserId: $userId");

    if (userId != null && userId!.isNotEmpty) {
      // ignore: use_build_context_synchronously
      context.read<PriorityStockBloc>().add(PriorityStockEvent(userId: userId!));
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _currentPage = 0;
      if (query.isEmpty) {
        filteredStockData = List.from(stockData);
      } else {
        final matching = stockData.where((item) =>
          (item['label'] as String?)?.toLowerCase().contains(query) ?? false
        ).toList();

        final nonMatching = stockData.where((item) =>
          !(item['label'] as String?)!.toLowerCase().contains(query)
        ).toList();

        filteredStockData = [...matching, ...nonMatching];
      }
    });
  }

  String getRemainingDays(String expiryDateString) {
    try {
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateTime expiryDate = inputFormat.parseStrict(expiryDateString);
      expiryDate = DateTime.utc(expiryDate.year, expiryDate.month, expiryDate.day);
      DateTime today = DateTime.now().toUtc();
      today = DateTime.utc(today.year, today.month, today.day);

      int difference = expiryDate.difference(today).inDays;

      if (difference < 0) {
        return 'Expired';
      } else if (difference == 0) {
        return 'Expires today';
      } else {
        return '$difference days remaining';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PriorityStockBloc, PriorityStockState>(
      listener: (context, state) {
        if (state is PriorityStockLoading) {
          isLoad = true;
        } else if (state is PriorityStockSuccess) {
          priorityStockData = state.priorityStockResponseModel.data;
          stockData = List.generate(priorityStockData?.inventory?.length ?? 0, (index) {
            return {
              "brand": priorityStockData!.inventory![index].brand ?? "",
              "label": priorityStockData!.inventory![index].labelName ?? "",
              "daysLeft": getRemainingDays(priorityStockData!.inventory![index].expiryDate ?? ""),
              "size": priorityStockData!.inventory![index].bottleSize ?? "",
              "warehouse": priorityStockData!.inventory![index].warehouseName ?? "",
              "cases": priorityStockData!.inventory![index].noOfCaseAtVerification ?? "",
              "bottles": priorityStockData!.inventory![index].bottlesAtVerification ?? "",
            };
          });
          filteredStockData = List.from(stockData);
          isLoad = false;
        } else if (state is PriorityStockFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data not found"))
          );
        }
      },
      builder: (context, state) {
        final int start = _currentPage * _rowsPerPage;
        final int end = (_currentPage + 1) * _rowsPerPage;
        final currentRows = filteredStockData.sublist(
          start,
          end > filteredStockData.length ? filteredStockData.length : end,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: const CommonAppBar(title: "Priority Stock"),
          body: isLoad
              ? Center(child: CircularProgressIndicator(color: CommonColor.logoBGColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CommonButton(
                                      onPressed: _downloadExcel,
                                      text: "Download Excel",
                                    ),
                                    const SizedBox(width: 10),
                                    CommonButton(
                                      onPressed: _downloadPdf,
                                      text: "Download PDF",
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                            SizedBox(height: 10,),
                            SizedBox(
                                  width: 220,
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      hintText: 'Search by Label',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                                dataRowMinHeight: 60,
                                columnSpacing: 24,
                                columns: const [
                                  DataColumn(label: Text("##", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Brand", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Label Name", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Remaining Days", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Bottle Size", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Warehouse", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Bottles", style: TextStyle(fontSize: 16))),
                                  DataColumn(label: Text("Bottles", style: TextStyle(fontSize: 16))),
                                ],
                                rows: List.generate(currentRows.length, (index) {
                                  final item = currentRows[index];
                                  return DataRow(cells: [
                                    DataCell(Text("${start + index + 1}")),
                                    DataCell(Text(item['brand'])),
                                    DataCell(Text(item['label'])),
                                    DataCell(Text(item['daysLeft'], style: const TextStyle(color: Colors.red))),
                                    DataCell(Text(item['size'])),
                                    DataCell(Text(item['warehouse'])),
                                    DataCell(Text(item['cases'].toString())),
                                    DataCell(Text(item['bottles'].toString())),
                                  ]);
                                }),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Showing ${start + 1} to ${end > filteredStockData.length ? filteredStockData.length : end} of ${filteredStockData.length} entries"),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                                    ),
                                    Text('${_currentPage + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: end < filteredStockData.length ? () => setState(() => _currentPage++) : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _downloadExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Stock Report'];
    sheet.appendRow(["##", "Brand", "Label Name", "Remaining Days", "Bottle Size", "Warehouse", "Bottles", "Bottles"]);
    for (int i = 0; i < stockData.length; i++) {
      final item = stockData[i];
      sheet.appendRow([
        "${i + 1}",
        item['brand'],
        item['label'],
        item['daysLeft'].toString(),
        item['size'],
        item['warehouse'],
        item['cases'].toString(),
        item['bottles'].toString(),
      ]);
    }
    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/priority_stock_report.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
    ToastService.showSuccess("Excel saved to ${file.path}");
  }

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();
    final int start = _currentPage * _rowsPerPage;
    final int end = (_currentPage + 1) * _rowsPerPage;
    final currentRows = filteredStockData.sublist(start, end > filteredStockData.length ? filteredStockData.length : end);

    pdf.addPage(pw.Page(
      build: (context) {
        return pw.TableHelper.fromTextArray(
          headers: ["##", "Brand", "Label Name", "Remaining Days", "Bottle Size", "Warehouse", "Bottles", "Bottles"],
          data: List.generate(currentRows.length, (i) {
            final item = currentRows[i];
            return [
              "${start + i + 1}",
              item['brand'],
              item['label'],
              item['daysLeft'].toString(),
              item['size'],
              item['warehouse'],
              item['cases'].toString(),
              item['bottles'].toString(),
            ];
          }),
        );
      },
    ));

    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/priority_stock_report.pdf');
    await file.writeAsBytes(await pdf.save());
    ToastService.showSuccess("PDF saved to ${file.path}");
  }
}
