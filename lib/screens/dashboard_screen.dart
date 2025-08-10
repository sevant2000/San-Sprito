import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:san_sprito/bloc/dashBoard/dash_board_bloc.dart';
import 'package:san_sprito/bloc/dashBoard/dash_board_event.dart';
import 'package:san_sprito/bloc/dashBoard/dash_board_state.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_app_bar.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/location_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/dashboard_data_response_model.dart';
import 'package:san_sprito/screens/dashboard_screens/inbox_screeen.dart';
import 'package:san_sprito/screens/dashboard_screens/priority_stock_screen.dart';
import 'package:san_sprito/screens/dashboard_screens/sales_target_screen.dart';
import 'package:san_sprito/screens/dashboard_screens/shop_assigned_screen.dart';
import 'package:san_sprito/screens/dashboard_screens/shop_stock.dart';
import 'package:san_sprito/screens/dashboard_screens/warehouse_stock_screen.dart';
import 'package:san_sprito/screens/login_screen.dart';
import '../common_widgets/images_constant/common_images.dart';
import '../common_widgets/navigation_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isShopExpanded = false;
  int? touchedIndex;
  String? userId;
  DashBoardResponse dashBoardResponse = DashBoardResponse();
  DashBoardUserData? dashBoardData;
  bool isLoad = false;
  bool isLoggingOut = false; // at the top of your State class

  // Sample summary data
  final summaryData = [
    {
      'title': 'Assigned Target',
      'value': '0',
      'icon': Icons.assignment_turned_in,
      'color': Colors.pink[100],
      'footer': '↑ 1.3% Up from past week',
      'footerColor': Colors.green,
    },
    {
      'title': 'Completed Target',
      'value': '0',
      'icon': Icons.check_circle_outline,
      'color': Colors.green[100],
      'footer': '↑ 8.5% Up from yesterday',
      'footerColor': Colors.green,
    },
    {
      'title': 'Pending Target',
      'value': '0',
      'icon': Icons.timer_outlined,
      'color': Colors.orange[100],
      'footer': '↑ 1.8% Up from past week',
      'footerColor': Colors.green,
    },
  ];

  @override
  void initState() {
    fetchLocation();
    getUserId();
    // getDashBoardData();
    super.initState();
  }

  getUserId() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId');
    currentAddress = pref.getString("loginLocation") ?? "";
    debugPrint("gettingUserId$userId");
    getDashBoardData();
  }

  refreshState() {
    setState(() {});
  }

  getDashBoardData() {
    context.read<DashBoardBloc>().add(DashBoardDataEvent(userId: userId ?? ""));
    refreshState();
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

  @override
  Widget build(BuildContext context) {
    // fetchLocation();
    return BlocConsumer<DashBoardBloc, DashBoardState>(
      listener: (context, state) {
        if (state is DashBoardLoading) {
          isLoad = true;
          debugPrint("isLoad---$isLoad");
        } else if (state is DashBoardSuccess) {
          dashBoardResponse = state.dashBoardResponse;
          dashBoardData = dashBoardResponse.data;
          debugPrint(
            "dataDashboardResp===${dashBoardResponse.data?.salesmanTarget?.length}",
          );
          isLoad = false;
          debugPrint("isLoad---$isLoad");

          if (dashBoardData?.salesmanTarget != null &&
              dashBoardData!.salesmanTarget!.isNotEmpty) {
            final target = dashBoardData!.salesmanTarget![0];
            setState(() {
              summaryData[0]['value'] = target.assigned.toString();
              summaryData[1]['value'] = target.completed.toString();
              summaryData[2]['value'] = target.remaining.toString();
            });
          }
        } else if (state is LogOutSuccess) {
          isLoggingOut = false;
          isLoad = false;
          ToastService.showSuccess("Logout successfully");
          SharedPrefHelper.getInstance().then((pref) {
            pref.clear();
            // ignore: use_build_context_synchronously
            NavigationHelper.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              LoginScreen(),
            );
          });
        } else if (state is DashBoardFailure) {
          ToastService.showError("Something went wrong");
          isLoggingOut = false;
          isLoad = false;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            drawer: _buildDrawer(dashBoardData),
            backgroundColor: CommonColor.mainBGColor,
            body:
                isLoad || dashBoardData == null
                    ? Center(
                      child: CircularProgressIndicator(
                        color: CommonColor.logoBGColor,
                      ),
                    )
                    : Stack(
                      children: [
                        Column(
                          children: [
                            CommonAppBar(
                              isHomeButtonEnable: false,
                              height: 300,
                              title: "Dashboard",
                              subtitle: "My Sales Target Progress",
                            ),
                            const SizedBox(height: 70),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 350,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildLegend(),
                                          SizedBox(
                                            height: 250,
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(
                                                  touchCallback: (
                                                    FlTouchEvent event,
                                                    pieTouchResponse,
                                                  ) {
                                                    setState(() {
                                                      if (!event
                                                              .isInterestedForInteractions ||
                                                          pieTouchResponse ==
                                                              null ||
                                                          pieTouchResponse
                                                                  .touchedSection ==
                                                              null) {
                                                        touchedIndex = -1;
                                                        return;
                                                      }
                                                      touchedIndex =
                                                          pieTouchResponse
                                                              .touchedSection!
                                                              .touchedSectionIndex;
                                                    });
                                                  },
                                                ),
                                                sections:
                                                    _buildAnimatedSections(
                                                      dashBoardData,
                                                    ),
                                                centerSpaceRadius: 50,
                                                sectionsSpace: 2,
                                                startDegreeOffset: -90,
                                              ),
                                              // ignore: deprecated_member_use
                                              swapAnimationDuration:
                                                  const Duration(
                                                    milliseconds: 500,
                                                  ),
                                              // ignore: deprecated_member_use
                                              swapAnimationCurve:
                                                  Curves.easeOut,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildAttendanceTablePlaceholder(
                                      dashBoardData,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Stacked summary cards
                        Positioned(
                          top: 200,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 140,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: summaryData.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final item = summaryData[index];
                                return _summaryCard(
                                  title: item['title'] as String,
                                  value: item['value'] as String,
                                  icon: item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  footer: item['footer'] as String,
                                  footerColor: item['footerColor'] as Color,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  double? convertStringToDouble(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    return double.tryParse(input);
  }

  List<PieChartSectionData> _buildAnimatedSections(DashBoardUserData? data) {
    final sectionValues = [
      {
        'value': convertStringToDouble(
          data?.salesmanTarget?.first.assigned ?? "",
        ),
        'color': Colors.purple.shade700,
        'title': 'Assigned',
      },
      {
        'value': convertStringToDouble(
          data?.salesmanTarget?.first.completed ?? "",
        ),
        'color': Colors.green,
        'title': 'Completed',
      },
      {
        'value': convertStringToDouble(
          data?.salesmanTarget?.first.remaining ?? "",
        ),
        'color': Colors.orange.shade400,
        'title': 'Remaining',
      },
    ];

    return List.generate(sectionValues.length, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 60 : 50;

      return PieChartSectionData(
        value: sectionValues[i]['value'] as double,
        color: sectionValues[i]['color'] as Color,
        title: '',
        radius: radius,
        titleStyle: TextStyle(color: Colors.white),
      );
    });
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegendItem(Colors.purple.shade700, 'Assigned'),
          _buildLegendItem(Colors.green, 'Completed'),
          _buildLegendItem(Colors.orange.shade400, 'Remaining'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String footer,
    required Color footerColor,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 150,

        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(fontSize: 11)),
            const Spacer(),
            Text(footer, style: TextStyle(fontSize: 9, color: footerColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(DashBoardUserData? data) {
    return Drawer(
      child: Container(
        color: Colors.pink[800],
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(radius: 30, backgroundColor: CommonColor.mainBGColor),
                const SizedBox(width: 10),
                Text(
                 data?.username ?? "" ,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            const Divider(color: Colors.white70),
            _buildDrawerItem(
              CommonImages.icDashboard,
              "Dashboard",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              CommonImages.icInbox,
              "Inbox",
              onTap: () {
                NavigationHelper.navigate(context, InboxScreen());
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("PAGES", style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: Image.asset(CommonImages.icStore, height: 30),
              title: const Text("Shop", style: TextStyle(color: Colors.white)),
              trailing: Icon(
                isShopExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  isShopExpanded = !isShopExpanded;
                });
              },
            ),
            if (isShopExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubDrawerItem("Assigned", () {
                      NavigationHelper.navigate(context, ShopListScreen());
                    }),
                    _buildSubDrawerItem("Shop stocks", () {
                      NavigationHelper.navigate(context, ShopStock());
                    }),
                  ],
                ),
              ),
            _buildDrawerItem(
              CommonImages.icTargets,
              "Target",
              onTap: () {
                NavigationHelper.navigate(context, SalesTargetScreen());
              },
            ),
            _buildDrawerItem(
              CommonImages.icWarehouse,
              "Warehouse stock",
              onTap: () {
                NavigationHelper.navigate(
                  context,
                  GovtWarehouseInventoryScreen(),
                );
              },
            ),
            _buildDrawerItem(
              CommonImages.icPriority,
              "Priority Stock",
              onTap: () {
                NavigationHelper.navigate(context, StockListScreen());
              },
            ),
            StatefulBuilder(
              builder: (context, state) {
                return _buildDrawerItem(
                  loading: isLoad,
                  CommonImages.icLogOut,
                  "Log out",
                  onTap: () async {
                    if (!mounted) return;

                    state(() {
                      isLoad = true;
                    });

                    String? address;
                    try {
                      address = await fetchLocation();
                    } catch (e) {
                      address = null;
                    }

                    if (!mounted) return;

                    // ignore: use_build_context_synchronously
                    context.read<DashBoardBloc>().add(
                      LogOutEvent(
                        loginId: userId ?? "",
                        loginLocation: address ?? "",
                      ),
                    );

                    debugPrint("logout location: ${address ?? currentAddress}");
                    // showConfirmationDialog(
                    //   context: context,
                    //   cancelText: "No",
                    //   confirmText: "Yes",
                    //   title: "Log out confirmation",
                    //   btnLoad: isLoggingOut, // Shows loader on confirm button
                    //   content: "Are you sure you want to log out",
                    //   onDeletePressed: () async {
                    //     if (!mounted) return;

                    //     state(() {
                    //       isLoggingOut = true;
                    //     });

                    //     String? address;
                    //     try {
                    //       address = await fetchLocation();
                    //     } catch (e) {
                    //       address = null;
                    //     }

                    //     if (!mounted) return;

                    //     // ignore: use_build_context_synchronously
                    //     context.read<DashBoardBloc>().add(
                    //       LogOutEvent(
                    //         loginId: userId ?? "",
                    //         loginLocation: address ?? "",
                    //       ),
                    //     );

                    //     debugPrint(
                    //       "logout location: ${address ?? currentAddress}",
                    //     );
                    //   },
                    // );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    String icon,
    String title, {
    void Function()? onTap,
    bool? loading = false,
  }) {
    return ListTile(
      leading:
          loading == true
              ? SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Image.asset(icon, height: 30),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildSubDrawerItem(String title, void Function()? onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildAttendanceTablePlaceholder(
    DashBoardUserData? dashBoardUserData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Attendance",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        AttendanceTableWidget(dashBoardUserData: dashBoardUserData),
      ],
    );
  }
}

class LoginRecord {
  final String username;
  final String loginTime;
  final String loginLocation;
  final String logoutTime;
  final String logoutLocation;

  LoginRecord({
    required this.username,
    required this.loginTime,
    required this.loginLocation,
    required this.logoutTime,
    required this.logoutLocation,
  });
}

class AttendanceTableWidget extends StatefulWidget {
  final DashBoardUserData? dashBoardUserData;
  const AttendanceTableWidget({super.key, this.dashBoardUserData});

  @override
  State<AttendanceTableWidget> createState() => _AttendanceTableWidgetState();
}

class _AttendanceTableWidgetState extends State<AttendanceTableWidget> {
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  DashBoardUserData? get dashBoardData => widget.dashBoardUserData;
  late List<Map<String, String>> _attendanceData;

  @override
  void initState() {
    super.initState();
    _attendanceData = List.generate(dashBoardData?.attendance?.length ?? 0, (
      index,
    ) {
      return {
        "username": dashBoardData?.attendance?[index].username ?? "",
        "loginTime": _formatDate(dashBoardData?.attendance?[index].loginTime),
        "loginLocation": dashBoardData?.attendance?[index].loginLocation ?? "",
        "logoutTime": _formatDate(dashBoardData?.attendance?[index].logoutTime),
        "logoutLocation":
            dashBoardData?.attendance?[index].logoutLocation ?? "",
      };
    });
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      final date = DateTime.parse(isoDate).toLocal(); // convert to local time
      return DateFormat('dd MMM yyyy h:mm a').format(date);
    } catch (e) {
      return "-";
    }
  }

  List<Map<String, String>> get _paginatedData {
    final start = _currentPage * _rowsPerPage;
    return _attendanceData.skip(start).take(_rowsPerPage).toList();
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _rowsPerPage < _attendanceData.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final start = _currentPage * _rowsPerPage;
    final end = (_currentPage + 1) * _rowsPerPage;
    final showingEnd =
        end > _attendanceData.length ? _attendanceData.length : end;

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: WidgetStateColor.resolveWith(
                  (_) => Colors.grey.shade200,
                ),
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Login Time')),
                  DataColumn(label: Text('Login Location')),
                  DataColumn(label: Text('Logout Time')),
                  DataColumn(label: Text('Logout Location')),
                ],
                rows:
                    _paginatedData.asMap().entries.map((entry) {
                      final i = entry.key;
                      final data = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text('${start + i + 1}')),
                          DataCell(Text(data['username']!)),
                          DataCell(Text(data['loginTime']!)),
                          DataCell(
                            Text(
                              data['loginLocation']!.isEmpty
                                  ? '-'
                                  : data['loginLocation']!,
                            ),
                          ),
                          DataCell(Text(data['logoutTime']!)),
                          DataCell(
                            Text(
                              data['logoutLocation']!.isEmpty
                                  ? '-'
                                  : data['logoutLocation']!,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Showing ${start + 1} to $showingEnd of ${_attendanceData.length} entries",
                  style: const TextStyle(fontSize: 12),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: _previousPage,
                    ),
                    Text(
                      "${_currentPage + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
