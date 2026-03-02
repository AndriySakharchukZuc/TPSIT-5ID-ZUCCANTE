import 'package:http/http.dart' as http;

void main() async {
  var url = Uri.parse("http://127.0.0.0:3000/products");
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}