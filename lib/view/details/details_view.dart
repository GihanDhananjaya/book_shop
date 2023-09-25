import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_bar.dart';
import '../../entity/chapter_entity.dart';
import '../../utils/app_colors.dart';
import '../read/read_story_view.dart';

class DetailsView extends StatefulWidget {
  final String title;
  final String author;
  final String? imageUrl;
  final List<ChapterEntity> chapters;

  DetailsView({required this.title, required this.author, this.imageUrl,required this.chapters,});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BookAppBar(
            title: 'Chapters'),
        body: Container(
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
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorAccent)),
                  child: Image.network(widget.imageUrl!,height: 150,width: 100,)),
              SizedBox(height: 10),
              Text(widget.title,style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.fontColorDark)),
              Container(
                height:500,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.chapters.length,
                  itemBuilder: (context, index) {
                    return InkResponse(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReadStoryView(
                            chapterName: widget.chapters[index].name,
                            chapterStory: widget.chapters[index].story,
                          )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColors.appColorAccent,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            child: Text('Chapter ${index + 1}: ${widget.chapters[index].name}',style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColors.fontColorWhite)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
