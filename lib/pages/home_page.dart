// 系统库
import 'package:flutter/material.dart';
import 'dart:convert';

// 自己的类
import '../service/service_method.dart';

// 三方库
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';

  @override
  void initState() {
    
    // 获取首页数据
    // getHomePageContent().then((value){
    //   setState(() {
    //     homePageContent = value.toString();
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('百姓生活+'),),
         // SingleChildScrollView 与 list 会有冲突，使用时需要注意
         body: FutureBuilder( // 可以完美解决异步数据加载实时刷新，也不用调用setState
            future: getHomePageContent(), // 异步方法
            builder: (context, snapshop) { // 两个参数，上下文，和 异步方法的返回值
              if (snapshop.hasData) {
                var data = json.decode(snapshop.data.toString());
                List<Map> swiper = (data['data']['slides'] as List).cast();
                return Column(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper)
                  ],
                );
              } else {
                return Center(
                  child: Text('加载中...'),
                );
              }
            },
         )
       ),
    );
  }
}

// 首页轮播 widget
class SwiperDiy extends StatelessWidget {

  final List swiperDataList;

  // 官方推荐写法
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  // 简化写法
  // SwiperDiy(this.swiperDataList);

  @override
  Widget build(BuildContext context) {

    // 初始化适配器
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    // 放到初始化适配器之前
    print('设备的像素密度：${ScreenUtil.pixelRatio}');
    print('设备的高：${ScreenUtil.screenHeight}');
    print('设备的宽：${ScreenUtil.screenWidth}');

    return Container(
        // 使用 ScreenUtil 设置宽高进行适配
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "${swiperDataList[index]['image']}", 
              fit: BoxFit.fill,
              );
          },
          itemCount: swiperDataList.length,
          pagination: SwiperPagination(), // 是否有导航器
          autoplay: true, // 是否自动播放
        ),
      );
  }
}