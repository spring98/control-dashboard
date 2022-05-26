// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'package:control_dashboard/views/01_login/login.dart';
import 'package:control_dashboard/views/02_home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(
    GetMaterialApp(
      home: const Login(),
    ),
  );
}
