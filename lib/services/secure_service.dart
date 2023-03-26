import 'dart:developer';

import 'package:boap_app/services/shop_details.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'base_response.dart';
import 'histoy_details.dart';
import 'http_service.dart';

class SecureService {
  final _storage = const FlutterSecureStorage();

  String? _token;
  static const String tokenKey = 'token_key';
  HTTPService http = HTTPService();

  void setToken(String token) {
    _token = token;
    log(token);
    _storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<BaseResponse?> setUserDetails({
        required String firstName,
        required String lastName,
        required String email,
        required String gender}) async {
    _token =  await _storage.read(key: tokenKey);
    return http.setUserDetails(token: _token!, firstName: firstName, lastName: lastName, email: email, gender: gender);
  }

  Future getUserDetails() async {
    _token = await _storage.read(key: tokenKey);
    return http.getUserDetails(_token!);
  }

  Future<ShopDetails> getShops(String lat, String long) async {
    _token = await _storage.read(key: tokenKey);
    return http.getShops(token: _token!, lat: lat, long: long);
  }

  Future sendMoney(String amount, String otherUpi) async {
    _token = await _storage.read(key: tokenKey);
    return http.sendMoney(_token!, amount, otherUpi);
  }

  Future<HistoryDetails> getHistory() async {
    _token = await _storage.read(key: tokenKey);
    return http.getHistory(_token!);
  }

  void clearStorage() {
    setToken("");
  }
}
