
/// [FollowUser] - 关注/粉丝列表中的用户信息模型
class FollowUser {
  final int id;                 // 用户唯一标识
  final String name;            // 用户昵称
  final String bio;             // 个人简介/签名
  final String avatar;          // 用户头像 URL
  final bool isFollowing;       // 当前登录用户是否已关注该用户

  FollowUser({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatar,
    required this.isFollowing,
  });

  /// 快捷复制并修改关注状态的方法
  FollowUser copyWith({
    int? id,
    String? name,
    String? bio,
    String? avatar,
    bool? isFollowing,
  }) {
    return FollowUser(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
