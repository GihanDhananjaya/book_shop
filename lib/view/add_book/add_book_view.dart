import 'dart:typed_data';
import 'package:book_shop/utils/app_colors.dart';
import 'package:book_shop/view/book_list/book_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_bar.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../common/image_upload_widget.dart';
import '../../entity/chapter_entity.dart';
import 'add_chapter.dart';


class AddBookView extends StatefulWidget {
  @override
  _AddBookViewState createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  String? _selectedImage;
  Uint8List? profileImage;
  String? fileExtension;

  final TextEditingController _textField1Controller = TextEditingController();
  final TextEditingController _textField2Controller = TextEditingController();

  final List<ChapterEntity> chapterEntityList = [];


  Future<String?> _uploadImageToStorage(Uint8List imageBytes, String fileExtension) async {
    try {
      final Reference storageReference =
      FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');
      final UploadTask uploadTask =
      storageReference.putData(imageBytes, SettableMetadata(contentType: 'image/$fileExtension'));

      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addBookToFirebase() async {
    final bookName = _bookNameController.text;
    final authorName = _authorNameController.text;

    if (bookName.isNotEmpty && authorName.isNotEmpty && profileImage != null &&
        fileExtension != null) {
      final firestore = FirebaseFirestore.instance;
      final collection = firestore.collection('books1');

      final imageUrl = await _uploadImageToStorage(profileImage!, fileExtension!);

      if (imageUrl != null) {
        final List<Map<String, dynamic>> chapterDataList = chapterEntityList
            .map((chapter) => {
          'name': chapter.name,
          'story': chapter.story,
        })
            .toList();

        final bookData = {
          'title': bookName,
          'author': authorName,
          'image_url': imageUrl,
          'chapters': chapterDataList, // Add the ListView data here
        };

        final newDocument = await collection.add(bookData);

        setState(() {
          _bookNameController.clear();
          _authorNameController.clear();

          profileImage = null;
          fileExtension = null;

          chapterEntityList.clear(); // Clear the chapter list after storing
          _textField1Controller.clear();
          _textField2Controller.clear();
        });
      } else {
        // Handle the case where image upload fails
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to upload image. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _navigateToAddChapterView() async {
    final newChapter = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddChapterView(),
      ),
    );

    if (newChapter != null) {
      setState(() {
        chapterEntityList.add(newChapter);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BookAppBar(title: 'Add Your Book'),
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          width: 70,
                            buttonText: 'Submit', onTapButton: (){
                          _addBookToFirebase();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookListView()),
                          );
                        }),
                      ],
                    ),
                    ProfileImageUi(title: 'Book Image',
                        onChanged: (bytes, extension){
                          profileImage = bytes;
                          fileExtension = extension;
                        }),
                    SizedBox(height: 20),
                    AppTextField(hint: 'name',controller: _bookNameController),
                    SizedBox(height: 20),
                    AppTextField(hint: 'author',controller: _authorNameController),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: chapterEntityList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.appColorAccent,
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                              child: Text(chapterEntityList[index].name,style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: AppColors.fontColorWhite)),
                            ),
                          ),
                        );
                      },
                    ),
                    // AppButton(
                    //     buttonText: 'Submit', onTapButton: (){
                    //   _addBookToFirebase();
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => BookListView()),
                    //   );
                    // }),
                    SizedBox(height: 20),

                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(40)),
          width: 250,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              Text('Create New Chapter',style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.fontColorWhite)),
              FloatingActionButton(
                onPressed: () {
                  _navigateToAddChapterView();
                },
                child: Icon(Icons.add),
                backgroundColor: AppColors.fontColorGray, // Change the color as needed
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addItem() {
    final String url = _textField1Controller.text.trim();
    final String title = _textField2Controller.text.trim();

    if (url.isNotEmpty && title.isNotEmpty) {
      setState(() {
        chapterEntityList.add(ChapterEntity( name: url, story: title,));
        _textField1Controller.clear();
        _textField2Controller.clear();
      });
    }
  }
}
