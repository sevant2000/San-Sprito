// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/images_constant/common_images.dart';
import 'package:san_sprito/common_widgets/location_helper.dart';
import 'package:san_sprito/common_widgets/navigation_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/screens/dashboard_screen.dart';
import 'package:san_sprito/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

 bool isLoggedIn = false;

  @override
  void initState() {
    fetchLocation();
    getLoginValue();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen after 3 seconds
      isLoggedIn ?
      NavigationHelper.pushAndRemoveUntil(context, DashboardScreen())
       :
      NavigationHelper.pushAndRemoveUntil(context, LoginScreen());
    });
    
    super.initState();
  }

  void fetchLocation() async {
  final locationData = await LocationHelper.getCurrentLocation();

  if (locationData?['error'] != null) {
    debugPrint("Error: ${locationData!['error']}");
  } else {
    debugPrint("Lat: ${locationData!['latitude']}");
    debugPrint("Lng: ${locationData['longitude']}");
    debugPrint("Address: ${locationData['address']}");
  }
}

 

  getLoginValue()async{
    final pref = await SharedPrefHelper.getInstance();
    isLoggedIn = pref.getBool('loggedIn') ?? false;
    debugPrint("loggedInValue__is$isLoggedIn");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.logoBGColor,
      body: Center(child: Image.asset(CommonImages.logo, height: 150)),
    );
  }
}
