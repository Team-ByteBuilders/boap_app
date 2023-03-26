import 'package:boap_app/services/shop_details.dart';
import 'package:boap_app/utils/custom_colors.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key, required this.details}) : super(key: key);
  final ShopDetails details;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.details.topProducts.length);
    return Scaffold(
      backgroundColor: CustomColors.backgroundBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(widget.details.shopName),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Top Items', style: GoogleFonts.roboto(
            color: CustomColors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700
          ),).paddingForOnly(bottom: 10),
          ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                var current = widget.details.topProducts[index];
            return Container(
              decoration: BoxDecoration(
                color: CustomColors.secondaryBack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(current.name.toUpperCase(), style: GoogleFonts.roboto(
                    color: CustomColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),).paddingWithSymmetry(horizontal: 8),
                  Text('₹ ${current.price}', style: GoogleFonts.roboto(
                      color: CustomColors.primaryOrange,
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),).paddingWithSymmetry(horizontal: 8),
                ],
              ).paddingWithSymmetry(horizontal: 4, vertical: 12),
            );
          }, separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
            );
          }, itemCount: widget.details.topProducts.length),
          Text('All Items', style: GoogleFonts.roboto(
              color: CustomColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700
          ),).paddingForOnly(bottom: 10, top: 20),
          ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                var current = widget.details.allProducts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: CustomColors.secondaryBack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(current.name.toUpperCase(), style: GoogleFonts.roboto(
                          color: CustomColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),).paddingWithSymmetry(horizontal: 8),
                      Text('₹ ${current.price}', style: GoogleFonts.roboto(
                          color: CustomColors.primaryOrange,
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),).paddingWithSymmetry(horizontal: 8),
                    ],
                  ).paddingWithSymmetry(horizontal: 4, vertical: 12),
                );
              }, separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
            );
          }, itemCount: widget.details.allProducts.length) ],
      ).paddingWithSymmetry(horizontal: 16, vertical: 20      ),
    );
  }
}
