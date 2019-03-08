import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // 正式项目时，都在外层套一个Container，方便做扩展或对应需求变更
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        // 移除右上角的 debug 样式
        debugShowCheckedModeBanner: false,
        // 设置主题
        theme: ThemeData(
          // 设置主题样式
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}