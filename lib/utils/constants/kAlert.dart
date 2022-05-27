// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> alert(String contents) {
  return Get.dialog(
      Dialog(
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 39,
                child: Text('알림'),
              ),
              Container(
                  alignment: Alignment.center, color: Colors.green, height: 1),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.center,
                height: 70,
                child: Text(contents),
              ),
              GestureDetector(
                onTap: () {
                  Get.back(result: 'yes');
                },
                child: Container(
                  color: Colors.green,
                  alignment: Alignment.center,
                  height: 40,
                  child: Text('확인'),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false);
}

// Future<dynamic> alertYesOrNo(String contents) {
//   return Get.dialog(
//       Dialog(
//         child: SizedBox(
//           height: 145.h,
//           child: Column(
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 height: 39.h,
//                 child: Text('알림', style: k14w500),
//               ),
//               Container(
//                   alignment: Alignment.center,
//                   color: kColorPrimary,
//                   height: 1.h),
//               Container(
//                 alignment: Alignment.center,
//                 height: 70.h,
//                 child: Text(contents, style: k14w500),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Get.back(result: 'yes');
//                       },
//                       child: Container(
//                         color: kColorPrimary,
//                         alignment: Alignment.center,
//                         height: 35.h,
//                         child: Text('확인',
//                             style: k12w500.copyWith(color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Get.back(result: 'no');
//                       },
//                       child: Container(
//                         color: Colors.grey,
//                         alignment: Alignment.center,
//                         height: 35,
//                         child: Text('취소',
//                             style: k12w500.copyWith(color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false);
// }
