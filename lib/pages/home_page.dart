import 'package:flutter/material.dart';
import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';

  @override
  void initState() {
    
    // 获取首页数据
    getHomePageContent().then((value){
      setState(() {
        homePageContent = value.toString();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('百姓生活+'),),
         // SingleChildScrollView 与 list 会有冲突，使用时需要注意
         body: SingleChildScrollView(
           child: Text(homePageContent),
         ),
       ),
    );
  }
}