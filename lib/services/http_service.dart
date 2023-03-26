import 'dart:convert';
import 'package:boap_app/services/base_response.dart';
import 'package:boap_app/services/histoy_details.dart';
import 'package:boap_app/services/secure_service.dart';
import 'package:boap_app/services/shop_details.dart';
import 'package:boap_app/services/user_details.dart';
import 'package:http/http.dart' as http;

class HTTPService {
  static const String _baseUrl = 'boap-server.azurewebsites.net';

  HTTPService() : _httpClient = http.Client();

  final http.Client _httpClient;

  Map<String, String> _getHeaders(String token) =>
      {'Authorization': 'Bearer $token'};

  Future<BaseResponse> verifyOtp(
      {required String phone, required String otp}) async {
    final uri = Uri.https(_baseUrl, '/auth/login');
    final body = {"phoneNumber": phone, "otp": otp};
    final response = await _httpClient.post(uri, body: body);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      SecureService secure = SecureService();
      secure.setToken(res['token']);
      UserDetails.currentUser = UserDetails(
          firstName: res['firstName'],
          lastName: res['lastName'],
          upiId: res['userUpi'],
          phone: res['phoneNumber'],
          balance: res['balance'],
          email: res['email']);
      return BaseResponse(msg: 'Login Success', responseCode: 200);
    } else {
      return BaseResponse(msg: 'Login Failed', responseCode: 220);
    }
  }

  Future<BaseResponse> setUserDetails(
      {required String token,
      required String firstName,
      required String lastName,
      required String email,
      required String gender}) async {
    final uri = Uri.https(_baseUrl, '/user/updateuser');
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender
    };
    final response =
        await _httpClient.put(uri, body: body, headers: _getHeaders(token));
    print(response.body);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      UserDetails.currentUser = UserDetails(
          firstName: res['firstName'],
          upiId: res['userUpi'],
          lastName: res['lastName'],
          phone: res['phoneNumber'],
          balance: res['balance'],
          email: res['email']);
      return BaseResponse(
          msg: 'User details updated', responseCode: response.statusCode);
    } else {
      return BaseResponse(
          msg: 'Something went wrong', responseCode: response.statusCode);
    }
  }

  Future<BaseResponse?> getUserDetails(String token) async {
    final uri = Uri.https(_baseUrl, '/user/getUser');
    final response = await _httpClient.get(uri, headers: _getHeaders(token));
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print(res);
      UserDetails.currentUser = UserDetails(
          firstName: res['firstName'],
          lastName: res['lastName'],
          phone: res['phoneNumber'],
          upiId: res['userUpi'],
          balance: res['balance'],
          email: res['email']);
      return BaseResponse(msg: 'Data Fetched', responseCode: 200);
    } else {
      return BaseResponse(
          msg: 'Something went wrong', responseCode: response.statusCode);
    }
  }

  Future sendMoney(String token, String amount, String otherUpi) async {
    final uri = Uri.https(_baseUrl, '/payment/sendpayment');
    final body = {'upiId': otherUpi, 'amount': amount};
    final response =
        await _httpClient.post(uri, body: body, headers: _getHeaders(token));
    print(response.body);
    print(response.statusCode);
  }

  Future<ShopDetails> getShops(
      {required String token,
      required String lat,
      required String long}) async {
    final uri = Uri.https(_baseUrl, '/user/nearbyshop');
    final body = {'lat': lat, 'lon': long};
    final response =
        await _httpClient.post(uri, body: body, headers: _getHeaders(token));
    final List res = jsonDecode(response.body);
    if (response.statusCode == 200 && res.isNotEmpty) {
      final res = jsonDecode(response.body);
      print(res);
      final List<ProductDetails> all = [];
      for(Map<String, dynamic> pro in res[0]['itemList']) {
        all.add(ProductDetails.fromMap(pro));
      }
      final List<ProductDetails> top = [];
      for(Map<String, dynamic> pro in res[0]['topList']) {
        top.add(ProductDetails.fromMap(pro));
      }
      return ShopDetails(
          shopName: res[0]['shopName'].toString(),
          shopUpi: res[0]['shopUpi'].toString(),
        topProducts: top,
        allProducts: all
          );
    } else {
      return ShopDetails(shopName: '', shopUpi: '', allProducts: [], topProducts: []);
    }
  }

  Future<HistoryDetails> getHistory(String token) async {
    final uri = Uri.https(_baseUrl, '/user/getbalance');
    final response = await _httpClient.get(uri, headers: _getHeaders(token));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      List<PaymentDetails> historyList = [];
      for (Map<String, dynamic> payment in res['paymentHistory']) {
        double amt = payment['amount'] * 1.0;
        Payment status = Payment.received;
        if (amt < 0) {
          status = Payment.sent;
        }
        String upi = '';
        if (status == Payment.sent) {
          upi = payment['to'];
        } else {
          upi = payment['from'];
        }
        historyList.add(PaymentDetails(
            status: status, amount: amt.abs().toString(), upi: upi));
      }
      HistoryDetails history = HistoryDetails(
          balance: res['balance'].toString(), history: historyList);
      return history;
    } else {
      List<PaymentDetails> historyList = [];
      return HistoryDetails(balance: '', history: historyList);
    }
  }
}
