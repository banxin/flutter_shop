import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController typeController = TextEditingController();
  String showText = '欢迎来到XX人间';

  // 保持页面状态
  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('XX人间'),
        ),
        body: SingleChildScrollView( // 滚动组件
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  // 一定要申明这个controller，才能取到输入框的值
                  controller: typeController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: '名称',
                      helperText: '请输入名称'
                  ),
                  // 自动对焦，这个一定要加上，不然会弄乱手机的键盘弹出
                  autofocus: false,
                ),
                RaisedButton(
                    child: Text('输入完成'),
                    onPressed: (){
                      _tapedButton();
                    }
                ),
                Text(
                  showText,
                  // 外层没有使用Container时，单独使用时，为了适配，需要做一些事情
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  void _tapedButton() {

    print('开始输入名称........');

    if (typeController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('请输入名称'),)
      );
    } else {
      // 获取返回值，then函数
      getHttp(typeController.text.toString()).then((value){
        setState(() {
          showText = value['data']['name'].toString();
        });
      });
    }
  }

  Future getHttp(String typeText) async {

    try {

      Response response;

      var params = {'name': typeText};

      // await 等待，异步方法才可以用，成对出现的
      // 带参数的示例
      // get
//      response = await Dio().get("https://easy-mock.com/mock/5c80c53557426d5c5e540619/test/easygettest",
//        queryParameters: params
//      );

      // post
      response = await Dio().post("https://easy-mock.com/mock/5c80c53557426d5c5e540619/test/easyposttest",
          queryParameters: params
      );

      return response.data;

    } catch (e) {
      
      return print(e);
    }
  }
}

// dio 简单的get请求示范
//class HomePage extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//
//    getHttp();
//
//    return Center(
//      child: Text('首页'),
//    );
//  }
//
//  // 异步请求
//  void getHttp() async {
//
//    try {
//
//      Response response;
//
//      // await 等待，异步方法才可以用，成对出现的
//      response = await Dio().get("https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=somebody'");
//
//      return print(response);
//
//    } catch (e) {
//
//      return print(e);
//    }
//  }
//}