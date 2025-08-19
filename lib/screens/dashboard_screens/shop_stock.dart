import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:san_sprito/bloc/shop_stocks/shop_stock_bloc.dart';
import 'package:san_sprito/bloc/shop_stocks/shop_stock_event.dart';
import 'package:san_sprito/bloc/shop_stocks/shop_stock_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/shop_stock_data_response_model.dart';

class ShopStock extends StatefulWidget {
  const ShopStock({super.key});

  @override
  State<ShopStock> createState() => _ShopStockState();
}

class _ShopStockState extends State<ShopStock> {
  bool isLoad = false;
  String? userId;
  ShopStockData? shopStockData;

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
      context.read<ShopStockBloc>().add(ShopStockEvent(userId: userId ?? ""));
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopStockBloc, ShopStockState>(
      listener: (context, state) {
        if (state is ShopStockLoading) {
          isLoad = true;
        } else if (state is ShopStockSuccess) {
          shopStockData = state.shopStockResponseModel.data;
          debugPrint("shopStockData---${shopStockData?.stocks?.length}");
          isLoad = false;
        } else if (state is ShopStockFailure) {}
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CommonAppBar(title: "Shop Stock"),
          backgroundColor: Colors.white,
          body:
              isLoad
                  ? Center(
                    child: CircularProgressIndicator(
                      color: CommonColor.logoBGColor,
                    ),
                  )
                  : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CommonButton(
                              onPressed: () {},
                              text: "Download Excel",
                            ),
                            const SizedBox(width: 10),
                            CommonButton(
                              onPressed: () {},
                              text: "Download PDF",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            header: const Text('Stock Management'),
                            columns: const [
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Shop')),
                              DataColumn(label: Text('Brand')),
                              DataColumn(label: Text('Name')),
                              // DataColumn(label: Text('Stock In')),
                              // DataColumn(label: Text('Total Stock')),
                              DataColumn(label: Text('Closing Stock')),
                              DataColumn(label: Text('Last Visit Date')),
                            ],
                            source: _ShopStockTableSource(
                              shopStockData: shopStockData,
                            ),
                            rowsPerPage: 10, // 👈 forces 10 rows per page
                            showCheckboxColumn: false,
                            columnSpacing: 20,
                            headingRowColor: WidgetStateProperty.all(
                              Colors.grey[200],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }
}

class _ShopStockTableSource extends DataTableSource {
  final ShopStockData? shopStockData;

  _ShopStockTableSource({required this.shopStockData});


  String formatDate(String inputDate) {
  try {
    DateTime parsedDate = DateTime.parse(inputDate);
    return DateFormat('dd MMMM yyyy').format(parsedDate);
  } catch (e) {
    return 'Invalid date';
  }
}

  @override
  DataRow? getRow(int index) {
    final stocks = shopStockData?.stocks;
    if (stocks == null || index >= stocks.length) return null;

    final stock = stocks[index];

    return DataRow(
      cells: [
        DataCell(Text('${index + 1}', style: TextStyle())),
        DataCell(Text(stock.shopName ?? '')),
        DataCell(
          Text(stock.brandName ?? ''),
        ), // Update these lines as per your model
        DataCell(Text(stock.labelName ?? '')),
        // DataCell(Text('${stock.stockIn ?? 0} Bottles')),
        // DataCell(Text('${stock.totalStock ?? 0} Bottles')),
        DataCell(Text('${stock.closingStock ?? 0} Bottles')),
        DataCell(Text(formatDate(stock.updatedAt ?? ""))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => shopStockData?.stocks?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
