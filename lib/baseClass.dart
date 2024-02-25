import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://dev-api.instantxfer.com/api/v1';
const String baseNewUrl = 'https://nodeapi-b20m.onrender.com/api/v1';

class BaseClient {
  var client = http.Client();

  //GET
  Future<dynamic> get(String api) async {
    var url = Uri.parse(baseNewUrl + api);
    debugPrint(url.toString());
    var response = await client.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }


  //POST
  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    if (kDebugMode) {
      print(url);
    }
    var pinData = json.encode(object);
    if (kDebugMode) {
      print(pinData);
    }
    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0ZXJtaW5hbElkIjoiOTllYjU4NmUtNjFhMy00M2IwLThhMzItMWU1Y2VmNWMxNTVlIiwidGVybWluYWxfaWQiOjk4LCJpZCI6OTgsInVzZXJfaWQiOiIxMjU5IiwiY29tcGFueV9pZCI6MSwibmFtZSI6IktvdXNoaWsiLCJzbHVnIjpudWxsLCJpc190ZXJtaW5hbCI6dHJ1ZSwicm9sZSI6InRlcm1pbmFsIiwic3RvcmVfaWQiOjIsInN0b3JlIjp7InN0b3JlX2V4dGVybmFsX2lkIjoiODIzZjNiNTQtOGMzYy00M2FmLWFjNTEtN2YzMWQ2YzMwNmEyIiwic3RvcmVfbmFtZSI6IkxHIExpdmUgU3RvcmUiLCJpZCI6Miwid2ViaG9va191cmwiOiIiLCJ3ZWJob29rX2tleSI6IiIsIkNvbXBhbnkiOnsiY29tcGFueV9leHRlcm5hbF9pZCI6IjMxZWFiYzZkLTJjZDctNDhhYi1iNDAyLWNjY2QyZjFhNTU1MCIsImlkIjoxLCJjcmVhdGVkQXQiOiIyMDIyLTA3LTI3VDEzOjM0OjMyLjQzM1oifSwiVmVuZG9yIjp7ImlkIjo0LCJzbHVnIjoid2VzdF90b3duX2JhbmtfYW5kX3RydXN0IiwiZnVsbE5hbWUiOiJXZXN0IFRvd24gQmFuayBhbmQgVHJ1c3QiLCJhZ3JlZW1lbnRfdGV4dCI6IllvdSB1bmRlcnN0YW5kIHRoYXQgeW91ciBmdW5kcyBpbiB5b3VyIFdlc3QgVG93biBYZmVyIEFjY291bnQgYXJlIGJlaW5nIHJlY2VpdmVkIGJ5IFdlc3QgVG93biBCYW5rIGFuZCBUcnVzdC4gWW91IHJlcHJlc2VudCB0aGF0IGFsbCBvZiB0aGUgaW5mb3JtYXRpb24geW91IGhhdmUgcHJvdmlkZWQsIGluY2x1ZGluZyBpbmZvcm1hdGlvbiBwcm92aWRlZCBhcyBwYXJ0IG9mIHRoZSBcIktub3ctWW91ci1DdXN0b21lclwiIG9yIEtZQyBwcm9jZXNzLCBpcyBjb3JyZWN0IGFuZCB1cCB0byBkYXRlLiBBY2NvcmRpbmdseSwgeW91ciBhY2NvdW50IHN0YXRlbWVudCB3aWxsIHNob3cgeW91ciBjcmVkaXQvZGViaXQgY2FyZCBhY2NvdW50IGZ1bmRpbmcgaXMgYmVpbmcgbWFkZSB0byB5b3VyIFdlc3QgVG93biBYZmVyIEFjY291bnQgaGVsZCBpbiB0aGUgbmFtZSBvZiBXZXN0IFRvd24gQmFuayBhbmQgVHJ1c3QgYXMgdGhlIE1lcmNoYW50IG9mIFJlY29yZC4iLCJsb2dvIjoiaHR0cHM6Ly9jZG4ubGVkZ2VyZ3JlZW4uY29tL3d0L2ltYWdlcy93dGJ0LWxvZ28ucG5nIiwiYXV0aG9yaXNlZF90ZXh0IjoiSSBhdXRob3JpemUgdG8gdHJhbnNmZXIgZnVuZHMgZnJvbSBteSB7e3ZlbmRvck5hbWV9fSBhY2NvdW50IGVuZGluZyBpbiB7e2F1dG9HZW5lcmF0ZUZvdXJEaWdpdHN9fSAge3tzdG9yZU5hbWV9fSBhbmQgYWNjZXB0IHRoZSBhZ3JlZW1lbnQgYmVsb3cuIiwicHJpbWFyeV9jb2xvciI6bnVsbCwic2Vjb25kYXJ5X2NvbG9yIjpudWxsLCJ0ZXJ0aWFyeV9jb2xvciI6bnVsbCwiaWNvbiI6Imh0dHBzOi8vaW5zdGFudHhmZXIuY29tL2Zhdmljb24ucG5nIiwiYXNzb2NpYXRlX2xvZ28iOiJodHRwczovL2luc3RhbnR4ZmVyLmNvbS9mYXZpY29uLnBuZyIsInBvd2VyZWRfYnlfdGV4dCI6IlhmZXIgcG93ZXJlZCBieSBXZXN0IFRvd24gQmFuayAmIFRydXN0In19LCJpYXQiOjE3MDc5MDkxODIsImV4cCI6MTczOTQ0NTE4Mn0.wBulMtU1z6h0ve5w3NUDeL5oiNGTTkEm8p_VYbKmHwI',
      'Content-Type': 'application/json',
    };

    var response = await client.post(url, body: pinData, headers: headers);
    if (kDebugMode) {
      print(response.statusCode);
    }
    if (kDebugMode) {
      print(response.body);
    }
    return response.body;
  }
}
