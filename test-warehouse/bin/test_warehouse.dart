import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  var url = Uri.parse("http://127.0.0.0:3000/products");
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  var response2 = await http.post(url, body: jsonEncode({'name' : "covtun", 'description' : "kotul", "category" : 4, "price" : 3, "n" : 2}));
  print('Response status: ${response2.statusCode}');
  print('Response body: ${response2.body}');
}