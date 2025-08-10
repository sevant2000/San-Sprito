import 'package:flutter/material.dart';

class CommonPaginatedTable extends StatelessWidget {
  final String headerText;
  final List<DataColumn> columns;
  final DataTableSource dataSource;
  final int rowsPerPage;

  const CommonPaginatedTable({
    super.key,
    required this.headerText,
    required this.columns,
    required this.dataSource,
    this.rowsPerPage = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1000, // You can make this dynamic if needed
          child: PaginatedDataTable(
            header: Text(headerText),
            columns: columns,
            source: dataSource,
            rowsPerPage: rowsPerPage,
            columnSpacing: 20,
            showCheckboxColumn: false,
          ),
        ),
      ),
    );
  }
}
