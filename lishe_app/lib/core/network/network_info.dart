// import 'package:dio/dio.dart';

// const API_KEY_SPOONACULAR = "b317a79e49d14fd29b549ad8ea3bfb9b";

// class ApiService{
//   final Dio _dio = Dio();

//   ApiService(){
//     _dio.options.baseUrl = "https://api.spoonacular.com/";
//     _dio.options.headers = {
//       "Authorization": "Bearer $API_KEY_SPOONACULAR",
//     };
//   }



//   Future<Response> get(String path, {Map<String, dynamic>? params}) async {
//     final response = await _dio.get(path, queryParameters: params);
//     return response;
//   }

//   Future<Response> post(String path, {Map<String, dynamic>? data}) async {
//     final response = await _dio.post(path, data: data);
//     return response;
//   }

//   Future<Response> put(String path, {Map<String, dynamic>? data}) async {
//     final response = await _dio.put(path, data: data);
//     return response;
//   }
  
  
  
// }