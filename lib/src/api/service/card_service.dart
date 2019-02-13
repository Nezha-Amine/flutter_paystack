import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_paystack/src/api/model/transaction_api_response.dart';
import 'package:flutter_paystack/src/api/service/base_service.dart';
import 'package:flutter_paystack/src/common/exceptions.dart';
import 'package:flutter_paystack/src/common/my_strings.dart';
import 'package:http/http.dart' as http;

class CardService extends BaseApiService {
  Future<TransactionApiResponse> chargeCard(Map<String, String> fields) async {
    var url = '$baseUrl/charge/mobile_charge';

    http.Response response =
        await http.post(url, body: fields, headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return TransactionApiResponse.fromMap(responseBody);
        break;
      case HttpStatus.gatewayTimeout:
        throw ChargeException('Gateway timeout error');
        break;
      default:
        throw ChargeException(Strings.unKnownResponse);
        break;
    }
  }

  Future<TransactionApiResponse> validateCharge(
      Map<String, String> fields) async {
    var url = '$baseUrl/charge/validate';

    http.Response response =
        await http.post(url, body: fields, headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;
    if (statusCode == HttpStatus.ok) {
      Map<String, dynamic> responseBody = json.decode(body);
      return TransactionApiResponse.fromMap(responseBody);
    } else {
      throw CardException('validate charge transaction failed with '
          'status code: $statusCode and response: $body');
    }
  }

  Future<TransactionApiResponse> reQueryTransaction(String trans) async {
    var url = '$baseUrl/requery/$trans';

    http.Response response = await http.get(url, headers: headers);
    var body = response.body;
    var statusCode = response.statusCode;
    if (statusCode == HttpStatus.ok) {
      Map<String, dynamic> responseBody = json.decode(body);
      return TransactionApiResponse.fromMap(responseBody);
    } else {
      throw ChargeException('requery transaction failed with status code: '
          '$statusCode and response: $body');
    }
  }
}
