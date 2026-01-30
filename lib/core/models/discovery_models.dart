import 'package:json_annotation/json_annotation.dart';

part 'discovery_models.g.dart';

/// [DiscoveryItemType] - 发现页内容类型
enum DiscoveryItemType {
  ad,       // 广告/ Banner
  topic,    // 话题
  post,     // 用户动态/帖子
  video,    // 视频内容
  news,     // 资讯
  article,  // 深度文章
}

/// [UserInfo] - 发现项关联的用户信息
@JsonSerializable()
class UserInfo {
  final String id;              // 用户唯一标识
  final String name;            // 用户昵称
  final String? avatar;         // 头像 URL
  final DateTime? createdAt;    // 账号创建时间
  final String? carModel;       // 认证车型（如：BJ40 荣耀版）

  const UserInfo({
    required this.id,
    required this.name,
    this.avatar,
    this.createdAt,
    this.carModel,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

/// [DiscoveryComment] - 发现页动态的评论信息
@JsonSerializable()
class DiscoveryComment {
  final String id;              // 评论唯一标识
  final UserInfo user;          // 评论发布者用户信息
  final String content;         // 评论正文
  final int likes;              // 评论点赞数
  final DateTime createdAt;     // 评论发布时间

  const DiscoveryComment({
    required this.id,
    required this.user,
    required this.content,
    this.likes = 0,
    required this.createdAt,
  });

  factory DiscoveryComment.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryCommentFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryCommentToJson(this);
}

/// [DiscoveryContentBlock] - 富文本内容块（用于展示文章/长帖）
@JsonSerializable()
class DiscoveryContentBlock {
  final String type;            // 内容块类型：'text' 或 'image'
  final String? text;           // 文本内容（type 为 'text' 时有效）
  final String? imageUrl;       // 图片 URL（type 为 'image' 时有效）

  const DiscoveryContentBlock({
    required this.type,
    this.text,
    this.imageUrl,
  });

  factory DiscoveryContentBlock.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryContentBlockFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryContentBlockToJson(this);
}

/// [DiscoveryItem] - 发现页动态/资讯模型
@JsonSerializable()
class DiscoveryItem {
  final String id;              // 动态唯一标识
  @JsonKey(fromJson: _parseType, toJson: _typeToString)
  final DiscoveryItemType type; // 内容分类
  final String title;           // 标题/简述
  final String? content;        // 动态全文
  final List<DiscoveryContentBlock>? contentBlocks; // 文章模式下的富文本块
  final String? subtitle;       // 副标题/摘要
  final String image;           // 列表展示缩略图（单图模式或第一张图）
  final List<String>? images;   // 动态关联的多张图片
  final String? tag;            // 展示标签文字（如：官方、精选）
  final String? tagColor;       // 标签主题色
  final UserInfo? user;         // 发布者信息
  final int likes;              // 点赞总数
  final int comments;           // 评论总数
  final int shares;             // 分享/转发总数
  final List<DiscoveryComment>? commentsList; // 部分/精选评论
  final bool isVideo;           // 是否为视频动态
  final bool isPublished;       // 发布状态
  final DateTime? createdAt;    // 动态发布时间戳

  const DiscoveryItem({
    required this.id,
    required this.type,
    required this.title,
    this.content,
    this.contentBlocks,
    this.subtitle,
    required this.image,
    this.images,
    this.tag,
    this.tagColor,
    this.user,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.commentsList,
    this.isVideo = false,
    this.isPublished = true,
    this.createdAt,
  });

  static DiscoveryItemType _parseType(String? type) {
    switch (type) {
      case 'ad':
        return DiscoveryItemType.ad;
      case 'topic':
        return DiscoveryItemType.topic;
      case 'post':
        return DiscoveryItemType.post;
      case 'video':
        return DiscoveryItemType.video;
      case 'news':
        return DiscoveryItemType.news;
      case 'article':
        return DiscoveryItemType.article;
      default:
        return DiscoveryItemType.post;
    }
  }

  static String _typeToString(DiscoveryItemType type) => type.name;

  factory DiscoveryItem.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryItemFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryItemToJson(this);
}

/// [OfficialItem] - 官方数据项模型（如：活动 Banner、资讯条目）
@JsonSerializable()
class OfficialItem {
  final String id;              // 条目唯一标识
  final String title;           // 主标题
  final String? subtitle;       // 副标题/描述
  final String image;           // 封面图片 URL
  final String? date;           // 发布日期/活动日期
  final int? views;             // 阅读数/浏览数
  final int? points;            // 参与积分奖励（若有）
  final String? tag;            // 标签（如：进行中、已结束）

  const OfficialItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.date,
    this.views,
    this.points,
    this.tag,
  });

  factory OfficialItem.fromJson(Map<String, dynamic> json) =>
      _$OfficialItemFromJson(json);

  Map<String, dynamic> toJson() => _$OfficialItemToJson(this);
}

/// [OfficialSection] - 官方数据模块（按分组展示，如：官方动态、热门活动）
@JsonSerializable()
class OfficialSection {
  final String id;              // 模块唯一标识
  final String title;           // 模块分组标题
  final List<OfficialItem> items; // 分组内的条目列表

  const OfficialSection({
    required this.id,
    required this.title,
    required this.items,
  });

  factory OfficialSection.fromJson(Map<String, dynamic> json) =>
      _$OfficialSectionFromJson(json);

  Map<String, dynamic> toJson() => _$OfficialSectionToJson(this);
}

/// [OfficialData] - 发现页“官方”频道的完整数据
@JsonSerializable()
class OfficialData {
  final List<OfficialItem> slides;      // 顶部轮播图列表
  final List<OfficialSection> sections; // 分组内容块列表

  const OfficialData({
    required this.slides,
    required this.sections,
  });

  factory OfficialData.fromJson(Map<String, dynamic> json) =>
      _$OfficialDataFromJson(json);

  Map<String, dynamic> toJson() => _$OfficialDataToJson(this);
}

/// [WeekendRoute] - 发现页“撒野/去野”——周末漫游路线
@JsonSerializable()
class WeekendRoute {
  final String id;              // 路线唯一标识
  final String title;           // 路线名
  final String location;        // 目的地城市/地区
  final String difficulty;      // 难度等级（如：简单、中等、极难）
  final String duration;        // 预计耗时
  final String distance;        // 全程公里数
  final String image;           // 路线封面图
  final int likes;              // 收藏/点赞人数

  const WeekendRoute({
    required this.id,
    required this.title,
    required this.location,
    required this.difficulty,
    required this.duration,
    required this.distance,
    required this.image,
    required this.likes,
  });

  factory WeekendRoute.fromJson(Map<String, dynamic> json) =>
      _$WeekendRouteFromJson(json);

  Map<String, dynamic> toJson() => _$WeekendRouteToJson(this);
}

/// [CrossingChallenge] - 发现页“撒野/去野”——越野穿越挑战
@JsonSerializable()
class CrossingChallenge {
  final String id;              // 挑战唯一标识
  final String title;           // 挑战名称
  final String location;        // 挑战地点
  final String difficulty;      // 关卡难度
  final String reward;          // 完成奖励描述
  final String image;           // 背景封面图
  final int participants;       // 当前参与人数
  final int altitude;           // 最高海拔（单位：m）
  final List<String> tags;      // 环境标签（如：沙漠、山脉）

  const CrossingChallenge({
    required this.id,
    required this.title,
    required this.location,
    required this.difficulty,
    required this.reward,
    required this.image,
    required this.participants,
    required this.altitude,
    required this.tags,
  });

  factory CrossingChallenge.fromJson(Map<String, dynamic> json) =>
      _$CrossingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$CrossingChallengeToJson(this);
}

/// [CampingSpot] - 发现页“撒野/去野”——推荐露营地点
@JsonSerializable()
class CampingSpot {
  final String id;              // 露营点唯一标识
  final String name;            // 营地名称（如：星空营地）
  final String title;           // 推荐语标题
  final String location;        // 具体地理位置
  final String facilities;      // 设施配套说明
  final String image;           // 营地实景图
  final double rating;          // 星级评分
  final List<String> tags;      // 特色标签（如：森林、溪流、亲子）
  final int likes;              // 种草/点赞数

  const CampingSpot({
    required this.id,
    required this.name,
    required this.title,
    required this.location,
    required this.facilities,
    required this.image,
    required this.rating,
    required this.tags,
    required this.likes,
  });

  factory CampingSpot.fromJson(Map<String, dynamic> json) =>
      _$CampingSpotFromJson(json);

  Map<String, dynamic> toJson() => _$CampingSpotToJson(this);
}

/// [GoWildData] - 发现页“撒野/去野”频道的完整数据
@JsonSerializable()
class GoWildData {
  final List<WeekendRoute> weekendRoutes;
  final List<CrossingChallenge> crossingChallenges;
  final List<CampingSpot> campingSpots;

  const GoWildData({
    required this.weekendRoutes,
    required this.crossingChallenges,
    required this.campingSpots,
  });

  factory GoWildData.fromJson(Map<String, dynamic> json) =>
      _$GoWildDataFromJson(json);

  Map<String, dynamic> toJson() => _$GoWildDataToJson(this);
}