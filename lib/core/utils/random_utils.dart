import 'dart:math';

/// 随机工具类
///
/// 提供项目中常用的随机数、随机字符串、UUID 生成等方法。
/// 所有方法均为静态，无需实例化。
class RandomUtils {
  static final Random _random = Random();

  /// 生成唯一整数 ID
  ///
  /// 基于时间戳 + 随机数，保证同一毫秒内的唯一性。
  /// 适用于本地临时 ID、消息标识等场景。
  static int randomId() {
    return DateTime.now().millisecondsSinceEpoch * 10000 +
        _random.nextInt(10000);
  }

  /// 生成指定长度的随机字符串
  ///
  /// [length] 生成字符串的长度
  /// [chars] 可选字符池，默认使用小写字母 + 数字
  ///
  /// 示例：
  /// ```dart
  /// RandomUtils.randomString(8);           // 'a3f9k2m1'
  /// RandomUtils.randomString(6, chars: '0123456789'); // '482913'
  /// ```
  static String randomString(
    int length, {
    String chars = 'abcdefghijklmnopqrstuvwxyz0123456789',
  }) {
    return String.fromCharCodes(
      List.generate(
        length,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// 生成类 UUID v4 格式的随机字符串
  ///
  /// 格式：xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  /// 其中 x 为随机十六进制字符，y 为 8/9/a/b 之一。
  ///
  /// 注意：此为简化实现，未使用加密安全随机数生成器，
  /// 仅适用于客户端本地标识，不适用于需要密码学安全的场景。
  static String uuid() {
    final buffer = StringBuffer();
    for (var i = 0; i < 36; i++) {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        buffer.write('-');
      } else if (i == 14) {
        buffer.write('4');
      } else if (i == 19) {
        buffer.write(_random.nextInt(4) + 8); // 8, 9, a, b
      } else {
        buffer.write(_random.nextInt(16).toRadixString(16));
      }
    }
    return buffer.toString();
  }

  /// 生成指定范围内的随机整数（包含 min，不包含 max）
  ///
  /// [min] 最小值（包含）
  /// [max] 最大值（不包含）
  ///
  /// 示例：
  /// ```dart
  /// RandomUtils.randomInt(1, 100);  // 1 ~ 99
  /// ```
  static int randomInt(int min, int max) {
    if (min >= max) {
      throw ArgumentError('min must be less than max');
    }
    return min + _random.nextInt(max - min);
  }

  /// 随机布尔值
  ///
  /// [probability] 返回 true 的概率，范围 0.0 ~ 1.0，默认 0.5
  static bool randomBool({double probability = 0.5}) {
    if (probability < 0 || probability > 1) {
      throw ArgumentError('probability must be between 0.0 and 1.0');
    }
    return _random.nextDouble() < probability;
  }

  /// 从列表中随机选取一个元素
  ///
  /// [list] 数据源列表
  ///
  /// 示例：
  /// ```dart
  /// RandomUtils.randomElement(['A', 'B', 'C']);  // 随机返回 'A' / 'B' / 'C'
  /// ```
  static T randomElement<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError('list must not be empty');
    }
    return list[_random.nextInt(list.length)];
  }

  /// 打乱列表顺序（Fisher-Yates 洗牌算法）
  ///
  /// [list] 待打乱的列表，原列表不会被修改，返回新列表。
  static List<T> shuffle<T>(List<T> list) {
    final result = List<T>.from(list);
    for (var i = result.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = result[i];
      result[i] = result[j];
      result[j] = temp;
    }
    return result;
  }
}
