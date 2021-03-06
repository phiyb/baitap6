import 'dart:io';

import 'package:baitap6/blocs/image_bloc.dart';
import 'package:baitap6/blocs/user_bloc.dart';
import 'package:baitap6/model/user_model.dart';
import 'package:baitap6/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class EditProfileCreen extends StatefulWidget {
  const EditProfileCreen({Key? key}) : super(key: key);

  @override
  _EditProfileCreenState createState() => _EditProfileCreenState();
}

class _EditProfileCreenState extends State<EditProfileCreen> {
  File? image;
  var bloc = new ImageBloc();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   UserModel u = UserBloc.u;
  //   print("avatar   ${u.avatar}");
  //
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() async{
  //   // TODO: implement didChangeDependencies
  //   Stream<UserModel> ui=UserBloc.stream;
  //   UserModel i=await ui.first;
  //   int a=9;
  //   super.didChangeDependencies();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile"),
        ),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                                color: Colors.red,
                                width: 100,
                                height: 100,
                                child: StreamBuilder<UserModel>(
                                  stream: userBloc.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      // return Text("${baseUrl}${snapshot.data!.avatar}");
                                      return FadeInImage.assetNetwork(
                                        placeholder: "assets/loading.gif",
                                        image:
                                        "${baseUrl}${snapshot.data!.avatar}",
                                        fit: BoxFit.fill,
                                      ) ??
                                          Container();
                                    } else
                                      return Lottie.asset(
                                          "assets/jsonload.json");
                                  },
                                ),
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
                                                      "Ch???n ???nh t??? th?? vi???n"),
                                                  onTap: () {
                                                    print("ch???n ???nh");
                                                    selectPhoto(true);
                                                  },
                                                ),
                                                ListTile(
                                                  trailing: Icon(Icons
                                                      .camera_alt_outlined),
                                                  title: Text("Ch???p ???nh m???i"),
                                                  onTap: () {
                                                    print("ch???p ???nh");
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
                            child: StreamBuilder<UserModel>(
                                stream: userBloc.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data!.name}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text("${snapshot.data!.dateOfBirth}")
                                      ],
                                    );
                                  else
                                    return Container(
                                      child: Text("Rong"),
                                    );
                                }),
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Nh???p email",
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Nh???p ?????a ch???",
                            labelText: "?????a ch???",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 16,),
                      ElevatedButton(
                          onPressed: () async {
                            DateTime? pic = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                            );
                          },
                          child: Text("Ch???n ng??y")),
                      SizedBox(height: 20,),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {

                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            padding: EdgeInsets.only(left: 110,top:15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue
                            ),
                            child: Text("L??u thay ?????i",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 17),),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
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
      bloc.postImage(image!, userBloc.u.token.toString());
    } else {
      print("ImageScreenState select ph??t fail");
    }
    Navigator.of(context).pop();
  }
}

