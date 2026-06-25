import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:flutter/material.dart';

/// 应用程序常量定义
abstract class AppConstants {
  /// 应用名称
  static const String appName = 'AI 回复助手';

  /// 应用版本
  static const String appVersion = '1.0.0';

  /// 默认动画时长
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// 默认防抖时间
  static const Duration defaultDebounceDuration = Duration(milliseconds: 500);

  /// 首次启动标记
  static const String dataKeyFirstOpen = "first_open";

  /// ai 角色提示词Key
  static const String dataKeyAiRolePrompt = "ai_role_prompt";

  /// 应用偏好设置key
  static const String appPreferenceKeyAutoSend = 'auto_send';

  /// AI 角色提示词
  static const String defaultAiRolePrompt = """
    你是一位得力的回复助手真实的人，请用 %s 风格回复用户的内容。
    回复内容控制在最少字数，真实的对话场景，必要时可以省略最后的标点符号，直接输出要恢复的内容，不包含任何markdown格式，不要解释。
    风格说明：%s
  """;

  /// 默认 AI 平台（内置模型列表作为兜底）
  static const List<AiPlatform> defaultAiPlatform = [
    AiPlatform(name: 'DeepSeek', baseUrl: 'https://api.deepseek.com/v1'),
    AiPlatform(
      name: '千问',
      baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
    ),
    AiPlatform(name: '混元', baseUrl: 'https://api.hunyuan.cloud.tencent.com/v1'),
    AiPlatform(name: 'Kimi', baseUrl: 'https://api.moonshot.cn/v1'),
    AiPlatform(name: '豆包', baseUrl: 'https://ark.cn-beijing.volces.com/api/v3'),
  ];

  /// 默认应用偏好设置
  static const List<AppPreference> defaultAppPreference = [
    AppPreference(
      key: appPreferenceKeyAutoSend,
      name: '自动发送',
      desc: '自动发送 AI 生成的消息',
      isOpen: false,
    ),
  ];

  /// 默认回复风格（9 种，覆盖工作、生活、爱情三大场景，男女通用）
  static const List<ReplyStyle> defaultReplyStyles = [
    ReplyStyle(
      id: 0,
      name: '职场专业',
      prompt:
          '请用专业、干练、逻辑清晰的方式回复对方。语言简洁有力，条理分明，适合工作沟通、商务对接、汇报反馈等职场场景。避免口语化和冗余表达。',
    ),
    ReplyStyle(
      id: 1,
      name: '高情商社交',
      prompt: '请用高情商、委婉得体的方式回复对方。善于照顾对方感受，能巧妙化解尴尬和冲突，适合日常社交、敏感话题和需要留有余地的场合。',
    ),
    ReplyStyle(
      id: 2,
      name: '幽默化解',
      prompt: '请用幽默风趣的方式回复对方。善于自嘲和轻松调侃，能巧妙化解紧张气氛，让对方会心一笑。适合日常闲聊和需要破冰的场景。',
    ),
    ReplyStyle(
      id: 3,
      name: '知心好友',
      prompt: '请用像多年知心好友一样自然随意的方式回复对方。真诚不做作，可以轻松吐槽也可以认真倾听，让对方感到放松和信任。',
    ),
    ReplyStyle(
      id: 4,
      name: '温柔治愈',
      prompt: '请用温柔体贴、充满关怀的方式回复对方。语言细腻温暖，善于共情和安抚情绪，能给人安全感和情绪价值。适合安慰、关心和深夜聊天。',
    ),
    ReplyStyle(
      id: 5,
      name: '暧昧推拉',
      prompt:
          '请用欲擒故纵、制造悬念的方式回复对方。保持适度的神秘感和吸引力，时而靠近时而抽离，让对方心动又捉摸不透。适合恋爱初期的暧昧互动。',
    ),
    ReplyStyle(
      id: 6,
      name: '霸道气场',
      prompt: '请用自信强势、有主导力的方式回复对方。展现决断力和掌控感，同时不失个人魅力。适合展现领导力、表达坚定态度或制造强烈吸引的场合。',
    ),
    ReplyStyle(
      id: 7,
      name: '浪漫诗意',
      prompt:
          '请用浪漫文艺、富有仪式感的方式回复对方。语言优美动人，善于营造氛围和表达心意，让对方感受到被珍视和被爱。适合表白、纪念日和深情时刻。',
    ),
    ReplyStyle(
      id: 8,
      name: '毒舌犀利',
      prompt: '请用犀利毒舌、一针见血的方式回复对方。带点攻击性但不失趣味，善于吐槽和精准打击，适合调侃互怼、表达不满或需要亮明态度的场景。',
    ),
    ReplyStyle(
      id: 9,
      name: '专业绿茶',
      prompt:
          '请用【绿茶婊】的方式回复对方。说话时多带“呀”、“嘛”、“人家”等软糯尾音，用无辜的语气暗中抬高自己或拉踩别人，表面关心实则暗藏心机。适合在暧昧撩拨和甩锅求帮忙时使用。',
    ),
  ];

  /// 回复风格图标映射（id → IconData）
  static const Map<int, IconData> defaultReplyStyleIcons = {
    0: Icons.work_outline, // 职场专业
    1: Icons.handshake_outlined, // 高情商社交
    2: Icons.emoji_emotions_outlined, // 幽默化解
    3: Icons.people_outline, // 知心好友
    4: Icons.spa_outlined, // 温柔治愈
    5: Icons.favorite_border, // 暧昧推拉
    6: Icons.shield_outlined, // 霸道气场
    7: Icons.auto_fix_high, // 浪漫诗意
    8: Icons.bolt, // 毒舌犀利
    9: Icons.face_2, //专业绿茶
  };
}
