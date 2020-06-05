import 'package:http/http.dart' as http;
import 'dart:convert';

Future getDataFromWeb() async {
   String _url = "https://api.myjson.com/bins/1223hx"; // with my mobile Grameen phone no and an invalid no
  // String _url = "https://api.myjson.com/bins/dhgi9"; // with sadad vi mobile no
//  String _url =      "https://api.myjson.com/bins/iesx5"; // with my Banglalink mobile no
  http.Response response = await http.get(_url);
  if (response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    return result;
  }
}
