// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/main_bloc/login_event.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/images_constant/common_images.dart';
import 'package:san_sprito/common_widgets/location_helper.dart';
import 'package:san_sprito/common_widgets/navigation_helper.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/login_response_model.dart';
import 'package:san_sprito/screens/dashboard_screen.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import '../bloc/main_bloc/login_bloc.dart';
import '../bloc/main_bloc/login_state.dart';
import '../common_widgets/common_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  FocusNode userNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  LoginResponseModel loginResponseModel = LoginResponseModel();
  String currentAddress = "";
  String deviceName = "One Plus";

  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  Future<String?> fetchLocation() async {
    final locationData = await LocationHelper.getCurrentLocation();
    final address = locationData?['address'];
    // deviceName = await getDeviceName();
    // SharedPrefHelper.getInstance().then((pref) {
    //   pref.saveString('deviceName', deviceName);
    // });
    // debugPrint("DeviceName is----$deviceName");
    if (locationData?['error'] != null) {
      debugPrint("Error: ${locationData!['error']}");
    } else {
      debugPrint("Lat: ${locationData!['latitude']}");
      debugPrint("Lng: ${locationData['longitude']}");
      debugPrint("Address: $address");
    }

    return address;
  }

  Future<void> loginButtonApi() async {
    
    setState(() {
      isLoad = true;
    });

    String? address;
    try {
      address = await fetchLocation();
      final pref = await SharedPrefHelper.getInstance();
      await pref.saveString('loginLocation', address ?? "");
    } catch (e) {
      setState(() {
        isLoad = false;
      });
      ToastService.showError("Failed to fetch location");
      return;
    }

    if (userNameCtrl.text.isEmpty) {
      setState(() {
        isLoad = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter user name')));
      return;
    }

    if (passwordCtrl.text.isEmpty) {
      setState(() {
        isLoad = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter password')));
      return;
    }

    if (address != null) {
      context.read<LoginBloc>().add(
        LoginUserEvent(
          username: userNameCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
          loginLocation: address,
          deviceName: deviceName,
        ),
      );
      // loader will be turned off in BlocListener after login result
    } else {
      setState(() {
        isLoad = false;
      });
      ToastService.showError("Location is mandatory");
    }
  }

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoad = true;
        } else if (state is LoginSuccess) {
          ToastService.showSuccess("Login Sucessfully");
          loginResponseModel = state.loginResponseModel;
          SharedPrefHelper.getInstance().then((pref) {
            pref.saveString('userId', loginResponseModel.data?.id ?? "");
            pref.saveBool("loggedIn", true);

            NavigationHelper.navigate(context, DashboardScreen());
          });
          isLoad = false;
        } else if (state is LoginFailure) {
          ToastService.showError("Invalid Credatial");
          isLoad = false;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70,
                    vertical: 120,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color: CommonColor.logoBGColor,
                    height: 160,
                    child: Image.asset(
                      CommonImages.logo,
                      alignment: Alignment.topCenter,
                      height: 120,
                      fit: BoxFit.cover,
                      color: Colors.white,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    CommonImages.mainLogoImage,
                    alignment: Alignment.topCenter,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 450,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(70),
                        topLeft: Radius.circular(70),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 60,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          boldText(txt: "Salesman Log in"),
                          SizedBox(height: 30),
                          headerText(txt: "Username"),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: userNameCtrl,
                            focusNode: userNameFocus,
                            decoration: InputDecoration(
                              hintText: "Enter user name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          headerText(txt: "Password"),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: passwordCtrl,
                            focusNode: passwordFocus,
                            decoration: InputDecoration(
                              hintText: "Enter user password",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          CommonButton(
                            isLoading: isLoad,
                            onPressed: () async {
                              loginButtonApi();
                            },
                            text: "Login",
                            height: 50,
                            width: double.infinity,
                            backgroundColor: CommonColor.logoBGColor,
                            icon: Icons.login,
                          ),
                        ],
                      ),
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

  Widget boldText({required String txt}) {
    return Text(
      txt,
      style: TextStyle(
        color: CommonColor.logoBGColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget headerText({required String txt}) {
    return Text(
      txt,
      style: TextStyle(
        color: CommonColor.black,
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
