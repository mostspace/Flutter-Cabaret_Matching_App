import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datingapp/src/constants/app_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:datingapp/src/routing/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:datingapp/src/widgets/progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_controllers.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddPanelScreen extends ConsumerStatefulWidget {
  const AddPanelScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<AddPanelScreen> createState() => _AddPanelScreenState();
}

class _AddPanelScreenState extends ConsumerState<AddPanelScreen> {
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  File? imageFile4;
  File? imageFile5;
  File? imageFile6;
  String? avaImg1;
  String? previewImg1;
  String? avaImg2;
  String? previewImg2;
  String? avaImg3;
  String? previewImg3;
  String? avaImg4;
  String? previewImg4;
  String? avaImg5;
  String? previewImg5;
  String? avaImg6;
  String? previewImg6;
  List<File> selectedImage = [];
  List<String> avaImgPaths = [];
  List<String> previewImgPaths = [];
  
  final _contentData = TextEditingController();
  String get content => _contentData.text;

  Future imageSelector(BuildContext context, String pickerType) async {
    final File image;
    switch (pickerType) {
      case "gallery":
        /// GALLERY IMAGE PICKER
        final XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.gallery, imageQuality: 90);
        if (pickedFile == null) return;
        image = File(pickedFile.path);
        setState(() {
          if(avaImg1 == null) {
            imageFile1 = image;
            avaImg1 = pickedFile.path.split('/').last;
            previewImg1 = pickedFile.path;
          } 
          else if(avaImg1 != null && avaImg2 == null && avaImg3 == null && avaImg4 == null && avaImg5 == null && avaImg6 == null) {
            imageFile2 = image;
            avaImg2 = pickedFile.path.split('/').last;
            previewImg2 = pickedFile.path;
          }
          else if(avaImg2 != null && avaImg1 != null && avaImg3 == null && avaImg4 == null && avaImg5 == null && avaImg6 == null) {
            imageFile3 = image;
            avaImg3 = pickedFile.path.split('/').last;
            previewImg3 = pickedFile.path;
          }
          else if(avaImg3 != null && avaImg1 != null && avaImg2 != null && avaImg4 == null && avaImg5 == null && avaImg6 == null) {
            imageFile4 = image;
            avaImg4 = pickedFile.path.split('/').last;
            previewImg4 = pickedFile.path;
          }
          else if(avaImg4 != null && avaImg1 != null && avaImg2 != null && avaImg3 != null && avaImg5 == null && avaImg6 == null) {
            imageFile5 = image;
            avaImg5 = pickedFile.path.split('/').last;
            previewImg5 = pickedFile.path;
          }
          else if(avaImg4 != null && avaImg1 != null && avaImg2 != null && avaImg3 != null && avaImg5 != null && avaImg6 == null) {
            imageFile6 = image;
            avaImg6 = pickedFile.path.split('/').last;
            previewImg6 = pickedFile.path;
          }
        });
        break;

      case "camera": // CAMERA CAPTURE CODE
        final XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.camera, imageQuality: 90);
        if (pickedFile == null) return;
        image = File(pickedFile.path);
        setState(() {
          if(avaImg1 == null) {
            imageFile1 = image;
            avaImg1 = pickedFile.path.split('/').last;
            previewImg1 = pickedFile.path;
          } 
          else if(avaImg1 != null && avaImg2 == null && avaImg3 == null && avaImg4 == null && avaImg5 == null && avaImg6 == null) {
            imageFile2 = image;
            avaImg2 = pickedFile.path.split('/').last;
            previewImg2 = pickedFile.path;
          }
          else if(avaImg2 != null && avaImg1 != null && avaImg3 == null && avaImg4 == null && avaImg5 == null && avaImg6 == null) {
            imageFile3 = image;
            avaImg3 = pickedFile.path.split('/').last;
            previewImg3 = pickedFile.path;
          }
          else if(avaImg3 != null && avaImg1 != null && avaImg2 != null && avaImg4 == null && avaImg5 == null && avaImg6 == null) {
            imageFile4 = image;
            avaImg4 = pickedFile.path.split('/').last;
            previewImg4 = pickedFile.path;
          }
          else if(avaImg4 != null && avaImg1 != null && avaImg2 != null && avaImg3 != null && avaImg5 == null && avaImg6 == null) {
            imageFile5 = image;
            avaImg5 = pickedFile.path.split('/').last;
            previewImg5 = pickedFile.path;
          }
          else if(avaImg4 != null && avaImg1 != null && avaImg2 != null && avaImg3 != null && avaImg5 != null && avaImg6 == null) {
            imageFile6 = image;
            avaImg6 = pickedFile.path.split('/').last;
            previewImg6 = pickedFile.path;
          }
        });
        break;
    }
    Navigator.pop(context);
  }
  
  Future<void> submit() async{
    
    if (avaImg1 == "" || avaImg1 == null) {
      showErrorToastMessage("写真を選択してください。 ");
      return;
    }
    if (avaImg2 == "" || avaImg2 == null) {
      showErrorToastMessage("写真を選択してください。 ");
      return;
    }
    if (content == "" || content == null) {
      showErrorToastMessage("内容を入力してください。 ");
      return;
    }
    String image3 = "";
    String image4 = "";
    String image5 = "";
    String image6 = "";
    avaImg3 == null ? image3 = "" : image3 = avaImg3!;
    avaImg4 == null ? image4 = "" : image4 = avaImg4!;
    avaImg5 == null ? image5 = "" : image5 = avaImg5!;
    avaImg6 == null ? image6 = "" : image6 = avaImg6!;
    // try to login with input data.
    
    List<int> imageBytes1 = imageFile1!.readAsBytesSync();
    List<int> imageBytes2 = imageFile2!.readAsBytesSync();
    
    String baseimage1 = base64Encode(imageBytes1);
    String baseimage2 = base64Encode(imageBytes2);
    String baseimage3 = "";
    String baseimage4 = "";
    String baseimage5 = "";
    String baseimage6 = "";
    if (imageFile3 != null) {
        List<int> imageBytes3 = imageFile3!.readAsBytesSync();
        if (imageBytes3.isNotEmpty) {
            baseimage3 = base64Encode(imageBytes3);
            // Store baseimage3 in the directory
        }
    }

    if (imageFile4 != null) {
        List<int> imageBytes4 = imageFile4!.readAsBytesSync();
        if (imageBytes4.isNotEmpty) {
            baseimage4 = base64Encode(imageBytes4);
            // Store baseimage4 in the directory
        }
    }

    if (imageFile5 != null) {
        List<int> imageBytes5 = imageFile5!.readAsBytesSync();
        if (imageBytes5.isNotEmpty) {
            baseimage5 = base64Encode(imageBytes5);
            // Store baseimage5 in the directory
        }
    }

    if (imageFile6 != null) {
        List<int> imageBytes6 = imageFile6!.readAsBytesSync();
        if (imageBytes6.isNotEmpty) {
            baseimage6 = base64Encode(imageBytes6);
            // Store baseimage6 in the directory
        }
    }
    final controller = ref.read(loginControllerProvider.notifier);
    controller.doAddData(avaImg1!, avaImg2!, image3, image4, image5, image6, baseimage1, baseimage2, baseimage3, baseimage4, baseimage5, baseimage6, content).then(
      (value) async{
        // go home only if login success.
        if (value == true) {
          setState(() {
            avaImg1 = null;
            previewImg1=null;
            avaImg2=null;
            previewImg2=null;
            avaImg3=null;
            previewImg3=null;
            avaImg4=null;
            previewImg4=null;
            avaImg5=null;
            previewImg5=null;
            avaImg6=null;
            previewImg6=null;
            _contentData.clear();
          });
        } else {}
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
            children: [
              Expanded(
                child: Container(
                  child: Image.asset(
                    'assets/images/icon/dot.png',
                    height: 30,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                child: Container(
                  child: Image.asset(
                    'assets/images/icon/text.png',
                    height: 30,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                child: InkWell(
                  onTap: () {
                    submit();
                  },
                  child: Container(
                    child: Image.asset(
                      'assets/images/icon/send_btn.png',
                      height: 30,
                    ),
                  ),
                )
              )
            ],
          ),
        ),
          
        SizedBox(height: 40,),
        Container(
          width: 100 * 3.5,
          child: Row(
            children: [
              Container(
                width: 70.0,
                height: 70.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    margin: EdgeInsets.zero,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            0), // Add the desired border radius here
                        child: avaImg1 == null? Image.asset(
                          "assets/images/icon/empty.png",
                          height: 10,
                        ): ClipRRect(
                          // borderRadius: BorderRadius.circular(150.0),
                          child: previewImg1 != null ?Image.file(File(previewImg1!),
                              fit: BoxFit.cover, width: 10, height: 10):Container())
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(
                width: 15,
              ),

              Container(
                width: 70.0,
                height: 70.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    margin: EdgeInsets.zero,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            0), // Add the desired border radius here
                        child: avaImg2 == null? Image.asset(
                          "assets/images/icon/empty.png",
                          height: 10,
                        ): ClipRRect(
                          // borderRadius: BorderRadius.circular(150.0),
                          child: previewImg2 != null ?Image.file(File(previewImg2!),
                              fit: BoxFit.cover, width: 10, height: 10):Container())
                      ),
                    ),
                  ),
                ),
              ),
              
              avaImg3 != null ?
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 70.0,
                    height: 70.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.zero,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0), // Add the desired border radius here
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(150.0),
                              child: previewImg3 != null ?Image.file(File(previewImg3!),
                                  fit: BoxFit.cover, width: 10, height: 10):Container())
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ): Container(),

              avaImg4 != null ?
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 70.0,
                    height: 70.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.zero,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0), // Add the desired border radius here
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(150.0),
                              child: previewImg4 != null ?Image.file(File(previewImg4!),
                                  fit: BoxFit.cover, width: 10, height: 10):Container())
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ): Container(),

              SizedBox(
                width: 10,
              ),

              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.0), // Adjust the radius as needed
                      ),
                    ),
                    builder: (BuildContext context) {
                      return  Container(
                        height: MediaQuery.of(context).size.height  / 7, // Set the height as needed
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 20, top: 15),
                              child: InkWell(
                                onTap: () {
                                  imageSelector(context, "camera");
                                },
                                child: const Row(
                                  children: [
                                    Image(image: AssetImage('assets/images/icon/camera.png'), height: 30,),
                                    SizedBox(width: 10,),
                                    Text("カメラを使用して写真を撮る")
                                  ],
                                ),     
                              )  
                            ),
                            
                            Padding(padding: EdgeInsets.only(left: 20, top: 10),
                              child: InkWell(
                                onTap: () {
                                  imageSelector(context, "gallery");
                                },
                                child: const Row(
                                  children: [
                                    Image(image: AssetImage('assets/images/icon/gallery.png'), height: 30,),
                                    SizedBox(width: 10,),
                                    Text("書庫から写真を読み込む")
                                  ],
                                ),   
                              )    
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: avaImg6 == null ? Container(
                  child: Image.asset(
                    'assets/images/navbar_icon/add1.png',
                    height: 30,
                  ),
                ): Container()
              ),
            ],
          ),
        ),
        Container(
          width: 100 * 3.5,
          height: avaImg5 == null ? 20: 100,
          child: Row(
            children: [
              
              avaImg5 != null ?
              Row(
                children: [
                  Container(
                    width: 70.0,
                    height: 70.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.zero,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0), // Add the desired border radius here
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(150.0),
                              child: previewImg5 != null ?Image.file(File(previewImg5!),
                                  fit: BoxFit.cover, width: 10, height: 10):Container())
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ): Container(),

              avaImg6 != null ?
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 70.0,
                    height: 70.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.zero,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0), // Add the desired border radius here
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(150.0),
                              child: previewImg6 != null ?Image.file(File(previewImg6!),
                                  fit: BoxFit.cover, width: 10, height: 10):Container())
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ): Container(),

              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),

        SizedBox(
          width: 100 * 3.5,
          child: Container(
            padding: EdgeInsets.all(0.0),
            child: TextField(
              controller: _contentData,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: '投稿メッセージ',
                filled: true,
                fillColor: Color.fromARGB(255, 248, 244, 244),  // Set the background color to white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),  // Set the border radius to 10
                    borderSide: BorderSide(color: Color.fromARGB(255, 155, 110, 124)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
