import 'dart:async';

import 'package:baitap6/model/user_model.dart';
import 'package:baitap6/services/api_service.dart';
import 'package:baitap6/services/user_server.dart';
import 'package:flutter/material.dart';

class UserBloc {
  late StreamController<UserModel> _streamUserController;
  late Stream<UserModel> stream;
  late UserModel u;

  static final UserBloc _userManager = UserBloc._internal();

  factory UserBloc() {
    return _userManager;
  }

  UserBloc._internal() {
    print('AppData._internal');
    _streamUserController = new StreamController<UserModel>();
    stream = _streamUserController.stream.asBroadcastStream();
    u = new UserModel();
  }

  login(String phone, String pass, BuildContext context) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["PhoneNumber"] = phone;
    map["Password"] = pass;
    apiService.loginUser(
        paths: "/api/accounts/login",
        onSuccess: (data) {
          u = data;
          _streamUserController.sink.add(u);
          if (data.token != null && data != "") {
            Navigator.pushNamed(context, "/profilescreen");
          }
        },
        pa: map,
        onFailure: (error) {
          _streamUserController.addError(error);
        },
        headers: {});
  }

  UserModel updateUser(UserModel u) {
    Map<String, String> headers = new Map<String, String>();
    headers["Authorization"] = "Bearer ${u.token}";

    Map<String, dynamic> map = new Map<String, dynamic>();
    map["name"] = u.name;
    map["avatar"] = u.avatar;

    apiService.loginUser(
        paths: "/api/accounts/update",
        onSuccess: (data) {
          u = data;
          _streamUserController.sink.add(u);
        },
        pa: map,
        onFailure: (error) {
          _streamUserController.addError(error);
        },
        headers: headers);
    return u;
  }

  void dispose() {
    _streamUserController.close();
  }
}

final UserBloc userBloc = UserBloc();
