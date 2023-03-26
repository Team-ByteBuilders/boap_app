import 'package:boap_app/screens/otp_screen.dart';
import 'package:boap_app/utils/custom_colors.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String number = "";
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundBlack,
      body: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              'Welcome',
              style: GoogleFonts.roboto(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white),
            ).paddingForOnly(bottom: 0, top: 50),
            Text(
              'Enter your mobile number to get started',
              style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryOrange),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: CustomColors.primaryOrange,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700),
              validator: (value) {
                if (value != null && value.length == 10) {
                  return null;
                } else {
                  return 'Enter valid number';
                }
              },
              onChanged: (value) {
                number = value;
              },
              decoration: InputDecoration(
                // label: const Text('Phone Number'),
                // labelStyle: const TextStyle(
                //   color: CustomColors.primaryOrange
                // ),
                prefix: Text(
                  '+91 ',
                  style: GoogleFonts.roboto(
                      fontSize: 18, color: CustomColors.white),
                ),
                hintText: '1234567890',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 18,
                    color: CustomColors.primaryOrange.withOpacity(0.4)),
                focusedBorder: const UnderlineInputBorder(
                  // borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CustomColors.primaryOrange,
                    width: 2,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  // borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CustomColors.primaryOrange.withOpacity(0.4),
                    width: 2,
                  ),
                ),
              ),
            ).paddingForOnly(bottom: 20),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('Assets/login_image.png'))),
            Align(
              alignment: Alignment.bottomRight,
              child: primaryButton(context,
                  label: 'Next',
                  onPressed: () => buttonPressed(),
                  processing: isProcessing),
            )
          ],
        ).paddingWithSymmetry(horizontal: 16, vertical: 20),
      ),
    ).asButton(onTap: () => FocusManager.instance.primaryFocus?.unfocus());
  }

  Future<void> buttonPressed() async {
    if (!isProcessing) {
      setState(() {
        isProcessing = true;
      });
      if (key.currentState!.validate()) {
        debugPrint(number);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OTPScreen(phone: number)));
        // HTTPService http = HTTPService();
        // final response = await http.login(phone: number);
        // if (response != null) {
        //   if (response.responseCode == 200) {
        //     String token = response.msg;
        //     SecureStorage storage = SecureStorage();
        //     storage.setToken(token);
        //     print('user');
        //     await storage.getUserDetails();
        //     print(UserDetails.currentUser.phone);
        //     if(UserDetails.currentUser.phone == null) {
        //       print('sdf');
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => UserDetailsScreen()),
        //               (route) => false);
        //     }
        //     Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (context) => LoadingScreen()),
        //             (route) => false);
        //   } else {
        //     ScaffoldMessenger.of(context).showSnackBar(awesomeBar(
        //         title: 'Failed',
        //         message: response.msg,
        //         contentType: 'failure'));
        //   }
        // }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(awesomeBar(
        //     title: 'Error !!',
        //     message: 'Enter valid Details',
        //     contentType: 'failure'));
      }
      setState(() {
        isProcessing = false;
      });
    }
  }
}
