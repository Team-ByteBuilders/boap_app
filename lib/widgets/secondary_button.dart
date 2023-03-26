import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget secondaryButton(BuildContext context,
    {required VoidCallback onPressed,
      required String label, double height = 50}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          fixedSize: Size(MediaQuery.of(context).size.width, height),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      child:Text(
        label,
        style: GoogleFonts.sourceSansPro(
            fontSize: 22, fontWeight: FontWeight.w700),
      ));
}