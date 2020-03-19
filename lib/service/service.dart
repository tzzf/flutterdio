import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:testmuban/constant/constant.dart';
class _Service {
  _Service() {
    _initDio();
  }
  Dio _dio = new Dio();
  static String token;
  static bool isToast = false;
  void setToken(String tk) {
    token = tk;
  }

  void setToast(bool val) {
    isToast = val;
  }
  void _initDio () {
    // 接口日志
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options){
          // 超时时间
          options.connectTimeout = 3000;
          // 在请求被发送之前做一些事情
          return options;
        },
        onResponse: (Response response) {
          // 在返回响应数据之前做一些预处理
          if (response.data['code'] != '200') {
            setToast(true);
            EasyLoading.showError('Failed with Error',duration: Duration(seconds: 3));
          }
          return response;
        },
        onError: (DioError error) {
          // 当请求失败时做一些预处理
          setToast(true);
          EasyLoading.showError('Failed with Error',duration: Duration(seconds: 3));
          return error;
        },
    ));
  }
  // 真正发请求的地方
  Future fetch(url, {
      dynamic params,
      Map<String, dynamic> header,
      Options option,
      bool isShowLoading = false
    }) async{
    Map<String, dynamic> headers = new HashMap(
    );
    headers['Authorization'] =  token;
    if (header != null) {
      headers.addAll(header);
    }
    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }
    // 是否需要 loading
    if (isShowLoading) {
      EasyLoading.show(status: 'loading...');
    }
    try {
      // 发送请求获取结果
      Response _response = await _dio.request('${Constant.baseUrl}$url', data: params, options: option);
      // 返回真正结果
      return _response;
    } catch (error) {
      // 异常提示
      if (!isToast) {
        EasyLoading.dismiss();
      }
    } finally {
      // 不管结果怎么样 都需要结束Loading
      if (isShowLoading && !isToast) {
        EasyLoading.dismiss();
      } else if (isToast) {
        setToast(false);
      }
    }
  }
}
final _Service service = new _Service();
