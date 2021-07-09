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
                                    return Lottie.asset("assets/jsonload.json");
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
                                                title: Text("Chọn ảnh từ thư viện"),
                                                onTap: () {
                                                  print("chọn ảnh");
                                                  selectPhoto(true);
                                                },
                                              ),
                                              ListTile(
                                                trailing:
                                                Icon(Icons.camera_alt_outlined),
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
                                      borderRadius: BorderRadius.circular(20)),
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
                                    children: [
                                      Text(
                                        "${snapshot.data!.name}",
                                        style: TextStyle(
                                            fontSize: 22, fontWeight: FontWeight.w700),
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
                          hintText: "Nhập email",
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                    SizedBox(height:16 ,),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Nhập địa chỉ",
                          labelText: "Địa chỉ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                   ElevatedButton(onPressed: () async {
                     DateTime? pic = await showDatePicker(
                       context: context,
                       initialDate: DateTime.now(),
                       firstDate: DateTime(2000),
                       lastDate: DateTime(2025),
                     );
                   }, child: Text("Chọn ngày"))

                  ],
                ),

              )
            ],
          ),
        ),
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
      bloc.postImage(image!, userBloc.u.token.toString());
    } else {
      print("ImageScreenState select phôt fail");
    }
    Navigator.of(context).pop();
  }
}
