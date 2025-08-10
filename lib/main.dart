import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/assigned_shop_list/assigned_shop_list_bloc.dart';
import 'package:san_sprito/bloc/dashBoard/dash_board_bloc.dart';
import 'package:san_sprito/bloc/main_bloc/login_bloc.dart';
import 'package:san_sprito/bloc/priority_stock/priority_stock_bloc.dart';
import 'package:san_sprito/bloc/sales_target/sales_target_bloc.dart';
import 'package:san_sprito/bloc/salesman_dashboard/salesman_dashbard_bloc.dart';
import 'package:san_sprito/bloc/send_message/send_message_bloc.dart';
import 'package:san_sprito/bloc/shop_stocks/shop_stock_bloc.dart';
import 'package:san_sprito/bloc/ware_house_stock/ware_house_stock_bloc.dart';
import 'package:san_sprito/screens/splash_screen.dart';
import 'package:san_sprito/services/api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider<ApiService>(create: (_) => ApiService())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create:
                (context) => LoginBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<DashBoardBloc>(
            create:
                (context) =>
                    DashBoardBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<WareHouseStockBloc>(
            create:
                (context) =>
                    WareHouseStockBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<PriorityStockBloc>(
            create:
                (context) =>
                    PriorityStockBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<ShopStockBloc>(
            create:
                (context) =>
                    ShopStockBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<SalesTargetBloc>(
            create:
                (context) =>
                    SalesTargetBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<AssignedShopListBloc>(
            create:
                (context) => AssignedShopListBloc(
                  apiService: context.read<ApiService>(),
                ),
          ),
          BlocProvider<SendMessageBloc>(
            create:
                (context) =>
                    SendMessageBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<SalesmanDashBoardBloc>(
            create:
                (context) => SalesmanDashBoardBloc(
                  apiService: context.read<ApiService>(),
                ),
          ),

          // Add other BlocProviders here (e.g., UserBloc)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "San Sprito",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
