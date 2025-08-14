import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_bloc.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_event.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_alert_dialog.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/image_picker.dart';
import 'package:san_sprito/common_widgets/location_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/create_shop_stock_response.dart';
import 'package:san_sprito/models/get_brands_products_response.dart';

class SalesmanStockDashboard extends StatefulWidget {
  final String? shopId;
  final String? shopName;

  const SalesmanStockDashboard({super.key, this.shopId, this.shopName});

  @override
  State<SalesmanStockDashboard> createState() => _SalesmanStockDashboardState();
}

class _SalesmanStockDashboardState extends State<SalesmanStockDashboard> {
  final _searchController = TextEditingController();

  String? selectedBrand;

  final searchFocus = FocusNode();

  bool isLoad = true;
  bool isImageLoading = false;
  bool btnLoading = false;

  CreateShopStockData? createShopStockData;
  List<GetBrandProductListData>? getProductBrandList;

  final int _rowsPerPage = 10;
  int _currentPage = 0;

  List<Map<String, dynamic>> productControllers = [];
  int? _editingIndex;
  String? userId;
  List<Categories>? categories;
  String? productId;
  List<String> imageNames = [];
  List<File> imageFiles = [];

  Map<String, dynamic> _generateProductControllers() {
    return {
      "brand": TextEditingController(),
      "name": TextEditingController(),
      // "lastStock": TextEditingController(),
      // "stockIn": TextEditingController(),
      // "totalStock": TextEditingController(),
      "closingStock": TextEditingController(),
      "selectedBrand": null, // dropdown value
    };
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
    getUserIdAndLoadData();
    productControllers.add(_generateProductControllers());
  }

  String currentAddress = "";
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

    if (userId != null && userId!.isNotEmpty) {
      // ignore: use_build_context_synchronously
      context.read<SalesmanDashBoardBloc>().add(
        SalesmanDashBoardEvent(
          loginId: userId ?? "",
          shopId: widget.shopId ?? "",
          deviceName: "One Plus",
          loginLocation: address ?? currentAddress,
        ),
      );
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  void _onEditRow(int rowIndex) {
    final rowData = mockData[rowIndex];

    if (productControllers.isEmpty) return;

    // Only use the first row in the UI to edit
    final controllers = productControllers[0];

    setState(() {
      _editingIndex = rowIndex;

      controllers["brand"]?.text = rowData["brand"] ?? "";
      controllers["name"]?.text = rowData["name"] ?? "";
      // controllers["lastStock"]?.text = rowData["lastStock"] ?? "";
      // controllers["stockIn"]?.text = rowData["stockIn"] ?? "";
      // controllers["totalStock"]?.text = rowData["totalStock"] ?? "";
      controllers["closingStock"]?.text = rowData["closingStock"] ?? "";
      controllers["selectedBrand"] = rowData["brand"];
      controllers["selectedOption"] = rowData["name"];
    });
  }

  List<String> get categoryName =>
      categories?.map((e) => e.name ?? "").toList() ?? [];

  Widget _buildDropdown<T>({
    required String hint,
    required T? selectedValue,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<T>(
        value: selectedValue,
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
            items.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(value.toString()),
              );
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

  Widget _buildSelectOptionField(int index, Map<String, dynamic> controllers) {
    return GestureDetector(
      onTap: () => _openOptionsBottomSheet(index, controllers),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          controllers["selectedOption"] ?? "Select an option",
          style: const TextStyle(
            color: Color.fromARGB(255, 32, 30, 30),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  List<String> get allOptions =>
      getProductBrandList?.map((e) => e.name ?? "").toList() ?? [];

  void _openOptionsBottomSheet(int index, Map<String, dynamic> controllers) {
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

              // Re-filter and sort the list
              filteredOptions =
                  allOptions.where((option) {
                    return option.toLowerCase().contains(lowerQuery);
                  }).toList();

              // Prioritize options that start with the query
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
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      child: ListView.builder(
                        itemCount: filteredOptions.length,
                        itemBuilder: (context, i) {
                          final option = filteredOptions[i];
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              setState(() {
                                controllers["selectedOption"] = option;
                                controllers["name"]?.text =
                                    option; // <-- Key line
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
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

  Widget _buildProductRow(int index) {
    final controllers = productControllers[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildDropdown<String>(
            hint: 'Select Brand',
            selectedValue: controllers["selectedBrand"] as String?,
            items: categoryName,
            onChanged: (value) {
              setState(() {
                controllers["selectedBrand"] = value;
                controllers["brand"]?.text = value ?? "";
              });

              context.read<SalesmanDashBoardBloc>().add(
                GetBrandProductListEvent(brandName: value ?? ""),
              );
            },
          ),

          SizedBox(
            width: double.infinity, // or any width you want
            child: _buildSelectOptionField(index, controllers),
          ),

          /* As per client requirement */

          // _buildTextField(
          //   "Last Stock (in bottles)",
          //   controllers["lastStock"] ?? "",
          //   FocusNode(),
          // ),
          // _buildTextField(
          //   "Stock In (in bottles)",
          //   controllers["stockIn"] ?? "",
          //   FocusNode(),
          // ),
          // _buildTextField(
          //   "Total Stock In (in bottles)",
          //   controllers["totalStock"] ?? "",
          //   FocusNode(),
          // ),
          _buildTextField(
            "Closing Stock (in bottles)",
            controllers["closingStock"] ?? "",
            FocusNode(),
          ),
          if (_editingIndex == null) ...[
            CommonButton(
              backgroundColor:
                  (productControllers.length == 1) ? Colors.grey : Colors.red,
              onPressed: () {
                (productControllers.length == 1)
                    ? ToastService.showError("You can't delete sinlge row")
                    : setState(() {
                      if (productControllers.length > 1) {
                        productControllers.removeAt(index);
                      }
                    });
              },
              text: "Remove",
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, String>> mockData = [];

  void emptyFields() {
    for (var controllers in productControllers) {
      (controllers["brand"] as TextEditingController?)?.clear();
      (controllers["name"] as TextEditingController?)?.clear();
      // (controllers["lastStock"] as TextEditingController?)?.clear();
      // (controllers["stockIn"] as TextEditingController?)?.clear();
      // (controllers["totalStock"] as TextEditingController?)?.clear();
      (controllers["closingStock"] as TextEditingController?)?.clear();
      controllers["selectedBrand"] = null;
      controllers["selectedOption"] = null;
    }

    // Optionally, close any open keyboard/focus
    FocusScope.of(context).unfocus();

    // If needed, trigger UI update
    setState(() {});
  }

  // List<Map<String, dynamic>> get _paginatedData {
  //   final start = _currentPage * _rowsPerPage;
  //   final end = start + _rowsPerPage;
  //   return mockData.sublist(
  //     start,
  //     end > mockData.length ? mockData.length : end,
  //   );
  // }

  List<Map<String, dynamic>> filteredData = [];

  List<Map<String, dynamic>> get _paginatedData {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    final data =
        filteredData.isNotEmpty || _searchController.text.isNotEmpty
            ? filteredData
            : mockData;

    return data.sublist(start, end > data.length ? data.length : end);
  }

  void _applySearch() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      _currentPage = 0;
      filteredData =
          mockData.where((item) {
            final name = item['name']?.toString().toLowerCase() ?? '';
            return name.contains(query);
          }).toList();
    });
  }

  void _saveProducts() {
  // Check for empty fields before proceeding
  bool hasEmptyField = productControllers.any((controllers) {
    return controllers.values.any((controller) {
      return controller?.text.trim().isEmpty ?? true;
    });
  });

  if (hasEmptyField) {
    ToastService.showError("Please fill all the fields");
    // Fluttertoast.showToast( 
    //   msg: "Please fill all the fields",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    // );
    return; // Stop execution here
  }

  final updatedStock = productControllers.map((controllers) {
    return {
      "brand_name": controllers["brand"]?.text,
      "label_name": controllers["name"]?.text,
      "last_stock": int.parse("${controllers["lastStock"]?.text}"),
      "stock_in": int.parse("${controllers["stockIn"]?.text}"),
      "total_stock": int.parse("${controllers["totalStock"]?.text}"),
      "closing_stock": int.parse("${controllers["closingStock"]?.text}"),
    };
  }).toList();

  if (_editingIndex != null) {
    context.read<SalesmanDashBoardBloc>().add(
      UpdateStockEvent(
        brandName: updatedStock[0]["brand_name"] ?? "",
        labelName: updatedStock[0]["label_name"] ?? "",
        stockId: productId?.toString() ?? "",
        lastStock: updatedStock[0]["last_stock"]?.toString() ?? "",
        stockIn: updatedStock[0]["stock_in"]?.toString() ?? "",
        closingStock: updatedStock[0]["closing_stock"]?.toString() ?? "",
        totalStock: updatedStock[0]["total_stock"]?.toString() ?? "",
      ),
    );
    _editingIndex = null; // Reset editing index after update
  } else {
    // Save new data
    context.read<SalesmanDashBoardBloc>().add(
      SaveStockEvent(
        shopId: int.parse(widget.shopId ?? ""),
        stockList: updatedStock,
      ),
    );
  }

  emptyFields(); // Clear form after save/update
}


  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM yyyy h:mm a').format(date);
    } catch (e) {
      return "-";
    }
  }

  Map<String, dynamic> _generateEmptyControllerMap() {
    return {
      "selectedBrand": null,
      "brand": TextEditingController(),
      "product": TextEditingController(),
      // "lastStock": TextEditingController(),
      // "stockIn": TextEditingController(),
      // "totalStock": TextEditingController(),
      "closingStock": TextEditingController(),
    };
  }

  Future<void> uploadImages(List<File> images) async {
    context.read<SalesmanDashBoardBloc>().add(
      UploadImageEvent(shopId: widget.shopId ?? "", imageList: images),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesmanDashBoardBloc, SalesmanDashBoardState>(
      listener: (context, state) {
        if (state is SalesmanDashBoardLoading) {
          isLoad = true;
        } else if (state is UploadImageLoading) {
          isImageLoading = true;
        } else if (state is SaveStockLoadingState) {
          btnLoading = true;
        } else if (state is SalesmanDashBoardSuccess) {
          createShopStockData = state.createShopStockResponseModel.data;
          categories = createShopStockData?.categories ?? [];
          mockData = List.generate(createShopStockData?.stocks?.length ?? 0, (
            index,
          ) {
            var item = createShopStockData?.stocks?[index];
            return {
              "id": item?.id ?? "",
              "shop": item?.shopName ?? "",
              "brand": item?.brandName ?? "",
              "name": item?.labelName ?? "",
              "lastStock": item?.lastStock ?? "",
              "stockIn": item?.stockIn ?? "",
              "totalStock": item?.totalStock ?? "",
              "closingStock": item?.closingStock ?? "",
              "lastVisit": _formatDate(item?.updatedAt ?? ""),
            };
          });
          isLoad = false;
        } else if (state is GetBrandProductListSuccess) {
          _searchController.clear();
          getProductBrandList = state.getBrandProductResponseModel.data;
          isLoad = false;
        } else if (state is SaveStockSuccess) {
          getUserIdAndLoadData();
          isLoad = true;
          btnLoading = false;
          ToastService.showSuccess(state.saveStockResponse.data ?? "");
          emptyFields();
          setState(() {
            // Reset to only one empty row
            productControllers = [_generateEmptyControllerMap()];
          });
        } else if (state is UpdateStockSuccess) {
          _searchController.clear();
          isLoad = true;
          btnLoading = false;
          getUserIdAndLoadData();
          ToastService.showSuccess("Stock Updated Successfully");
          emptyFields();
        } else if (state is DeleteStockSuccess) {
          _searchController.clear();
          Navigator.pop(context);
          isLoad = true;
          ToastService.showInfo("Stock Deleted Successfully");
          getUserIdAndLoadData();
        } else if (state is UploadImageListSuccess) {
          isImageLoading = false;
          ToastService.showSuccess("Image Uploaded Successfully");
          imageNames.clear();
          imageFiles.clear();
        } else if (state is SalesmanDashBoardFailure) {
          _searchController.clear();
          ToastService.showError("Something went wrong");
          isLoad = false;
          btnLoading = false;
          isImageLoading = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CommonColor.mainBGColor,
          appBar: const CommonAppBar(title: "Salesman Dashboard"),
          body:
              isLoad
                  ? Center(
                    child: CircularProgressIndicator(
                      color: CommonColor.logoBGColor,
                    ),
                  )
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CREATE STOCK SECTION
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Upload Images",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ImagePickerWidget(
                                        onFileNamesChanged: (names) {
                                          imageNames = names;
                                          debugPrint(
                                            'Selected Names: $imageNames',
                                          );
                                        },
                                        onFilesChanged: (files) {
                                          imageFiles = files;
                                          debugPrint(
                                            'Selected Files: $imageFiles',
                                          );
                                        },
                                        uploadFunction:
                                            (files) => uploadImages(files),
                                        btnLoading: isImageLoading,
                                      ),
                                    ),

                                    Text(
                                      "Create ${widget.shopName} Stock",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      children: List.generate(
                                        productControllers.length,
                                        (index) => _buildProductRow(index),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        if (_editingIndex == null) ...[
                                          CommonButton(
                                            onPressed: () {
                                              setState(() {
                                                productControllers.add(
                                                  _generateProductControllers(),
                                                );
                                              });
                                            },
                                            text: "Add Products",
                                          ),
                                          Spacer(),
                                        ],
                                        CommonButton(
                                          onPressed: () {
                                            

                                            _saveProducts();
                                            emptyFields();
                                          },
                                          text:
                                              _editingIndex != null
                                                  ? "Update Stock"
                                                  : "Save Stock",
                                          icon: Icons.send,
                                          isLoading: btnLoading,
                                          backgroundColor:
                                              CommonColor.logoBGColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // STOCK TABLE
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.shopName} STOCK",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            labelText: "Search by Product Name",
                                            isDense: true,
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.search),
                                              onPressed: _applySearch,
                                            ),
                                            border: const OutlineInputBorder(),
                                          ),
                                          onChanged:
                                              (_) =>
                                                  _applySearch(), // Optional: live filtering
                                        ),
                                      ),
                                      Spacer(),
                                      CommonButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            filteredData.clear();
                                          });
                                        },
                                        text: "Clear",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor:
                                        WidgetStateColor.resolveWith(
                                          (states) => Colors.grey.shade300,
                                        ),
                                    columns: const [
                                      DataColumn(label: Text('#')),
                                      DataColumn(label: Text('Shop')),
                                      DataColumn(label: Text('Brand')),
                                      DataColumn(label: Text('Name')),
                                      // DataColumn(
                                      //   label: Text('Last Stock (In bottles)'),
                                      // ),
                                      // DataColumn(
                                      //   label: Text('Stock In (In bottles)'),
                                      // ),
                                      // DataColumn(
                                      //   label: Text('Total Stock (In bottles)'),
                                      // ),
                                      DataColumn(
                                        label: Text(
                                          'Closing Stock (In bottles)',
                                        ),
                                      ),
                                      DataColumn(label: Text('Last Visit')),
                                      DataColumn(label: Text('Actions')),
                                    ],
                                    rows:
                                        _paginatedData
                                            .asMap()
                                            .map(
                                              (index, row) => MapEntry(
                                                index,
                                                DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(
                                                        '${_currentPage * _rowsPerPage + index + 1}',
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(row["shop"]!),
                                                    ),
                                                    DataCell(
                                                      Text(row["brand"]!),
                                                    ),
                                                    DataCell(
                                                      Text(row["name"]!),
                                                    ),
                                                    // DataCell(
                                                    //   Text(row["lastStock"]!),
                                                    // ),
                                                    // DataCell(
                                                    //   Text(row["stockIn"]!),
                                                    // ),
                                                    // DataCell(
                                                    //   Text(row["totalStock"]!),
                                                    // ),
                                                    DataCell(
                                                      Text(
                                                        row["closingStock"]!,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(row["lastVisit"]!),
                                                    ),

                                                    /// ✅ Conditionally show Edit/Delete only if search is empty
                                                    DataCell(
                                                      _searchController.text
                                                              .trim()
                                                              .isEmpty
                                                          ? Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  _searchController
                                                                      .clear();
                                                                  final product =
                                                                      createShopStockData
                                                                          ?.stocks?[index];
                                                                  String id =
                                                                      product
                                                                          ?.id ??
                                                                      "";
                                                                  productId =
                                                                      id;
                                                                  debugPrint(
                                                                    "ProductIdIs---$productId",
                                                                  );
                                                                  _onEditRow(
                                                                    index,
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  color:
                                                                      Colors
                                                                          .blue,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  final product =
                                                                      createShopStockData
                                                                          ?.stocks?[index];
                                                                  String id =
                                                                      product
                                                                          ?.id ??
                                                                      "";
                                                                  productId =
                                                                      id;

                                                                  showConfirmationDialog(
                                                                    context:
                                                                        context,
                                                                    cancelText:
                                                                        "No",
                                                                    confirmText:
                                                                        "Yes",
                                                                    title:
                                                                        "Delete Stock confirmation",
                                                                    content:
                                                                        "Are you sure want to delete this stock product",
                                                                    onDeletePressed: () {
                                                                      context
                                                                          .read<
                                                                            SalesmanDashBoardBloc
                                                                          >()
                                                                          .add(
                                                                            DeleteStockEvent(
                                                                              stockId:
                                                                                  productId ??
                                                                                  "",
                                                                            ),
                                                                          );
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : const SizedBox(), // keep cell count consistent
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .values
                                            .toList(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Showing ${_paginatedData.isEmpty ? 0 : _currentPage * _rowsPerPage + 1}"
                                      " to ${_currentPage * _rowsPerPage + _paginatedData.length}"
                                      " of ${mockData.length} entries",
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed:
                                          _currentPage > 0
                                              ? () =>
                                                  setState(() => _currentPage--)
                                              : null,
                                      icon: const Icon(Icons.arrow_back_ios),
                                    ),
                                    Text("${_currentPage + 1}"),
                                    IconButton(
                                      onPressed:
                                          (_currentPage + 1) * _rowsPerPage <
                                                  mockData.length
                                              ? () =>
                                                  setState(() => _currentPage++)
                                              : null,
                                      icon: const Icon(Icons.arrow_forward_ios),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }

  // Widget _buildTextField(
  //   String label,
  //   TextEditingController controller,
  //   FocusNode focusNode,
  // ) {
  //   return SizedBox(
  //     // width: 300,
  //     child: TextField(
  //       controller: controller,
  //       keyboardType: TextInputType.numberWithOptions(),
  //       focusNode: focusNode,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: const OutlineInputBorder(),
  //         isDense: true,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDropdown(String label, TextEditingController controller) {
  //   return SizedBox(
  //     // width: 300,
  //     child: DropdownButtonFormField<String>(
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: const OutlineInputBorder(),
  //         isDense: true,
  //       ),
  //       items: const [
  //         DropdownMenuItem(value: "Option 1", child: Text("Option 1")),
  //         DropdownMenuItem(value: "Option 2", child: Text("Option 2")),
  //       ],
  //       onChanged: (value) => controller.text = value ?? '',
  //     ),
  //   );
  // }
}
