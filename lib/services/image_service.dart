

import 'dart:io';

import 'package:baitap6/model/image_model.dart';
import 'api_service.dart';

extension ImageService on ApiService {

  Future<void> postImage({
    required String paths,
    required Function(ImageModel) onSuccess,
    required dynamic pa,
    required Function(String) onFailure,
    required Map<String,String> headers
  }) async {

   await request(
      path: paths,
      method: Method.post,
      parameters: pa,
      onSuccess: (json) {
        ImageModel img =new ImageModel();
        img=   ImageModel.fromJson(json["data"]);
        onSuccess(img);
      },
      onFailure: onFailure, headers: headers
    );

  }

}
