import 'dart:developer';
import 'dart:io';

import 'package:baitap6/blocs/image_bloc.dart';
import 'package:baitap6/blocs/user_bloc.dart';
import 'package:baitap6/model/user_model.dart';
import 'package:baitap6/screens/login.dart';
import 'package:baitap6/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/src/material/date_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  var bloc = new ImageBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile"),
        ),
        body: Column(
          children: [
            StreamBuilder<UserModel>(
                stream: userBloc.stream,
                builder: (context,snapshot){
                   if(snapshot.hasData){
                     return Container(
                       margin: EdgeInsets.all(10),
                       width: double.infinity,
                       height: 150,
                       color: Colors.white,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             width: 110,
                             height: 110,
                             child: Stack(
                               children: [
                                 ClipRRect(
                                   borderRadius: BorderRadius.circular(100),
                                   child: Container(
                                     color: Colors.redAccent[100],
                                     width: 100,
                                     height: 100,
                                     child:  FadeInImage.assetNetwork(
                                             placeholder: "assets/loading.gif",
                                             image:
                                             "${baseUrl}${snapshot.data!.avatar}",
                                             fit: BoxFit.fill,
                                           ) ?? Container()




                                   ),
                                 ),
                                 Positioned(
                                     top: 60,
                                     right: 0,
                                     child: GestureDetector(
                                       onTap: () {
                                         // selectPhoto();
                                         print("d");
                                         showModalBottomSheet(
                                             context: context,
                                             builder: (context) {
                                               return Container(
                                                 margin: EdgeInsets.only(top: 20),
                                                 child: Column(
                                                   children: [
                                                     ListTile(
                                                       trailing: Icon(Icons.image),
                                                       title: Text(
                                                           "Chọn ảnh từ thư viện"),
                                                       onTap: () {
                                                         print("chọn ảnh");
                                                         selectPhoto(true);
                                                       },
                                                     ),
                                                     ListTile(
                                                       trailing: Icon(Icons
                                                           .camera_alt_outlined),
                                                       title: Text("Chụp ảnh mới"),
                                                       onTap: () {
                                                         print("chụp ảnh");
                                                         selectPhoto(false);
                                                       },
                                                     ),
                                                     ListTile(
                                                       trailing: Icon(Icons.cancel),
                                                       title: Text("Cancel"),
                                                       onTap: () {
                                                         Navigator.of(context).pop();
                                                       },
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             });
                                       },
                                       behavior: HitTestBehavior.translucent,
                                       child: Container(
                                         width: 40,
                                         height: 40,
                                         decoration: BoxDecoration(
                                             color: Colors.black45,
                                             borderRadius:
                                             BorderRadius.circular(20)),
                                         child: Icon(
                                           Icons.camera_alt_outlined,
                                           color: Colors.white,
                                         ),
                                       ),
                                     ))
                               ],
                             ),
                           ),
                           Expanded(
                               child: Container(
                                 margin: EdgeInsets.only(left: 15, top: 10),
                                 child:Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       "${snapshot.data!.name}",
                                       style: TextStyle(
                                           fontSize: 22,
                                           fontWeight: FontWeight.w700),
                                     ),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     Text(
                                       "Ngày sinh: ${snapshot.data!.dateOfBirth}",
                                       style: TextStyle(
                                         color: Colors.black,
                                       ),
                                     ),
                                     SizedBox(
                                       height: 3,
                                     ),
                                     Text(
                                       "Email: ${snapshot.data!.email}",
                                       style: TextStyle(color: Colors.black),
                                     ),
                                     SizedBox(
                                       height: 3,
                                     ),
                                     Text(
                                       "Địa chỉ: ${snapshot.data!.address}",
                                       style: TextStyle(color: Colors.black),
                                     )
                                   ],
                                 ),
                               ))
                         ],
                       ),
                     );
                   }
                   else return Lottie.asset("assets/cat.json");

            })
            // GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () {},
            //     child: Center(
            //       child: Container(
            //         width: 250,
            //         height: 40,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             color: Colors.white,
            //             boxShadow: [
            //               BoxShadow(color: Colors.black54, blurRadius: 1)
            //             ]),
            //         child: Center(
            //           child: Text(
            //             "Chỉnh sửa thông tin ",
            //             style: TextStyle(
            //                 color: Colors.blue,
            //                 fontWeight: FontWeight.w700,
            //                 fontSize: 17),
            //           ),
            //         ),
            //       ),
            //     ))
          ],
        )
    );
  }

  final picker = ImagePicker();

  void selectPhoto(bool choss) async {
    final PickedFile? pickedFile;
    if (choss == true) {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery); //imageso.gallery
    } else {
      pickedFile =
          await picker.getImage(source: ImageSource.camera); //imageso.gallery
    }
    if (pickedFile != null) {
      image = File(pickedFile.path);
      print("name image: " + image!.path.toString());
      // bloc.postImage(image!, userBloc.u.token.toString());
    } else {
      print("ImageScreenState select phôt fail");
    }
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Center(
                child: Text(
                  "Xem trước",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: 200,
                child: Image.file(image!),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        bloc.postImage(image!, userBloc.u.token.toString());
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(color: Colors.black54, blurRadius: 1)
                              ]),
                          child: Center(
                            child: Text(
                              "Xác nhận",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(color: Colors.black54, blurRadius: 1)
                              ]),
                          child: Center(
                            child: Text(
                              "Hủy",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ))
                ],
              )
            ],
          );
        });
  }
}
