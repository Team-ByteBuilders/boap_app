import 'package:boap_app/screens/login_screen.dart';
import 'package:boap_app/screens/user_detail_screen.dart';
import 'package:boap_app/services/secure_service.dart';
import 'package:boap_app/services/user_details.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import '../utils/custom_colors.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SecureService secure = SecureService();
    return Scaffold(
        body: FutureBuilder(
      future: secure.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return FutureBuilder(
                future: secure.getUserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (UserDetails.currentUser.firstName == '') {
                      return const UserDetailScreen();
                    }
                    return const HomeScreen();
                  } else {
                    return Scaffold(
                        backgroundColor: CustomColors.backgroundBlack,
                        body: const CircularProgressIndicator().wrapCenter());
                  }
                });
          }
          return const LoginScreen();
        }
        return Scaffold(
            backgroundColor: CustomColors.backgroundBlack,
            body: const CircularProgressIndicator().wrapCenter());
      },
    ));
  }
}
