import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  var url = Uri.parse("http://127.0.0.0:3000/products");
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  final List<dynamic> data = json.decode(response.body);
  for(var d in data){
    print(d);
  }
}