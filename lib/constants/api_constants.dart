import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.get('BASE_API_URL');
  static String homePath = '$baseUrl/manapp';
  static String detailPath = '$homePath/detail';
  static String chapterPath = '$detailPath/chapter';
  static String searchPath = '$homePath/search';
}