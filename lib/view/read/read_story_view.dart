import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_bar.dart';
import '../../utils/app_colors.dart';


class ReadStoryView extends StatefulWidget {

  final String chapterName;
  final String chapterStory;


  ReadStoryView({required this.chapterName, required this.chapterStory});

  @override
  State<ReadStoryView> createState() => _ReadStoryViewState();
}

class _ReadStoryViewState extends State<ReadStoryView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BookAppBar(title: 'Read Story'),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Start from the bottom-left corner
              end: Alignment.centerRight,     // End at the top-right corner
              colors: [
                AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
                AppColors.colorPrimary.withOpacity(0.5),   // Color from the bottom-left side (green)
              ],
            ),
          ),
          child: Column(children: [
            SizedBox(height: 20),
            Text(widget.chapterName,style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 26,
                color: AppColors.fontColorDark)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(widget.chapterStory,style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.fontColorDark)),
            ),
          ]),
        ),
      ),
    );
  }
}
