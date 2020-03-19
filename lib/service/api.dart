import 'package:dio/dio.dart';
import 'package:testmuban/constant/constant.dart';
import 'package:testmuban/service/service.dart';
class Api {
  // 获取篮球信息
  static Function get getBasketball => () => service.fetch('onebox/basketball/nba?key=${Constant.juheKey}', isShowLoading: true);
}
