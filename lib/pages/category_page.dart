import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_shop/config/http_headers.dart';

// class CategoryPage extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {

//     return Center(
//       child: Text('分类'),
//     );
//   }
// }

class CategoryPage extends StatefulWidget {
  final Widget child;

  CategoryPage({Key key, this.child}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  String showText = '还没有请求数据';

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('远程数据'),),
        body: SingleChildScrollView( // 滚动控件
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  _jike();
                },
                child: Text('请求数据'),
              ),
              Text(showText),
            ],
          ),
        ),
       ),
    );
  }

  void _jike() {

    print('开始向极客时间请求数据');

    _getHttp().then((val) {
      setState(() {
        showText = val['data'].toString();
      });
    });
  }

  Future _getHttp() async {
    try {
      Response response;
      Dio dio = new Dio();

      dio.options.headers = httpHeaders;

      response = await dio.get('https://time.geekbang.org/serv/v1/column/newAll');
      print(response);
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}