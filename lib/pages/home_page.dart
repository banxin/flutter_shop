// 系统库
import 'package:flutter/material.dart';
import 'dart:convert';

// 自己的类
import '../service/service_method.dart';

// 三方库
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  String homePageContent = '正在获取数据';

  /*
  保持页面设置

  AutomaticKeepAliveClientMixin
  AutomaticKeepAliveClientMixin这个Mixin就是Flutter为了保持页面设置的。哪个页面需要保持页面状态，就在这个页面进行混入。

  不过使用使用这个Mixin是有几个先决条件的：

  使用的页面必须是StatefulWidget,如果是StatelessWidget是没办法办法使用的。
  其实只有两个前置组件才能保持页面状态：PageView和IndexedStack。
  重写wantKeepAlive方法，如果不重写也是实现不了的。
  */
  @override
  bool get wantKeepAlive =>true;

  @override
  void initState() {

    // 获取首页数据
    // getHomePageContent().then((value){
    //   setState(() {
    //     homePageContent = value.toString();
    //   });
    // });

    print('111111111111111111111111111');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('百姓生活+'),
          ),
          // SingleChildScrollView 与 list 会有冲突，使用时需要注意
          body: FutureBuilder(
            // 可以完美解决异步数据加载实时刷新，也不用调用setState
            future: getHomePageContent(), // 异步方法
            builder: (context, snapshop) {
              // 两个参数，上下文，和 异步方法的返回值
              if (snapshop.hasData) {
                var data = json.decode(snapshop.data.toString());

                // 轮播图数据
                List<Map> swiper = (data['data']['slides'] as List).cast();

                // 门洞导航数据
                List<Map> navigatorList =
                    (data['data']['category'] as List).cast();

                // 广告图片数据
                String advertesPicture =
                    data['data']['advertesPicture']['PICTURE_ADDRESS'];

                // 店长图片
                String leaderImage = data['data']['shopInfo']['leaderImage'];
                // 店长电话
                String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                
                // 商品推荐
                List<Map> recomentList = (data['data']['recommend'] as List).cast(); 

                // 防止超出一屏，添加一个scroller
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // 轮播图
                      SwiperDiy(swiperDataList: swiper),
                      // 门洞导航
                      TopNavigator(navitatorList: navigatorList,),
                      // 广告图
                      AdBanner(advertesPicture: advertesPicture),
                      // 店长组件
                      ShopLeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                      // 推荐商品
                      Recoment(recomentList:recomentList),  
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('加载中...'),
                );
              }
            },
          )),
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

// 顶部门洞导航
class TopNavigator extends StatelessWidget {
  final List navitatorList;

  TopNavigator({Key key, this.navitatorList}) : super(key: key);

  // 获取门洞导航的 Item
  Widget _grideItemWidget(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了门洞导航~~~~~~~~~~');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 如果大于 10 条数据，移除超出的数据
    if (this.navitatorList.length > 10) {
      this.navitatorList.removeRange(10, this.navitatorList.length);
    }

    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navitatorList.map((item) {
          return _grideItemWidget(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告 banner （其实就是一张由服务端返回的图片）
class AdBanner extends StatelessWidget {
  // 图片链接
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

// 店长 widget
class ShopLeaderPhone extends StatelessWidget {
  // 店长图片
  final String leaderImage;
  // 店长电话
  final String leaderPhone;

  ShopLeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _lanuchURL();
        },
        child: Image.network(leaderImage),
      ),
    );
  }

  /* 私有方法 */

  // 拨打电话
  void _lanuchURL() async {
    // iOS端，这里有 bug ，会弹出两次打电话的对话框
    String url = 'tel:' + leaderPhone;

    // 也可以打开 网页链接
    // String url = 'http://www.baidu.com';

    // 是否能打开url
    if (await launch(url)) {
      await launch(url);
    } else {
      throw 'Url 不能访问，异常~~';
    }
  }
}

// 横向推荐商品
class Recoment extends StatelessWidget {

  final List recomentList;

  Recoment({Key key, this.recomentList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recomentListWidget()
        ],
      ),
    );
  }

  // 推荐商品标题
  Widget _titleWidget() {
    return Container(
      // 对齐方式，靠左中间对齐
      alignment: Alignment.centerLeft,
      // 设置内边距
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      // 设置样式
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width:1.0, color:Colors.black12)
        ),
      ),
      child: Text(
        '商品推荐',
        style:TextStyle(color:Colors.pink)
        ),
    );
  }

  // 单个商品Item
  Widget _item(index) {
    // 需要点击事件
    return InkWell(
      onTap: () {
        print('点击了推荐商品....');
      },
      child: Container(
        height: ScreenUtil().setWidth(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border(
            left: BorderSide(width:1.0,color:Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recomentList[index]['image']),
            Text('￥${recomentList[index]['mallPrice']}'),
            Text(
              '￥${recomentList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color:Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  // 推荐列表 widget
  Widget _recomentListWidget() {
    return Container(
       height: ScreenUtil().setHeight(330),
       child: ListView.builder(
         scrollDirection: Axis.horizontal,
         itemCount: recomentList.length,
         itemBuilder: (content, index) {
           return _item(index);
         },
       ),
    );
  }

}