// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      carModel: json['carModel'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt?.toIso8601String(),
      'carModel': instance.carModel,
    };

DiscoveryComment _$DiscoveryCommentFromJson(Map<String, dynamic> json) =>
    DiscoveryComment(
      id: json['id'] as String,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DiscoveryCommentToJson(DiscoveryComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'content': instance.content,
      'likes': instance.likes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

DiscoveryContentBlock _$DiscoveryContentBlockFromJson(
        Map<String, dynamic> json) =>
    DiscoveryContentBlock(
      type: json['type'] as String,
      text: json['text'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$DiscoveryContentBlockToJson(
        DiscoveryContentBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
    };

DiscoveryItem _$DiscoveryItemFromJson(Map<String, dynamic> json) =>
    DiscoveryItem(
      id: json['id'] as String,
      type: DiscoveryItem._parseType(json['type'] as String?),
      title: json['title'] as String,
      content: json['content'] as String?,
      contentBlocks: (json['contentBlocks'] as List<dynamic>?)
          ?.map(
              (e) => DiscoveryContentBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitle: json['subtitle'] as String?,
      image: json['image'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tag: json['tag'] as String?,
      tagColor: json['tagColor'] as String?,
      user: json['user'] == null
          ? null
          : UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      commentsList: (json['commentsList'] as List<dynamic>?)
          ?.map((e) => DiscoveryComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      isVideo: json['isVideo'] as bool? ?? false,
      isPublished: json['isPublished'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DiscoveryItemToJson(DiscoveryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': DiscoveryItem._typeToString(instance.type),
      'title': instance.title,
      'content': instance.content,
      'contentBlocks': instance.contentBlocks,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'images': instance.images,
      'tag': instance.tag,
      'tagColor': instance.tagColor,
      'user': instance.user,
      'likes': instance.likes,
      'comments': instance.comments,
      'shares': instance.shares,
      'commentsList': instance.commentsList,
      'isVideo': instance.isVideo,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

OfficialItem _$OfficialItemFromJson(Map<String, dynamic> json) => OfficialItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      image: json['image'] as String,
      date: json['date'] as String?,
      views: (json['views'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt(),
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$OfficialItemToJson(OfficialItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'date': instance.date,
      'views': instance.views,
      'points': instance.points,
      'tag': instance.tag,
    };

OfficialSection _$OfficialSectionFromJson(Map<String, dynamic> json) =>
    OfficialSection(
      id: json['id'] as String,
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OfficialItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OfficialSectionToJson(OfficialSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'items': instance.items,
    };

OfficialData _$OfficialDataFromJson(Map<String, dynamic> json) => OfficialData(
      slides: (json['slides'] as List<dynamic>)
          .map((e) => OfficialItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => OfficialSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OfficialDataToJson(OfficialData instance) =>
    <String, dynamic>{
      'slides': instance.slides,
      'sections': instance.sections,
    };

WeekendRoute _$WeekendRouteFromJson(Map<String, dynamic> json) => WeekendRoute(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      difficulty: json['difficulty'] as String,
      duration: json['duration'] as String,
      distance: json['distance'] as String,
      image: json['image'] as String,
      likes: (json['likes'] as num).toInt(),
    );

Map<String, dynamic> _$WeekendRouteToJson(WeekendRoute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'difficulty': instance.difficulty,
      'duration': instance.duration,
      'distance': instance.distance,
      'image': instance.image,
      'likes': instance.likes,
    };

CrossingChallenge _$CrossingChallengeFromJson(Map<String, dynamic> json) =>
    CrossingChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      difficulty: json['difficulty'] as String,
      reward: json['reward'] as String,
      image: json['image'] as String,
      participants: (json['participants'] as num).toInt(),
      altitude: (json['altitude'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CrossingChallengeToJson(CrossingChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'difficulty': instance.difficulty,
      'reward': instance.reward,
      'image': instance.image,
      'participants': instance.participants,
      'altitude': instance.altitude,
      'tags': instance.tags,
    };

CampingSpot _$CampingSpotFromJson(Map<String, dynamic> json) => CampingSpot(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      facilities: json['facilities'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      likes: (json['likes'] as num).toInt(),
    );

Map<String, dynamic> _$CampingSpotToJson(CampingSpot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'location': instance.location,
      'facilities': instance.facilities,
      'image': instance.image,
      'rating': instance.rating,
      'tags': instance.tags,
      'likes': instance.likes,
    };

GoWildData _$GoWildDataFromJson(Map<String, dynamic> json) => GoWildData(
      weekendRoutes: (json['weekendRoutes'] as List<dynamic>)
          .map((e) => WeekendRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      crossingChallenges: (json['crossingChallenges'] as List<dynamic>)
          .map((e) => CrossingChallenge.fromJson(e as Map<String, dynamic>))
          .toList(),
      campingSpots: (json['campingSpots'] as List<dynamic>)
          .map((e) => CampingSpot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GoWildDataToJson(GoWildData instance) =>
    <String, dynamic>{
      'weekendRoutes': instance.weekendRoutes,
      'crossingChallenges': instance.crossingChallenges,
      'campingSpots': instance.campingSpots,
    };
