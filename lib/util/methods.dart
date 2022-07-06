import 'dart:convert';
import 'package:flutter_app/util/cartpage.dart';
import 'package:flutter_app/util/manage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/mail.dart';

const Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class Util {
  static bool emailValidate(String? email) {
    RegExp regex = new RegExp(emailPattern.toString());
    return regex.hasMatch(email.toString());
  }

  static Future<String> getNotificationCount(String? token) async {
    final responseData = await http.get(
        Uri.parse(baseurl + version + notificationlink),
        headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['notificationsArr'];
      List<NotificationsArr> listSCArr = [];
      for (Map i in listsCArr) {
        listSCArr.add(NotificationsArr.fromMap(i as Map<String, dynamic>));
      }
      int count = 0;
      for (var ele in listSCArr) {
        if (ele.status == "unread") {
          count++;
        }
      }
      return count.toString();
    }
    return "";
  }

  static Future<String> getCartCount(String? token) async {
    final responseData = await http.get(
        Uri.parse(baseurl + version + cartpagelink),
        headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['cartDetails'];
      final listsCArrs = jsonDecode(data)['content']['payments'];
      List<CartDetail> datacart = [];
      List<Payment> directcontent = [];
      if (listsCArr != null) {
        for (Map i in listsCArr) {
          datacart.add(CartDetail.fromMap(i as Map<String, dynamic>));
        }
        for (Map i in listsCArrs) {
          directcontent.add(Payment.fromMap(i as Map<String, dynamic>));
        }
        return datacart.length.toString();
      }
      return "0";
    }
    return "0";
  }

  static Future<String> getSellerOrderCount(String? token) async {
    final responseData = await http.post(
        Uri.parse(baseurl + version + sellingorder),
        headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['statusArr'];
      List<StatusArr> listSCArr = [];
      for (Map i in listsCArr) {
        listSCArr.add(StatusArr.fromMap(i as Map<String, dynamic>));
      }
      return listSCArr[1].count.toString();
    }
    return "0";
  }

  static Future<String> getBuyerOrderCount(String? token) async {
    final responseData = await http
        .post(Uri.parse(baseurl + version + manage), headers: {'Auth': token!});
    if (responseData.statusCode == 200) {
      final data = responseData.body;
      final listsCArr = jsonDecode(data)['content']['statusArr'];
      List<StatusArr> listSCArr = [];
      for (Map i in listsCArr) {
        listSCArr.add(StatusArr.fromMap(i as Map<String, dynamic>));
      }
      return listSCArr[1].count.toString();
    }
    return "0";
  }
}
