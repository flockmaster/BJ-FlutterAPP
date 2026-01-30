
import { CarModel, StoreCategory, DiscoveryItem, DiscoveryItemType, OfficialSection, ModItem, QAItem, HeroSlide, GoWildData, ModService, ModShop, StoreProduct } from './types';

export const CAR_DATA: Record<string, CarModel> = {
  BJ30: {
    id: 'BJ30',
    name: 'BJ30',
    fullName: '北京 BJ30',
    subtitle: '城市 越野 时尚 SUV',
    price: '10.99',
    priceUnit: '万元起',
    // backgroundImage: 'https://www.helloimg.com/i/2025/12/23/694a28786f2d1.jpg',
    backgroundImage: 'https://youke3.picui.cn/s1/2026/01/07/695e236e0200d.jpg',
    promoPrice: '8,000元',
    highlightImage: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop',
    highlightText: '一图看懂北京BJ30',
    vrImage: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop',
    isPreview: false,
    store: {
      image: 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=800&auto=format&fit=crop',
      name: '北京汽车北京朝阳4S店',
      address: '北京市朝阳区东三环北路38号安联大厦...',
      distance: '2.8公里'
    },
    versions: {
      home: {
        id: 'home',
        name: '旅行家版',
        badge: '旅行家版',
        badgeColor: '#3498DB',
        features: ['2.0T涡轮增压发动机', '分时四驱系统', '全景天窗', '多功能方向盘', '倒车影像', '自动空调'],
        price: '109,900'
      },
      ultra: {
        id: 'ultra',
        name: '旅行家Pro版',
        badge: '旅行家Pro版',
        badgeColor: '#9B59B6',
        features: ['2.0T涡轮增压发动机', '分时四驱系统', '真皮座椅', '倒车影像', '自动空调', '定速巡航', '无钥匙进入'],
        price: '129,900'
      }
    }
  },
  BJ40: {
    id: 'BJ40',
    name: 'BJ40',
    fullName: '北京 BJ40',
    subtitle: '硬派 越野 经典 SUV',
    price: '15.98',
    priceUnit: '万元起',
    backgroundImage: 'https://www.helloimg.com/i/2025/12/23/694a28886a3df.jpg',
    heroVideo: 'bj40.mp4',
    promoPrice: '12,000元',
    highlightImage: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800&auto=format&fit=crop',
    highlightText: '一图看懂北京BJ40',
    vrImage: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop',
    isPreview: false,
    store: {
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=800&auto=format&fit=crop',
      name: '北京汽车上海浦东4S店',
      address: '上海市浦东新区龙阳路2277号汇智国际商业中心...',
      distance: '4.5公里'
    },
    versions: {
      home: {
        id: 'home',
        name: '城市猎人版',
        badge: '城市猎人版',
        badgeColor: '#4A90E2',
        features: ['2.0T涡轮增压', '适时四驱', '城市包围', '全景天窗', '真皮座椅', '智能互联'],
        price: '159,800'
      },
      ultra: {
        id: 'ultra',
        name: '环塔冠军版',
        badge: '环塔冠军版',
        badgeColor: '#E74C3C',
        features: ['2.3T涡轮增压', '分时四驱', '前中后三把锁', '涉水喉', '绞盘', 'MT越野轮胎', '改装悬架', '越野套件'],
        price: '229,800'
      },
      premium: {
        id: 'premium',
        name: '雨林穿越版',
        badge: '雨林穿越版',
        badgeColor: '#27AE60',
        features: ['2.0T涡轮增压', '分时四驱', '前后差速锁', '涉水喉', '绞盘', 'MT越野轮胎', '雨林涂装', '越野套件'],
        price: '219,800'
      }
    }
  },
  BJ60: {
    id: 'BJ60',
    name: 'BJ60',
    fullName: '北京 BJ60',
    subtitle: '豪华 越野 大型 SUV',
    price: '23.98',
    priceUnit: '万元起',
    backgroundImage: 'https://www.helloimg.com/i/2025/12/23/694a287799635.jpg',
    promoPrice: '18,000元',
    highlightImage: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?q=80&w=800&auto=format&fit=crop',
    highlightText: '一图看懂北京BJ60',
    vrImage: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop',
    isPreview: false,
    store: {
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=800&auto=format&fit=crop',
      name: '北京汽车北京通州4S店',
      address: '北京市通州区新华大街58号北汽大厦...',
      distance: '3.2公里'
    },
    versions: {
      home: {
        id: 'home',
        name: '周末版',
        badge: '周末版',
        badgeColor: '#16A085',
        features: ['3.0T V6发动机', '全时四驱', '空气悬架', 'Nappa真皮座椅', '全景天窗', '智能驾驶辅助', '12.8英寸中控屏'],
        price: '239,800'
      },
      ultra: {
        id: 'ultra',
        name: '五一版',
        badge: '五一版',
        badgeColor: '#E67E22',
        features: ['3.0T V6发动机', '全时四驱', '空气悬架', 'Nappa真皮座椅', '全景天窗', '智能驾驶辅助', '12.8英寸中控屏', '后排娱乐系统', '哈曼卡顿音响'],
        price: '269,800'
      },
      premium: {
        id: 'premium',
        name: '千里版',
        badge: '千里版',
        badgeColor: '#8E44AD',
        features: ['3.0T V6发动机', '全时四驱', '空气悬架', 'Nappa真皮座椅', '全景天窗', '智能驾驶辅助Pro', '12.8英寸中控屏', '后排娱乐系统', '哈曼卡顿音响', '越野套件', '车载冰箱'],
        price: '299,800'
      }
    }
  },
  BJ80: {
    id: 'BJ80',
    name: 'BJ80',
    fullName: '北京 BJ80',
    subtitle: '旗舰 越野 大型 SUV',
    price: '29.80',
    priceUnit: '万元起',
    backgroundImage: 'https://www.helloimg.com/i/2025/12/23/694a287c83bcf.jpg',
    promoPrice: '25,000元',
    highlightImage: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?q=80&w=800&auto=format&fit=crop',
    highlightText: '一图看懂北京BJ80',
    vrImage: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800&auto=format&fit=crop',
    isPreview: false,
    store: {
      image: 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?q=80&w=800&auto=format&fit=crop',
      name: '北京汽车深圳南山4S店',
      address: '深圳市南山区深南大道9988号北汽展厅...',
      distance: '5.1公里'
    },
    versions: {
      home: {
        id: 'home',
        name: '至尊版',
        badge: '至尊版',
        badgeColor: '#C0392B',
        features: ['3.0T V6发动机', '全时四驱', '空气悬架', 'Nappa真皮座椅', '全景天窗', '智能驾驶辅助', '越野模式', '12.3英寸液晶仪表'],
        price: '298,000'
      },
      ultra: {
        id: 'ultra',
        name: '侠客版',
        badge: '侠客版',
        badgeColor: '#2C3E50',
        features: ['3.0T V6发动机', '全时四驱', '空气悬架', 'Nappa真皮座椅', '全景天窗', '智能驾驶辅助', '越野模式', '12.3英寸液晶仪表', '后排娱乐系统', '哈曼卡顿音响', '车载冰箱', '越野套件'],
        price: '358,000'
      },
      premium: {
        id: 'premium',
        name: '珠峰版',
        badge: '珠峰版',
        badgeColor: '#D4A574',
        features: ['3.0T V6发动机', '全时四驱', '空气悬架', 'Nappa真皮座椅', '全景天窗', '智能驾驶辅助Pro', '越野模式', '12.3英寸液晶仪表', '后排娱乐系统', '哈曼卡顿音响', '车载冰箱', '越野套件', '限量版涂装'],
        price: '398,000'
      }
    }
  },
  WARRIOR: {
    id: 'WARRIOR',
    name: 'WARRIOR',
    fullName: 'WARRIOR 战士皮卡',
    subtitle: '硬派 越野 全能 皮卡',
    price: '即将发布',
    priceUnit: '',
    backgroundImage: 'https://images.unsplash.com/photo-1579567761406-4684ee0c75b6?q=80&w=800&auto=format&fit=crop',
    promoPrice: '敬请期待',
    highlightImage: 'https://images.unsplash.com/photo-1553440569-bcc63803a83d?q=80&w=800&auto=format&fit=crop',
    highlightText: 'WARRIOR 即将登场',
    vrImage: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?q=80&w=800&auto=format&fit=crop',
    isPreview: true,
    releaseDate: '2025年第二季度',
    countdown: {
      days: 120,
      hours: 15,
      minutes: 30
    },
    store: {
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=800&auto=format&fit=crop',
      name: '北京汽车广州天河4S店',
      address: '广州市天河区天河路228号北汽展厅...',
      distance: '6.3公里'
    },
    previewFeatures: [
      { icon: 'mountain', title: '硬派越野', desc: '非承载式车身，分时/全时四驱可选' },
      { icon: 'truck', title: '超强载重', desc: '1.5米货箱，最大载重1.2吨' },
      { icon: 'settings', title: '强劲动力', desc: '2.0T/3.0T双动力选择' },
      { icon: 'shield', title: '越野套件', desc: '差速锁、绞盘、涉水喉等专业配置' }
    ]
  }
};

const HOT_PRODUCTS: StoreProduct[] = [
    { id: 'p1', title: 'BJ40 专用TPE脚垫', price: '298', originalPrice: '498', image: 'https://images.unsplash.com/photo-1584813539806-2538b8d918c6?q=80&w=400&auto=format&fit=crop', tags: ['专车专用'] },
    { id: 'p2', title: '户外露营天幕帐篷', price: '899', originalPrice: '1299', image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400&auto=format&fit=crop', tags: ['新品'] },
    { id: 'p3', title: '车载折叠收纳箱', price: '128', originalPrice: '199', image: 'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?q=80&w=400&auto=format&fit=crop', tags: ['热销'] },
    { id: 'p4', title: '全合成机油保养套餐', price: '580', originalPrice: '780', image: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?q=80&w=400&auto=format&fit=crop', tags: ['服务'] }
];

export const STORE_CATEGORIES: StoreCategory[] = [
  { 
    id: 'home', 
    name: '首页', 
    slides: [
      { 
        image: 'https://p.sda1.dev/29/a5876f40a89aaf9f085d58bf8d34e32b/0daf825e130979beb562eaa32c62a7a9.jpg',
        title: '探索自然 无界生活',
        subtitle: '户外露营系列新品上市'
      },
      { 
        image: 'https://p.sda1.dev/29/689afc0950f39e975a482ef34f06531a/207b47ae890c1a757bd91718379c9afc.jpg',
        title: '舒适座舱 悦享旅程',
        subtitle: '打造移动的家'
      }
    ],
    features: [
      {
        id: 'owner',
        title: '车主专属',
        subtitle: 'BJ40 定制装备',
        type: 'large',
        image: 'https://p.sda1.dev/29/1e7b491dbe319d8dbc052e744ed10c25/9ffa76eea21a9a2091f581b812717125.jpg'
      },
      {
        id: 'points',
        title: '积分好礼',
        subtitle: '0元兑换',
        type: 'small',
        image: 'https://p.sda1.dev/29/86c143bb4c4691b95b048113ef792bd6/8c07e8cc985b558b828118b9be1c2338.jpg'
      },
      {
        id: 'seasonal',
        title: '冬季出行',
        subtitle: '防冻必备',
        type: 'small',
        image: 'https://p.sda1.dev/29/678f2159735cd9d265f59f0c9ed5b17/3039d93cdb3379207e0b3c2243e887e2.jpg'
      }
    ],
    hotProducts: HOT_PRODUCTS,
    sections: [
        {
            id: 'winter',
            title: '暖冬好物|温暖随行',
            bannerImage: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=800&auto=format&fit=crop',
            products: HOT_PRODUCTS.slice(0, 2)
        }
    ]
  },
  {
      id: 'parts',
      name: '改装',
      slides: [
          { image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop', title: '硬派改装', subtitle: '专业越野套件' }
      ],
      hotProducts: HOT_PRODUCTS.slice(2, 4)
  },
  {
      id: 'camping',
      name: '露营',
      slides: [
          { image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800&auto=format&fit=crop', title: '野奢露营', subtitle: '精致户外生活' }
      ],
      hotProducts: HOT_PRODUCTS.slice(1, 3)
  }
];

export const STORE_TRENDING_SEARCHES = ['BJ40 改装', '露营帐篷', '车载冰箱', '脚垫', '机油', '雨刷'];

export const DISCOVERY_DATA: DiscoveryItem[] = [
    {
        id: 'p1',
        type: 'post',
        title: '周末去野！BJ40 穿越老掌沟',
        content: '这次和车友会的朋友们一起挑战老掌沟，BJ40的表现太给力了！素车直拔好汉坡，完全没压力。',
        image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop',
        images: ['https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop', 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop'],
        user: { name: '越野老炮', avatar: 'https://randomuser.me/api/portraits/men/1.jpg', time: '2小时前', carModel: 'BJ40', vipLevel: 4 },
        likes: 128,
        comments: 32,
        shares: 10
    },
    {
        id: 'p2',
        type: 'video',
        title: 'BJ60 沉浸式露营体验',
        content: '带上家人，开着BJ60去寻找诗和远方。车内空间巨大，后排直接变大床，太舒服了。',
        image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800&auto=format&fit=crop',
        user: { name: '旅行家小王', avatar: 'https://randomuser.me/api/portraits/men/2.jpg', time: '5小时前', carModel: 'BJ60', vipLevel: 3 },
        likes: 256,
        comments: 45,
        shares: 22,
        isVideo: true
    },
    {
        id: 'p3',
        type: 'post',
        title: '我的改装清单分享',
        content: '很多车友问我改了什么，今天整理了一份清单给大家参考。底盘升高2寸，换了MT胎，加装了绞盘...',
        image: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800&auto=format&fit=crop',
        user: { name: '改装达人', avatar: 'https://randomuser.me/api/portraits/women/3.jpg', time: '昨天', carModel: 'BJ40', vipLevel: 5 },
        likes: 89,
        comments: 12,
        shares: 5
    },
    {
        id: 'p4',
        type: 'article',
        title: '冬季用车注意事项',
        content: '北方入冬了，给大家分享一些冬季用车的小知识，特别是柴油车的车主朋友们要注意...',
        image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=800&auto=format&fit=crop',
        user: { name: '北京汽车官方', avatar: 'https://randomuser.me/api/portraits/men/4.jpg', time: '2天前', vipLevel: 6 },
        tag: '官方',
        tagColor: '#FF6B00',
        likes: 560,
        comments: 88,
        shares: 120
    },
    {
        id: 'p5',
        type: 'post',
        title: '新车提车作业',
        content: '终于提到了心心念念的BJ60，外观霸气，内饰豪华，以后就是尊贵的北汽顺义车主了！',
        image: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop',
        user: { name: '快乐小车主', avatar: 'https://randomuser.me/api/portraits/women/5.jpg', time: '3天前', carModel: 'BJ60' },
        likes: 34,
        comments: 8,
        shares: 2
    },
    {
        id: 'p6',
        type: 'video',
        title: '沙漠冲坡教学',
        content: '新手沙漠驾驶技巧，如何控制油门和方向，避免陷车。',
        image: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop',
        user: { name: '沙漠骆驼', avatar: 'https://randomuser.me/api/portraits/men/6.jpg', time: '4天前', carModel: 'BJ40', vipLevel: 4 },
        likes: 412,
        comments: 56,
        shares: 89,
        isVideo: true
    }
];

export const DISCOVERY_MODEL_DATA = []; 
export const DISCOVERY_FOLLOW_DATA = []; 
export const DISCOVERY_OFFICIAL_DATA: { slides: HeroSlide[], sections: OfficialSection[] } = {
    slides: [
        { image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop', title: 'BJ40 荣耀版上市', subtitle: '致敬经典 越野新生' },
        { image: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop', title: 'BJ60 千里版', subtitle: '长途穿越 首选座驾' }
    ],
    sections: [
        {
            id: 'news',
            title: '最新资讯',
            items: [
                { id: 'n1', title: '北京汽车发布全新技术品牌', image: 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=800&auto=format&fit=crop', date: '2024-01-15', views: 12000, tag: '新闻' },
                { id: 'n2', title: 'BJ40 荣获年度最受欢迎越野车奖', image: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop', date: '2024-01-10', views: 8900, tag: '荣誉' }
            ]
        },
        {
            id: 'activities',
            title: '精彩活动',
            items: [
                { id: 'a1', title: '车主专享：周末露营派对', image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800&auto=format&fit=crop', date: '招募中', views: 5600, points: 800, tag: '活动' },
                { id: 'a2', title: '分享你的越野故事，赢油卡', image: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800&auto=format&fit=crop', date: '进行中', views: 12500, points: 500, tag: '征集' }
            ]
        }
    ]
};

export const DISCOVERY_QA_DATA: QAItem[] = [
    {
        id: 'q1',
        question: 'BJ40城市猎人版油耗大概多少？',
        desc: '主要在市区通勤，偶尔周末出去玩，想问问真实车主的油耗情况。',
        tags: ['用车', '油耗'],
        answersCount: 15,
        views: 3400,
        latestAnswerUser: '老司机',
        latestAnswerAvatar: 'https://randomuser.me/api/portraits/men/10.jpg'
    },
    {
        id: 'q2',
        question: 'BJ60后排能不能放平睡觉？',
        desc: '身高180，想买来当床车自驾游，不知道后排空间够不够。',
        tags: ['空间', '自驾'],
        answersCount: 28,
        views: 5600
    }
];

export const DISCOVERY_WILD_DATA: GoWildData = {
    weekendRoutes: [
        { id: 'w1', type: 'route', title: '京郊秘境：白河峡谷', image: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop', distance: '120km', duration: '1天', difficulty: 2, tags: ['亲子', '玩水'], likes: 230 },
        { id: 'w2', type: 'route', title: '草原天路自驾指南', image: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=800&auto=format&fit=crop', distance: '300km', duration: '2天', difficulty: 1, tags: ['风景', '拍照'], likes: 450 }
    ],
    crossingChallenges: [
        { id: 'c1', type: 'crossing', title: '挑战老掌沟好汉坡', image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop', difficulty: 5, altitude: '1500m', tags: ['硬核', '越野'], likes: 890 }
    ],
    campingSpots: [
        { id: 'cp1', type: 'camping', title: '金海湖露营地', image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800&auto=format&fit=crop', tags: ['草地', '钓鱼'], likes: 340 }
    ]
};

export const DISCOVERY_QA_CATEGORIES = ['全部', '选车', '用车', '保养', '改装', '自驾'];
export const DISCOVERY_QA_EXPERTS = [
    { id: 'e1', name: '技术总监', title: '官方认证专家', avatar: 'https://randomuser.me/api/portraits/men/20.jpg' },
    { id: 'e2', name: '越野队长', title: '资深玩家', avatar: 'https://randomuser.me/api/portraits/men/21.jpg' }
];
