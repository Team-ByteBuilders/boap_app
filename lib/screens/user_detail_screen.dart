import 'package:boap_app/services/secure_service.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/custom_colors.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool isProcessing = false;
  String firstName = '';
  String lastName = '';
  String gender = '';
  String email = '';

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundBlack,
      body: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              'Register',
              style: GoogleFonts.roboto(
                   fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white),
            ).paddingForOnly(bottom: 0, top: 50),
            Text(
              'Enter some additional details to take off!!',
              style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryOrange),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: CustomColors.primaryOrange,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700),
              validator: (value) {
                if (value == null) {
                  return 'First name cannot be empty';
                }
                return null;
              },
              onChanged: (value) {
                firstName = value;
              },
              decoration: InputDecoration(
                hintText: 'First Name',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 18,
                    color: CustomColors.primaryOrange.withOpacity(0.4)),
                focusedBorder: const UnderlineInputBorder(
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
            TextFormField(
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: CustomColors.primaryOrange,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700),
              onChanged: (value) {
                lastName = value;
              },
              decoration: InputDecoration(
                hintText: 'Last Name',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 18,
                    color: CustomColors.primaryOrange.withOpacity(0.4)),
                focusedBorder: const UnderlineInputBorder(
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
            TextFormField(
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: CustomColors.primaryOrange,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700),
              validator: (value) {
                if (EmailValidator.validate(email)) {
                  return null;
                }
                return 'Invalid Email';
              },
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 18,
                    color: CustomColors.primaryOrange.withOpacity(0.4)),
                focusedBorder: const UnderlineInputBorder(
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
              alignment: Alignment.bottomRight,
              child: primaryButton(context,
                  label: 'Next',
                  // onPressed: () => ,
                  onPressed: () => buttonPressed(),
                  processing: isProcessing),
            ))
          ],
        ).paddingWithSymmetry(horizontal: 20, vertical: 20),
      ),
    );
  }

  Future<void> buttonPressed() async {
    setState(() {
      isProcessing = true;
    });
    if (_key.currentState!.validate()) {
      print(firstName);
      print(lastName);
      print(email);
      SecureService storage = SecureService();
      final res = await storage.setUserDetails(
          firstName: firstName,
          lastName: lastName,
          email: email,
          gender: 'Male');
      if(res?.responseCode == 200) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
      } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res!.msg)));
      }
    }
    setState(() {
      isProcessing = false;
    });
  }
}
