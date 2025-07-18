import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String _apiKey = 'YOUR_DEEPSEEK_API_KEY'; // Replace with actual API key

  static Future<String> generateHabitStatement({
    required String habitKeyword,
    required bool isPositive,
  }) async {
    final prompt = isPositive
        ? '''生成一条简洁坚定的句子，用于帮助用户培养 "$habitKeyword" 这一好习惯。
格式要求：
- 以"我每天都..."开头
- 语气坚定、积极
- 长度控制在20字以内
- 可以包含情感标签强化效果

示例：
输入：运动
输出：我每天都运动。运动让我充满活力

输入：阅读
输出：我每天都阅读。阅读让我成长

现在请为"$habitKeyword"生成类似的句子：'''
        : '''生成一条简洁坚定的句子，用于帮助用户戒除 "$habitKeyword" 这一坏习惯。
格式要求：
- 以"我从不..."开头
- 语气坚定、否定
- 长度控制在20字以内
- 可以包含情感标签强化效果

示例：
输入：吸烟
输出：我从不吸烟。香烟很臭，不能解决任何问题

输入：刷短视频
输出：我从不刷短视频。短视频剥夺我的专注力

现在请为"$habitKeyword"生成类似的句子：''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Return fallback statements if API fails
      return _getFallbackStatement(habitKeyword, isPositive);
    }
  }

  static String _getFallbackStatement(String habitKeyword, bool isPositive) {
    if (isPositive) {
      return '我每天都$habitKeyword。$habitKeyword让我变得更好';
    } else {
      return '我从不$habitKeyword。$habitKeyword对我没有吸引力';
    }
  }

  static Future<List<String>> generateMultipleStatements({
    required String habitKeyword,
    required bool isPositive,
    int count = 3,
  }) async {
    final results = <String>[];
    
    for (int i = 0; i < count; i++) {
      try {
        final statement = await generateHabitStatement(
          habitKeyword: habitKeyword,
          isPositive: isPositive,
        );
        results.add(statement);
        
        // Add a small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        results.add(_getFallbackStatement(habitKeyword, isPositive));
      }
    }
    
    return results;
  }

  static Future<String> enhanceStatement({
    required String originalStatement,
    required String emotionTag,
  }) async {
    final prompt = '''请为以下语句添加情感标签来增强效果：

原始语句：$originalStatement
情感标签：$emotionTag

要求：
- 保持原始语句的核心意思
- 自然地融入情感标签
- 语句流畅且有力
- 长度控制在30字以内

示例：
原始语句：我从不吸烟
情感标签：很恶心
输出：我从不吸烟。二手烟很恶心

请为上述语句生成增强版本：''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Return enhanced statement with simple concatenation if API fails
      return '$originalStatement。$emotionTag';
    }
  }
}