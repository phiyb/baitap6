import 'dart:async';
import 'dart:io';

import 'package:baitap6/blocs/user_bloc.dart';
import 'package:baitap6/model/image_model.dart';
import 'package:baitap6/model/user_model.dart';
import 'package:baitap6/services/api_service.dart';
import 'package:baitap6/services/image_service.dart';
import 'package:flutter/cupertino.dart';

class ImageBloc {
  final _streamController = StreamController<ImageModel>();

  Stream<ImageModel> get stream => _streamController.stream;

  static var img = new ImageModel();

  ImageBloc() {
    // // getUsers();
    // print("khoi tao");
    //  img.path="/uploads/2021-07-07/aa972319520649bcbe995784fedfea85.jpg";
    //  _streamController.sink.add(img);
  }

  void dispose() {
    _streamController.close();
  }

  Future postImage(File image, String token) async {
    Map<String, String> headers = new Map<String, String>();
    headers["Authorization"] = "Bearer ${token}";
    print(image.path.toString());
    await apiService.postImage(
        onSuccess: (data) {
          print(data.path);

          _streamController.sink.add(data);
          UserBloc userBloc = new UserBloc();
          UserModel user = userBloc.u;
          user.avatar = data.path;
          userBloc.updateUser(user);
        },
        onFailure: (error) {},
        pa: image.path.toString(),
        paths: '/api/upload',
        headers: headers);
  }
}
