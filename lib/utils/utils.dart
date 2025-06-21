import 'package:agentic_app_manager/fake_mail_screen/data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:provider/provider.dart';
import './device_helper.dart';
import '../app_state.dart';

void setFontFamilyCall(BuildContext context, FunctionCall functionCall) {
  var fontFamily = functionCall.args['fontFamily']! as String;
  print('debugFont $functionCall');
  print('debugFont ${functionCall.args}');

  if (context.mounted) {
    context.read<AppState>().setFontFamily(fontFamily);
  }

  return;
}

void setFontSizeFactorCall(BuildContext context, FunctionCall functionCall) {
  var fontSizeFactor = functionCall.args['fontSizeFactor']! as num;

  if (context.mounted) {
    context.read<AppState>().setFontSizeFactor(fontSizeFactor.toDouble());
  }

  return;
}

void setAppColorCall(BuildContext context, FunctionCall functionCall) async {
  int red = functionCall.args['red']! as int;
  int green = functionCall.args['green']! as int;
  int blue = functionCall.args['blue']! as int;

  Color newSeedColor = Color.fromRGBO(red, green, blue, 1);

  if (context.mounted) {
    context.read<AppState>().setAppColor(newSeedColor);
  }
}

Future<String> getDeviceInfoCall() async {
  var deviceInfo = await DeviceHelper.getDeviceInfo();
  return 'Device Info: ${deviceInfo.toString()}';
}

Future<String> getBatteryInfoCall() async {
  var batteryInfo = await DeviceHelper.getBatteryInfo();
  return 'Battery Info: ${batteryInfo.toString()}';
}

void sortByNameCall(BuildContext context, FunctionCall functionCall) {
  var sortByName = functionCall.args['order']! as String;
  print('debugSort $functionCall');
  print('debugSort ${functionCall.args}');

  void sortEmailsByName(List<Email> emails, String order) {
    emails.sort((a, b) {
      int firstNameCompare = a.fromFirstName.toLowerCase().compareTo(b.fromFirstName.toLowerCase());
      if (firstNameCompare != 0) {
        return order == 'asc' ? firstNameCompare : -firstNameCompare;
      }
      int lastNameCompare = a.fromLastName.toLowerCase().compareTo(b.fromLastName.toLowerCase());
      return order == 'asc' ? lastNameCompare : -lastNameCompare;
    });
  }

  if (context.mounted) {
    if (sortByName == 'desc') {
      sortEmailsByName(emails, 'desc');
      context.read<AppState>().setFontFamily('Inter');
    } else {
      sortEmailsByName(emails, 'asc');
      context.read<AppState>().setFontFamily('Raleway');
    }
  }

  return;
}

void searchByNameCall(BuildContext context, FunctionCall functionCall) {
  var sortByName = functionCall.args['query']! as String;
  print('debugSearch $functionCall');
  print('debugSearch ${functionCall.args}');

  if (context.mounted) {
    // print('debugSearch before ${emails2.length}');
    emails2 = emails.map((e) => e.copy()).toList();
    emails = [...emails.where((user) => user.fromFirstName.toLowerCase().contains(sortByName.toLowerCase()))];

    context.read<AppState>().setFontFamily('Caveat');
  }

  return;
}

void resetSearchCall(BuildContext context, FunctionCall functionCall) {
  if (context.mounted) {
    print('debugSearch ${emails2.length}');
    // print('debugSearch identical ${identical(emails[0], emails2[0])}');
    emails = emails2.map((e) => e.copy()).toList();
    context.read<AppState>().setFontFamily('Roboto');
  }

  return;
}
