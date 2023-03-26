import 'package:boap_app/services/histoy_details.dart';
import 'package:boap_app/services/user_details.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen(
      {Key? key, required this.balance, required this.paymentHistory})
      : super(key: key);
  final String balance;
  final List<PaymentDetails> paymentHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Account Details', style: GoogleFonts.roboto()),
      ),
      backgroundColor: CustomColors.backgroundBlack,
      body: ListView(
        physics: const ClampingScrollPhysics(),
          children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomColors.secondaryBack),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${UserDetails.currentUser.firstName} ${UserDetails.currentUser.lastName}',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  color: CustomColors.white,
                ),
              ).paddingWithSymmetry(vertical: 4),
              Text(
                'E-mail: ${UserDetails.currentUser.email}',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  color: CustomColors.white,
                ),
              ).paddingWithSymmetry(vertical: 4),
              Text(
                'UPI ID: ${UserDetails.currentUser.upiId}',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  color: CustomColors.white,
                ),
              ).paddingWithSymmetry(vertical: 4),
            ],
          ).paddingForAll(8),
        ).paddingWithSymmetry(horizontal: 16, vertical: 20),
        RichText(
            text: TextSpan(
                children: [TextSpan(text: 'Current Account Balance is ', style: GoogleFonts.roboto(
                  fontSize: 20
                )),
                TextSpan(text: '₹$balance', style: GoogleFonts.roboto(
                  color: CustomColors.primaryOrange,
                  fontSize: 20
                ))])).paddingWithSymmetry(horizontal: 20),
        Divider(
          color: Colors.black.withOpacity(0.5),
          thickness: 2,
        ).paddingWithSymmetry(horizontal: 20),
        Text('Payment History', style: GoogleFonts.roboto(
          fontStyle: FontStyle.italic,
          color: CustomColors.white,
          fontSize: 26
        ),).paddingWithSymmetry(horizontal: 20, vertical: 10),
            (paymentHistory.isEmpty) ? Text('You haven\'t done any payments yet', style: GoogleFonts.roboto(
              fontSize: 18,
              color: CustomColors.white
            ),).wrapCenter() : ListView.separated(
              shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CustomColors.secondaryBack,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(paymentHistory[index].upi, style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 18
                            ),),
                            Text(paymentHistory[index].amount, style: GoogleFonts.roboto(
                              color: (paymentHistory[index].status == Payment.sent)? Colors.red : Colors.green,
                              fontSize: 18
                            ),)
                          ],
                        ).paddingWithSymmetry(horizontal: 20),
                      ],
                    ),
                  ).paddingWithSymmetry(horizontal: 20);
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black.withOpacity(0.5),
                  thickness: 2,
                ).paddingWithSymmetry(horizontal: 20), itemCount: paymentHistory.length)
      ]),
    );
  }
}
