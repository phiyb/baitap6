import 'dart:io';

import 'package:baitap6/model/user_model.dart';
import 'api_service.dart';

extension UserService on ApiService {
  Future<void> loginUser(
      {required String paths,
      required Function(UserModel) onSuccess,
      required dynamic pa,
      required Function(String) onFailure,
      required Map<String, String> headers}) async {
    await requestS(
        path: paths,
        method: Method.post,
        parameters: pa,
        onSuccess: (json) {
          UserModel user = new UserModel();
          user = UserModel.fromJson(json["data"]);
          onSuccess(user);
        },
        onFailure: onFailure,
        headers: headers);
  }
}
