import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_search_users/models/user.dart';
import 'package:http/http.dart' as http;

class HomeService{
  Future<List<User>> getSpecificUser(String inputString) async {
    List<User> users = [];

    try {
      var queryParams = {'q': inputString};
      String authority = "api.github.com";
      String path = "/search/users";
      final uri = Uri.https(authority, path, queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        for (var item in responseData['items']) {
          User user = User.fromJson(item);
          users.add(user);
        }
        print('\n\nCALLED HERE\n\n' + users.toString());
      } else {
        debugPrint("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Some exception occurred: " + e.toString());
    }
    return users;
  }
}