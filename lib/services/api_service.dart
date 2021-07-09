import 'dart:convert';
import 'package:baitap6/model/image_model.dart';
import 'package:http/http.dart' as http;
import 'error.dart';

enum Method { get, post, put, delete }
//http://report.bekhoe.vn/api/issues?limit=10&offset=10
final ApiService apiService = ApiService();
const baseUrl = 'http://report.bekhoe.vn';

// chỗ này phải truyền url vào constructor
class ApiService {
  factory ApiService() => _apiService;
  static final _apiService = ApiService._internal();

  // late String baseUrl;//cái này để thay đổi mỗi lần gọi
  ApiService._internal();

  Future<void> request({
    required String path,
    required Method method,
    dynamic? parameters,
    Map<String, String>? headers,
    Function(dynamic)? onSuccess,
    Function(String)? onFailure,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://report.bekhoe.vn/api/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', parameters));
    request.headers.addAll(headers!);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      final json = jsonDecode(await response.stream.bytesToString());
      print(json);
      // ImageModel img= ImageModel.fromJson(json);
      onSuccess!(json);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> requestS({
    required String path,
    required Method method,
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Function(dynamic)? onSuccess,
    Function(String)? onFailure,
  }) async {
    parameters ??= {};
    headers ??= {};

    final accessToken = 'Bearer token';
    if (parameters["file"] == null) {
      print("haha file khong hề có");
    }
    print(baseUrl + path);
    // print('$_headers');
    late http.Response res;
    try {
      final url = Uri.parse(baseUrl + path);

      switch (method) {
        case Method.get:
          res = await http.get(url, headers: headers);
          break;
        case Method.post:
          if (parameters["file"] == null) {
            res = await http.post(
              url,
              headers: headers,
              body: parameters,
              encoding: utf8,
            );
          } else {
            var request = http.MultipartRequest(
                'POST', Uri.parse('http://report.bekhoe.vn/api/upload'));
            request.files.add(
                await http.MultipartFile.fromPath('file', parameters["file"]));
            request.headers.addAll(headers);

            res = await http.Response.fromStream(await request.send());
          }
          break;
        case Method.put:
          res = await http.put(
            url,
            headers: headers,
            body: parameters,
            encoding: utf8,
          );
          break;
        case Method.delete:
          res = await http.delete(url, headers: headers);
          break;
        default:
          res = await http.get(url, headers: headers);
          break;
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body);

        print("kkkk");
        //    onSuccess!(json);

        final code = json['code'];
        if (code == 0) {
          if (onSuccess != null) {
            print(json);
            onSuccess(json);
          }
        } else if (onFailure != null) {
          onFailure(serviceError(code) ?? json['message']);
        }
      } else if (res.statusCode == 401) {
        forceLogout(message: 'Phiên đăng nhập đã hết hạn');
      } else {
        print('http status code: ${res.statusCode} \n ${res.body}');
        if (onFailure != null) {
          onFailure('Hệ thống đang bận, vui lòng thử lại sau');
        }
      }
    } catch (e) {
      print('api_service try catch: ${baseUrl + path}');
      if (onFailure != null) {
        onFailure('Có lỗi đã xảy ra, vui lòng thử lại');
      }
    }
  }

  void forceLogout({String? message}) {
    print('logout... $message');
  }
}
