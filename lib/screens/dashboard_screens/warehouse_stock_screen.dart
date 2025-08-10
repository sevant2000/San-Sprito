import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:san_sprito/bloc/ware_house_stock/ware_house_stock_bloc.dart';
import 'package:san_sprito/bloc/ware_house_stock/ware_house_stock_event.dart';
import 'package:san_sprito/bloc/ware_house_stock/ware_house_stock_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/ware_house_stock_model.dart';

class GovtWarehouseInventoryScreen extends StatefulWidget {
  const GovtWarehouseInventoryScreen({super.key});

  @override
  State<GovtWarehouseInventoryScreen> createState() =>
      _GovtWarehouseInventoryScreenState();
}

class _GovtWarehouseInventoryScreenState
    extends State<GovtWarehouseInventoryScreen> {
  int _currentPage = 0;
  final int _rowsPerPage = 10;
  String? _selectedBrand;
  final TextEditingController _searchController = TextEditingController();
  // DateTime? _startDate;
  // DateTime? _endDate;
  String? userId;
  WareHouseStockData? wareHouseStockData;
  bool isLoad = false;
  late List<Map<String, dynamic>> _stockData;
  List<Map<String, dynamic>> _allData = [];
  List<Categories>? categories;

  List<Map<String, dynamic>> get _paginatedData {
    final start = _currentPage * _rowsPerPage;
    final end = (_currentPage + 1) * _rowsPerPage;
    if (_stockData.isEmpty || start >= _stockData.length) return [];

    return _stockData.sublist(
      start,
      end > _stockData.length ? _stockData.length : end,
    );
  }

  @override
  void initState() {
    getUserIdAndLoadData();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  // Future<void> _pickDate(BuildContext context, bool isStart) async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime(2030),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStart) {
  //         _startDate = picked;
  //       } else {
  //         _endDate = picked;
  //       }
  //     });
  //   }
  // }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _stockData = List.from(_allData); // Reset
      } else {
        final matching =
            _allData
                .where(
                  (item) =>
                      item['label'] != null &&
                      item['label'].toString().toLowerCase().contains(query),
                )
                .toList();

        final nonMatching =
            _allData
                .where(
                  (item) =>
                      item['label'] == null ||
                      !item['label'].toString().toLowerCase().contains(query),
                )
                .toList();

        _stockData = [...matching, ...nonMatching]; // matching on top
      }

      _currentPage = 0; // Optional: reset pagination
    });
  }

  Future<void> getUserIdAndLoadData() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId');
    debugPrint("gettingUserId: $userId");

    if (userId != null && userId!.isNotEmpty) {
      // ignore: use_build_context_synchronously
      context.read<WareHouseStockBloc>().add(
        WareHouseStockEvent(userId: userId ?? ""),
      );
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  List<String> get categoryName =>
      categories?.map((e) => e.name ?? "").toList() ?? [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WareHouseStockBloc, WareHouseState>(
      listener: (context, state) {
        if (state is WareHouseStockLoading) {
          isLoad = true;
          debugPrint("Here is loading");
        } else if (state is WareHouseStockSuccess) {
          wareHouseStockData = state.wareHouseStockResponseModel.data;

          final generatedData = List.generate(
            wareHouseStockData?.mergedInventory?.length ?? 0,
            (index) {
              return {
                "brand": wareHouseStockData?.mergedInventory?[index].brand,
                "label": wareHouseStockData?.mergedInventory?[index].labelName,
                "size": wareHouseStockData?.mergedInventory?[index].bottleSize,
                "warehouse":
                    wareHouseStockData?.mergedInventory?[index].warehouseName,
                "cases":
                    wareHouseStockData
                        ?.mergedInventory?[index]
                        .totalQuantityInCases,
                "bottles":
                    wareHouseStockData
                        ?.mergedInventory?[index]
                        .totalQuantityInBottles,
              };
            },
          );

          // Save full copy of the original data
          _allData = List<Map<String, dynamic>>.from(generatedData);

          // Initial viewable data
          _stockData = List<Map<String, dynamic>>.from(generatedData);

          categories = wareHouseStockData?.categories ?? [];
          isLoad = false;
        } else if (state is WareHouseStockFailure) {
          debugPrint("Here is Failure ${state.error}");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: CommonAppBar(title: "Govt. Warehouse Inventory",),
          body:
              wareHouseStockData == null
                  ? Center(
                    child: CircularProgressIndicator(
                      color: CommonColor.logoBGColor,
                    ),
                  )
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Filters row
                              Wrap(
                                spacing: 12,
                                runSpacing: 10,
                                children: [
                                  DropdownButton<String>(
                                    hint: const Text("All Brands"),
                                    value: _selectedBrand,
                                    items:
                                        categoryName
                                            .map<DropdownMenuItem<String>>((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            })
                                            .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedBrand = val;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        hintText: "Label Name",
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                    ),
                                  ),

                                  CommonButton(
                                    onPressed: () {},
                                    text: "Search",
                                    backgroundColor: CommonColor.logoBGColor,
                                  ),
                                  CommonButton(
                                    onPressed: () => _downloadExcel(),
                                    text: "Download Excel",
                                  ),
                                  const SizedBox(width: 10),
                                  CommonButton(
                                    onPressed: () => _downloadPdf(),
                                    text: "Download PDF",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Table
                              SizedBox(
                                height: 550,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      Colors.grey[200],
                                    ),
                                    columnSpacing: 20,
                                    columns: const [
                                      DataColumn(label: Text("##")),
                                      DataColumn(label: Text("Brand")),
                                      DataColumn(label: Text("Label Name")),
                                      DataColumn(label: Text("Bottle Size")),
                                      DataColumn(label: Text("Warehouse Name")),
                                      DataColumn(label: Text("Bottles")),
                                      DataColumn(label: Text("Bottles")),
                                    ],
                                    rows: List.generate(_paginatedData.length, (
                                      index,
                                    ) {
                                      final item = _paginatedData[index];
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              "${_currentPage * _rowsPerPage + index + 1}",
                                            ),
                                          ),
                                          DataCell(Text(item['brand'])),
                                          DataCell(Text(item['label'])),
                                          DataCell(Text(item['size'])),
                                          DataCell(Text(item['warehouse'])),
                                          DataCell(
                                            Text(item['cases'].toString()),
                                          ),
                                          DataCell(
                                            Text(item['bottles'].toString()),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Pagination
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Showing ${_currentPage * _rowsPerPage + 1} to ${((_currentPage + 1) * _rowsPerPage).clamp(0, _stockData.length)} of ${_stockData.length} entries",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed:
                                            _currentPage > 0
                                                ? () => setState(
                                                  () => _currentPage--,
                                                )
                                                : null,
                                      ),

                                      Text(
                                        '${_currentPage + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed:
                                            (_currentPage + 1) * _rowsPerPage <
                                                    _stockData.length
                                                ? () => setState(
                                                  () => _currentPage++,
                                                )
                                                : null,
                                      ),

                                      const SizedBox(width: 4),
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
    var status = await Permission.storage.request();
    if (!status.isGranted) return;

    var excel = Excel.createExcel();
    Sheet sheet = excel['Stock'];

    // Add header row
    sheet.appendRow([
      "##",
      "Brand",
      "Label Name",
      "Bottle Size",
      "Warehouse Name",
      "Bottles",
      "Bottles",
    ]);

    // Add data rows
    for (int i = 0; i < _paginatedData.length; i++) {
      var item = _paginatedData[i];
      sheet.appendRow([
        "${_currentPage * _rowsPerPage + i + 1}",
        item['brand'],
        item['label'],
        item['size'],
        item['warehouse'],
        item['cases'].toString(),
        item['bottles'].toString(),
      ]);
    }

    final directory = Directory('/storage/emulated/0/Download');
    String path = "${directory.path}/warehouse_stock_data.xlsx";
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    ToastService.showSuccess("Excel downloaded to $path");
  }

  Future<void> _downloadPdf() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) return;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.TableHelper.fromTextArray(
            headers: [
              "##",
              "Brand",
              "Label Name",
              "Bottle Size",
              "Warehouse Name",
              "Bottles",
              "Bottles",
            ],
            data: List.generate(_paginatedData.length, (i) {
              final item = _paginatedData[i];
              return [
                "${_currentPage * _rowsPerPage + i + 1}",
                item['brand'],
                item['label'],
                item['size'],
                item['warehouse'],
                item['cases'].toString(),
                item['bottles'].toString(),
              ];
            }),
          );
        },
      ),
    );

    final directory = Directory('/storage/emulated/0/Download');
    String path = "${directory.path}/warehouse_stock_data.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    ToastService.showSuccess("PDF downloaded to $path");
  }
}
