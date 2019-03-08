// 安卓 平板
import 'package:flutter/material.dart';

// iOS 风格
import 'package:flutter/cupertino.dart';

import 'package:flutter_shop/pages/home_page.dart';
import 'package:flutter_shop/pages/category_page.dart';
import 'package:flutter_shop/pages/cart_page.dart';
import 'package:flutter_shop/pages/member_page.dart';

class IndexPage extends StatefulWidget {

//  @override
//  State<StatefulWidget> createState() {
//
//    return _IndexPageState();
//  }

  // 简写
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  // 底部导航按钮s
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search),
        title: Text('分类')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart),
        title: Text('购物车')
    ),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: Text('会员中心')
    )
  ];

  // 导航页面
  final List tabPages = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {

    // 初始化写在调用 super 之前
    currentPage = tabPages[currentIndex];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: new BottomNavigationBar(
        // fixed：一般使用这个类型，符合大部分人习惯（tips：少于3个看不出效果）
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          // 动态组件需要改变状态的话，必须使用 setState
          setState(() {
            currentIndex = index;
            currentPage = tabPages[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}