import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('조회하기'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text('운행 이력 조회'),
            ),
            Container(
              child: Text('차량별 trip 조회'),
            ),
            Container(
              child: Text('블랙박스 이력 조회'),
            ),
          ],
        ),
      ),
    );
  }
}
