import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  var urlHost;

  // url() {
  //   if (urlHost == null)
  //     {
  //       return urlHost = 'http://test.appifylab.com';
  //     }
  //     else {
  //       return urlHost;
  //     }
  // }

  getUrl() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      print('urlHost issssssssssssssssss ');
      print(localStorage.getString('qrText'));
        urlHost = localStorage.getString('qrText');
      if (urlHost == null)
      {
        return urlHost = 'http://test.appifylab.com';
      }
      else {
        return urlHost;
      }
    //return hostUrl(localStorage.getString('qrText'));
  }

  postData(data, apiUrl) async {
    var fullUrl = await getUrl() + apiUrl;
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setHeaders());
  }
  postData1(data, apiUrl) async {
    var fullUrl = await getUrl() + apiUrl + await _getToken2();
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setLoginHeaders());
  }

  loginPostData(data, apiUrl) async {
    var fullUrl = await getUrl() + apiUrl;
    //  print(await _setHeaders());
    print("full url is : $fullUrl");
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setLoginHeaders());
  }

  editData(data, apiUrl) async {
    var fullUrl = await getUrl() + apiUrl;
    //  print(await _setHeaders());
    return await http.put(fullUrl,
        body: jsonEncode(data), headers: await _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = await getUrl() + apiUrl;
    print(fullUrl);
    return await http.get(fullUrl, headers: await _setHeaders());
  }

  getDataWithToken(apiUrl) async {
    var fullUrl = await getUrl() + apiUrl + await _getToken1();
    print(fullUrl);
    return await http.get(fullUrl, headers: await _setLoginHeaders());
  }

  getDataWithToken2(apiUrl) async {
    var fullUrl = await getUrl() + apiUrl + await _getToken2();
    print(fullUrl);
    return await http.get(fullUrl, headers: await _setLoginHeaders());
  }

  logIngetData(apiUrl) async {
    var fullUrl = await getUrl() + apiUrl;
    print(fullUrl);
    return await http.get(fullUrl, headers: await _setLoginHeaders());
  }

  _setHeaders() async => {
        "Authorization": 'Bearer ' + await _getToken(),
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _setLoginHeaders() async => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      print(localStorage.getString('token'));
      return localStorage.getString('token');
  }

  _getToken1() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    return '&token=$token';
  }

  _getToken2() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    return '?token=$token';
  }


}



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:shared_preferences/shared_preferences.dart';

// class CallApi {
//   // final String _urladmin = 'https://admin.hiro.work';
//   final String _urluser = 'http://test.appifylab.com';
//   // //final String _urladmin = 'http://10.0.2.2:8000';
//   //final String _urluser = 'https://test.appifylab.com';
//   postData(data, apiUrl) async {
//     var fullUrl = _urluser + apiUrl;
//     //  print(await _setHeaders());
//     print("full url is : $fullUrl");
//     return await http.post(fullUrl,
//         body: jsonEncode(data), headers: await _setHeaders());
//   }

//   loginPostData(data, apiUrl) async {
//     var fullUrl = _urluser + apiUrl;
//     //  print(await _setHeaders());
//     print("full url is : $fullUrl");
//     return await http.post(fullUrl,
//         body: jsonEncode(data), headers: await _setLoginHeaders());
//   }

//   editData(data, apiUrl) async {
//     var fullUrl = _urluser + apiUrl;
//     //  print(await _setHeaders());
//     return await http.put(fullUrl,
//         body: jsonEncode(data), headers: await _setHeaders());
//   }

//   getData(apiUrl) async {
//     var fullUrl = _urluser + apiUrl;
//     print(fullUrl);
//     return await http.get(fullUrl, headers: await _setHeaders());
//   }

//   logIngetData(apiUrl) async {
//     var fullUrl = _urluser + apiUrl;
//     print(fullUrl);
//     return await http.get(fullUrl, headers: await _setLoginHeaders());
//   }

//   _setHeaders() async => {
//         "Authorization": 'Bearer ' + await _getToken(),
//         'Content-type': 'application/json',
//         'Accept': 'application/json',
//       };

//   _setLoginHeaders() async => {
//         'Content-type': 'application/json',
//         'Accept': 'application/json',
//       };

//   _getToken() async {
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       print(localStorage.getString('token'));
//       return localStorage.getString('token');
//   }
//   url(){
//     print(_urluser);
//     return _urluser;
//   }

// }
