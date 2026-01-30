import '../../models/discovery_models.dart';

class MockDiscoveryData {
  static final List<DiscoveryItem> discoveryItems = [
    // New Post (from migrate-data.ts)
    DiscoveryItem(
      id: 'new-post-bj40-beauty',
      type: DiscoveryItemType.post,
      title: '香车美女！我的BJ40大片来啦',
      content: '终于提车了！特意找了个好天气拍了一组照片。不得不说，BJ40的硬派气质和小姐姐的不仅不冲突，反而更有反差萌！大家觉得这组图能打几分？ #BJ40 #越野女孩 #人像摄影 #最美越野车',
      image: '/Users/tingjing/PycharmProjects/车主APP原型设计/Flutter-APP/backend/public/images/1.jpg',
      images: [
        'assets/images/1.jpg',
        'assets/images/2.jpg',
        'assets/images/3.jpg',
        'assets/images/4.jpg',
        'assets/images/5.jpg',
        'assets/images/6.jpg',
      ],
      user: UserInfo(
        id: 'u_new',
        name: '甜酷小野猫',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ40',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      likes: 5210,
      comments: 328,
      shares: 105,
      commentsList: [
        DiscoveryComment(
          id: 'c1',
          user: UserInfo(id: 'u_c1', name: '越野老司机', avatar: 'https://randomuser.me/api/portraits/men/32.jpg', createdAt: DateTime.now()),
          content: '这组大片拍得太专业了！BJ40和这个环境绝配。',
          likes: 42,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        DiscoveryComment(
          id: 'c2',
          user: UserInfo(id: 'u_c2', name: '小刘同学', avatar: 'https://randomuser.me/api/portraits/women/44.jpg', createdAt: DateTime.now()),
          content: '求摄影器材和调色参数！',
          likes: 15,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ],
      isVideo: false,
    ),

    // Rich Article (rich-article-1)
    DiscoveryItem(
      id: 'rich-article-1',
      type: DiscoveryItemType.article,
      title: '深度体验 | 开着BJ60去川西，寻找最后的香格里拉',
      content: '这次我们驾驶北京汽车BJ60，从成都出发，一路向西，深入川西腹地。在海拔4500米的高原上，BJ60展现出了惊人的稳定性和舒适性。',
      image: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop',
      user: UserInfo(
        id: 'u_rich',
        name: '越野路书',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ60',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      likes: 2450,
      comments: 380,
      shares: 156,
      commentsList: [
        DiscoveryComment(
          id: 'c3',
          user: UserInfo(id: 'u_c3', name: '川西常驻民', avatar: 'https://randomuser.me/api/portraits/men/55.jpg', createdAt: DateTime.now()),
          content: '格聂之眼现在的路况还好吗？准备下周出发。',
          likes: 8,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        DiscoveryComment(
          id: 'c4',
          user: UserInfo(id: 'u_c4', name: '北京汽车内测员', avatar: 'https://randomuser.me/api/portraits/men/12.jpg', createdAt: DateTime.now()),
          content: '看到BJ60在高原的表现这么稳我就放心了。',
          likes: 23,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
      contentBlocks: [
        const DiscoveryContentBlock(type: 'image', imageUrl: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop'),
        const DiscoveryContentBlock(type: 'text', text: '每当我们谈论越野，往往会联想到泥泞、颠簸和艰辛。但这一次，驾驶着BJ60行驶在川西的公路上，我体会到的是一种前所未有的从容。'),
        const DiscoveryContentBlock(type: 'header', text: '启程：成都至康定'),
        const DiscoveryContentBlock(type: 'text', text: '清晨的成都还在沉睡，我们的车队已经整装待发。后备箱里塞满了露营装备和摄影器材，得益于BJ60超大的空间，一切都井井有条。驶入高速，3.0T V6发动机的动力储备深不见底，加速超车行云流水。'),
        const DiscoveryContentBlock(type: 'image', imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop'),
        const DiscoveryContentBlock(type: 'text', text: '翻越折多山是第一道考验。海拔爬升带来的是气温骤降和含氧量降低，但车辆的动力丝毫未减。在垭口短暂亦停留，远处的雪山在云雾中若隐若现，仿佛在召唤我们继续前行。'),
        const DiscoveryContentBlock(type: 'header', text: '深入腹地：格聂之眼'),
        const DiscoveryContentBlock(type: 'image', imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=800&auto=format&fit=crop'),
        const DiscoveryContentBlock(type: 'text', text: '离开铺装路面，我们驶向了通往格聂神山的非铺装道路。这里遍布碎石和炮弹坑，我切换到了越野模式。空气悬架自动升高，配合ATS全地形系统，车辆如履平地。'),
        const DiscoveryContentBlock(type: 'text', text: '底盘的滤震性令人印象深刻，即便是连续的搓板路，车内的咖啡也没有洒出一滴。这种豪华与硬派的结合，正是BJ60的魅力所在。'),
        const DiscoveryContentBlock(type: 'image', imageUrl: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800&auto=format&fit=crop'),
        const DiscoveryContentBlock(type: 'header', text: '星空下的露营'),
        const DiscoveryContentBlock(type: 'text', text: '傍晚，我们在海子边扎营。打开后备箱门，连接上对外放电枪，煮上一壶热茶。看着远处的日照金山，这一刻，所有的疲惫都烟消云散。'),
        const DiscoveryContentBlock(type: 'image', imageUrl: 'https://images.unsplash.com/photo-1516939884455-14a5c08ac121?q=80&w=800&auto=format&fit=crop'),
        const DiscoveryContentBlock(type: 'text', text: '夜晚的气温降至零下，但躺在放平的后排座椅上，透过全景天窗看着满天繁星，车内依然温暖如春。这就是“家玩”越野的意义吧。'),
        const DiscoveryContentBlock(type: 'header', text: '归途'),
        const DiscoveryContentBlock(type: 'image', imageUrl: 'https://images.unsplash.com/photo-1470246973918-29a53221c197?q=80&w=800&auto=format&fit=crop'),
        const DiscoveryContentBlock(type: 'text', text: '为期5天的旅程结束了，但关于探索的故事还在继续。BJ60不仅是一台车，更是连接城市与荒野的桥梁。它让我们有勇气去追寻心中的山海，也能温柔地守护每一次归途。'),
      ],
    ),

    // Wild Photo (wild-photo-1)
    DiscoveryItem(
      id: 'wild-photo-1',
      type: DiscoveryItemType.post,
      title: '',
      content: '终于等到周末了，带着我的BJ60去山里撒野！📸 这光影真的绝了，随手一拍都是大片。强烈推荐这条路线，景美人少！大家觉得这组图怎么样？\n\n#野生摄影达人计划 #北京汽车 #BJ60',
      image: '',
      images: [
        'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=800&auto=format&fit=crop',
      ],
      user: UserInfo(
        id: 'u_photo',
        name: '光影捕手',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ60',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      likes: 128,
      comments: 45,
      shares: 12,
    ),

    // Text Only (feed-1)
    DiscoveryItem(
      id: 'feed-1',
      type: DiscoveryItemType.post,
      title: '',
      content: '今天去店里试驾了BJ60，这个底盘质感真的惊艳到我了！过减速带非常干脆，内饰豪华感也在线，感觉比我现在的车强太多。有没有已经提车的朋友聊聊真实油耗？',
      image: '',
      images: [],
      user: UserInfo(
        id: 'u_feed1',
        name: '想换车的阿强',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100&auto=format&fit=crop',
        carModel: '意向BJ60',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      likes: 24,
      comments: 8,
      shares: 0,
    ),

    // Video Post (feed-2)
    DiscoveryItem(
      id: 'feed-2',
      type: DiscoveryItemType.video,
      title: '周末去哪玩？北京周边越野路线推荐',
      content: '这次我们在老掌沟遇到了大雪，BJ40的表现依然稳健！三把锁一开，什么坡都不在话下。视频里有详细的路书，建议收藏！',
      image: 'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=800&auto=format&fit=crop',
      images: ['https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=800&auto=format&fit=crop'],
      isVideo: true,
      user: UserInfo(
        id: 'u_video',
        name: '越野老炮',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ40',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      likes: 890,
      comments: 124,
      shares: 56,
    ),

    // Single Image (feed-3)
    DiscoveryItem(
      id: 'feed-3',
      type: DiscoveryItemType.post,
      title: '',
      content: '刚刚洗完车，随手拍一张。这颜值，在停车场绝对是最靓的仔！#BJ30 #黑武士',
      image: 'https://images.unsplash.com/photo-1533558701576-23c65e0272fb?q=80&w=800&auto=format&fit=crop',
      images: ['https://images.unsplash.com/photo-1533558701576-23c65e0272fb?q=80&w=800&auto=format&fit=crop'],
      user: UserInfo(
        id: 'u_feed3',
        name: '暗夜骑士',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ30',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      likes: 452,
      comments: 33,
      shares: 12,
    ),

    // Three Images (feed-4)
    DiscoveryItem(
      id: 'feed-4',
      type: DiscoveryItemType.post,
      title: '',
      content: '分享一下我的露营装备，后备箱刚刚好塞满。周末带上家人，去山里吸氧去！',
      image: '',
      images: [
        'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=400&auto=format&fit=crop',
      ],
      user: UserInfo(
        id: 'u_feed4',
        name: '旅行家小王',
        avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ60',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      likes: 128,
      comments: 15,
      shares: 5,
    ),
    
    // Ad (feed-ad)
    DiscoveryItem(
      id: 'feed-ad',
      type: DiscoveryItemType.ad,
      title: '预约试驾 北京BJ60',
      subtitle: '豪华越野 SUV 领导者',
      content: '豪华与越野的完美融合，BJ60现车到店，邀您品鉴。',
      image: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop',
      tag: '预约试驾',
      tagColor: '#00B894',
      user: UserInfo(id: 'official', name: '北京汽车', createdAt: DateTime.now()), // Ad needs mock user for display sometimes
    ),

    // Six Images (feed-5)
    DiscoveryItem(
      id: 'feed-5',
      type: DiscoveryItemType.post,
      title: '',
      content: 'BJ40车友会年会圆满结束！感谢官方的支持，也感谢各位车友的到来。大家一起穿越沙漠，一起吃烤全羊，这才是兄弟！期待明年的聚会！',
      image: '',
      images: [
        'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1605218427306-022ba8c26308?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1483387796030-6b60c04467c6?q=80&w=400&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?q=80&w=400&auto=format&fit=crop',
      ],
      user: UserInfo(
        id: 'u_feed5',
        name: 'BJ40车神',
        avatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ40',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      likes: 1024,
      comments: 88,
      shares: 205,
    ),

    // Text Mock (feed-6)
    DiscoveryItem(
      id: 'feed-6',
      type: DiscoveryItemType.post,
      title: '',
      content: '有没有大神知道这个故障灯是什么意思？在线等，挺急的。',
      image: '',
      images: [],
      user: UserInfo(
        id: 'u_feed6',
        name: '新手小白',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100&auto=format&fit=crop',
        carModel: 'BJ30',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      likes: 5,
      comments: 23,
      shares: 0,
    ),
  ];

  static const OfficialData officialData = OfficialData(
    slides: [
      OfficialItem(
        id: 'slide1',
        title: '全新BJ40上市',
        subtitle: '硬派越野新标杆',
        image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=800&auto=format&fit=crop',
      ),
      OfficialItem(
        id: 'slide2',
        title: '车主权益升级',
        subtitle: '服务更贴心',
        image: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop',
      ),
    ],
    sections: [
      OfficialSection(
        id: 'news',
        title: '官方资讯',
        items: [
          OfficialItem(id: 'n1', title: '北京汽车2025战略发布会回顾', image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=400&auto=format&fit=crop', date: '12-20', views: 5021),
          OfficialItem(id: 'n2', title: '关于BJ60 OTA 2.0版本的更新说明', image: 'https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=400&auto=format&fit=crop', date: '12-18', views: 8900),
          OfficialItem(id: 'n3', title: '越野世家，传承不止', image: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=400&auto=format&fit=crop', date: '12-15', views: 3200),
        ],
      ),
      OfficialSection(
        id: 'activities',
        title: '活动赚积分',
        items: [
          OfficialItem(id: 'act1', title: '野生摄影达人计划', image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=400&auto=format&fit=crop', date: '进行中', views: 12000, points: 500, tag: '赢大奖'),
          OfficialItem(id: 'act2', title: '探秘北京越野超级工厂', image: 'https://images.unsplash.com/photo-1565043666747-69f6646db940?q=80&w=400&auto=format&fit=crop', date: '报名中', views: 8500, points: 200, tag: '限量报名'),
          OfficialItem(id: 'act3', title: '48小时逃离计划', image: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400&auto=format&fit=crop', date: '招募中', views: 23000, points: 1000, tag: '官方活动'),
        ],
      ),
      OfficialSection(
        id: 'ota',
        title: 'OTA升级',
        items: [
          OfficialItem(id: 'ota1', title: 'BJ60 OS 2.1.0 版本更新：新增越野蠕行模式优化', image: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=400&auto=format&fit=crop', date: '12-21', views: 10500),
          OfficialItem(id: 'ota2', title: '车机互联升级：支持无线CarPlay与HiCar', image: 'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=400&auto=format&fit=crop', date: '12-19', views: 9200),
          OfficialItem(id: 'ota3', title: '智能语音助手 OTA：响应速度提升30%', image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=400&auto=format&fit=crop', date: '12-10', views: 7800),
        ],
      ),
      OfficialSection(
        id: 'engineer',
        title: '工程师说车',
        items: [
          OfficialItem(id: 'e1', title: 'BJ60非承载式车身技术解析', image: 'https://images.unsplash.com/photo-1533558701576-23c65e0272fb?q=80&w=400&auto=format&fit=crop', date: '12-22', views: 5600),
          OfficialItem(id: 'e2', title: '如何通过三把锁征服极限路况', image: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=400&auto=format&fit=crop', date: '12-18', views: 4200),
          OfficialItem(id: 'e3', title: '混合动力系统的热管理秘密', image: 'https://images.unsplash.com/photo-1485291571150-772bcfc10da5?q=80&w=400&auto=format&fit=crop', date: '12-15', views: 3800),
        ],
      ),
      OfficialSection(
        id: 'stories',
        title: '车主故事',
        items: [
          OfficialItem(id: 's1', title: '从北京到拉萨，BJ40的三千公里', image: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=400&auto=format&fit=crop', date: '12-10', views: 12000),
          OfficialItem(id: 's2', title: '我和我的“老伙计”BJ80', image: 'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=400&auto=format&fit=crop', date: '12-05', views: 4500),
          OfficialItem(id: 's3', title: '全家人的BJ60幸福时光', image: 'https://images.unsplash.com/photo-1470246973918-29a53221c197?q=80&w=400&auto=format&fit=crop', date: '11-30', views: 8800),
        ],
      ),
      OfficialSection(
        id: 'service',
        title: '服务权益',
        items: [
          OfficialItem(id: 'se1', title: '冬季车辆免费检测服务开启', image: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=400&auto=format&fit=crop', date: '12-01', views: 2200),
          OfficialItem(id: 'se2', title: '金牌技师面对面', image: 'https://images.unsplash.com/photo-1581092921461-eab62e97a783?q=80&w=400&auto=format&fit=crop', date: '11-28', views: 1800),
          OfficialItem(id: 'se3', title: '24小时道路救援权益说明', image: 'https://images.unsplash.com/photo-1625231334106-35db33f45e71?q=80&w=400&auto=format&fit=crop', date: '11-15', views: 3500),
        ],
      ),
    ],
  );

  static const GoWildData goWildData = GoWildData(
    weekendRoutes: [
      WeekendRoute(
        id: '1',
        title: '京郊小瑞士·海坨山谷',
        image: 'assets/images/6.jpg',
        location: '延庆',
        distance: '120km',
        duration: '2h',
        difficulty: '中等',
        likes: 156,
      ),
      WeekendRoute(
        id: '2',
        title: '白河峡谷·百里画廊',
        image: 'assets/images/7.jpg',
        location: '怀柔',
        distance: '150km',
        duration: '2.5h',
        difficulty: '简单',
        likes: 203,
      ),
      WeekendRoute(
        id: '3',
        title: '幽州峡谷·挂壁公路',
        image: 'assets/images/8.jpg',
        location: '门头沟',
        distance: '80km',
        duration: '1.5h',
        difficulty: '困难',
        likes: 89,
      ),
    ],
    crossingChallenges: [
      CrossingChallenge(
        id: 'c1',
        title: '老掌沟·好汉坡',
        location: '门头沟',
        difficulty: '困难',
        reward: '积分奖励',
        image: 'assets/images/9.jpg',
        participants: 45,
        altitude: 1800,
        tags: ['老掌沟', '好汉坡'],
      ),
      CrossingChallenge(
        id: 'c2',
        title: '虎克之路·七公里',
        location: '延庆',
        difficulty: '极难',
        reward: '专属徽章',
        image: 'assets/images/10.jpg',
        participants: 23,
        altitude: 2100,
        tags: ['虎克之路', '越野圣地'],
      ),
    ],
    campingSpots: [
      CampingSpot(
        id: 'cp1',
        name: '金海湖·大溪水',
        title: '金海湖·大溪水',
        location: '平谷区',
        facilities: '湖边草地，可钓鱼',
        image: 'assets/images/11.jpg',
        rating: 4.5,
        tags: ['湖边', '草地', '钓鱼'],
        likes: 128,
      ),
      CampingSpot(
        id: 'cp2',
        name: '玉渡山·高山草甸',
        title: '玉渡山·高山草甸',
        location: '延庆区',
        facilities: '高山草甸，观星胜地',
        image: 'assets/images/12.jpg',
        rating: 4.8,
        tags: ['高山', '星空', '避暑'],
        likes: 256,
      ),
    ],
  );
}
