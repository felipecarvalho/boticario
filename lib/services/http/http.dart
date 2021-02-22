import 'package:dio/dio.dart';

class HttpService {
  Dio dio = Dio();

  Future getData(url) async {
    var response = await dio.get(url);
    return response.data;
  }
}
