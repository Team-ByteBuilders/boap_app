import 'package:boap_app/services/secure_service.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_colors.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({Key? key}) : super(key: key);

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String amount = '';
  String upi = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Send Money to Upi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(amount);
          print(upi);
          SecureService secure = SecureService();
          secure.sendMoney(amount, upi);
          },
        backgroundColor: CustomColors.primaryOrange,
        child: const Icon(Icons.arrow_right_alt_outlined),
      ),
      body: ListView(
        children: [
          Text(
            'Enter Amount',
            style: GoogleFonts.roboto(
                color: CustomColors.white,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          ).paddingWithSymmetry(horizontal: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: CustomColors.primaryOrange,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700),
            validator: (value) {
              if (value != null) {
                return null;
              } else {
                return 'Amount cannot be empty';
              }
            },
            onChanged: (value) {
              amount = value;
            },
            decoration: InputDecoration(
              prefix: Text(
                '₹ ',
                style:
                    GoogleFonts.roboto(fontSize: 18, color: CustomColors.white),
              ),
              hintText: '100',
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
          ).paddingWithSymmetry(horizontal: 20, vertical: 0),
          Text(
            'Enter Receiver UPI Id',
            style: GoogleFonts.roboto(
                color: CustomColors.white,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          ).paddingForOnly(left: 20, right: 20, top: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: CustomColors.primaryOrange,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700),
            validator: (value) {
              if (value != null) {
                return null;
              } else {
                return 'UPI cannot be empty';
              }
            },
            onChanged: (value) {
              upi = value;
            },
            decoration: InputDecoration(
              prefix: Text(
                '   ',
                style:
                    GoogleFonts.roboto(fontSize: 18, color: CustomColors.white),
              ),
              hintText: 'xyz@upi',
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
          ).paddingWithSymmetry(horizontal: 20, vertical: 0).wrapCenter()
        ],
      ),
    );
  }
}
