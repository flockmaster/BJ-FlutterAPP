import '../../models/follow_models.dart';

/// Mock数据 - 关注用户列表
/// 像素级还原 beijing-auto-mobile-experience/components/FollowListView.tsx
class MockFollowData {
  static final List<FollowUser> followingUsers = [
    FollowUser(
      id: 1,
      name: '越野老炮',
      bio: '专注硬派越野30年',
      avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
      isFollowing: true,
    ),
    FollowUser(
      id: 2,
      name: '旅行家小王',
      bio: '开着BJ60环游中国',
      avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
      isFollowing: false,
    ),
    FollowUser(
      id: 3,
      name: '改装达人',
      bio: '专业改装咨询',
      avatar: 'https://randomuser.me/api/portraits/women/3.jpg',
      isFollowing: true,
    ),
    FollowUser(
      id: 4,
      name: '北汽铁粉',
      bio: 'BJ40车主，热爱生活',
      avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
      isFollowing: false,
    ),
    FollowUser(
      id: 5,
      name: '荒野求生',
      bio: '户外生存专家',
      avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
      isFollowing: true,
    ),
  ];

  static final List<FollowUser> followerUsers = [
    FollowUser(
      id: 6,
      name: '越野新手',
      bio: '刚入坑，多多指教',
      avatar: 'https://randomuser.me/api/portraits/men/6.jpg',
      isFollowing: false,
    ),
    FollowUser(
      id: 7,
      name: '摄影爱好者',
      bio: '用镜头记录越野之美',
      avatar: 'https://randomuser.me/api/portraits/women/7.jpg',
      isFollowing: true,
    ),
    FollowUser(
      id: 8,
      name: '自驾游达人',
      bio: '走遍中国每一个角落',
      avatar: 'https://randomuser.me/api/portraits/men/8.jpg',
      isFollowing: false,
    ),
  ];
}
