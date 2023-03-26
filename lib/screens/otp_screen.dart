import 'package:boap_app/screens/home_screen.dart';
import 'package:boap_app/services/http_service.dart';
import 'package:boap_app/utils/custom_colors.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:boap_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loading_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String otp = "";
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
              'Verify OTP',
              style: GoogleFonts.roboto(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white),
            ).paddingForOnly(bottom: 0, top: 50),
            Text(
              'Enter the OTP sent to your mobile number',
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
                if (value != null && value.length == 4) {
                  return null;
                } else {
                  return 'Enter valid OTP';
                }
              },
              onChanged: (value) {
                otp = value;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  color: CustomColors.primaryOrange,
                ),
                hintText: 'XXXX',
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
                    child: Image.asset('Assets/otp.png'))),
            Align(
              alignment: Alignment.bottomRight,
              child: primaryButton(context,
                  label: 'Next',
                  // onPressed: () => ,
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
        debugPrint(otp);
        HTTPService http = HTTPService();
        final response = await http.verifyOtp(phone: widget.phone, otp: otp);
        if (response.responseCode == 200) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoadingScreen()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.msg)));
        }
      }
      setState(() {
        isProcessing = false;
      });
    }
  }
}
