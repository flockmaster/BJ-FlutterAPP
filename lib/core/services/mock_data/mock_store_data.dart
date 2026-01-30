import '../../models/store_models.dart';

/// 商城模拟数据 - 完全按照原型数据
class MockStoreData {
  // 通用规格 - 按照原型设计
  static final List<ProductSpec> _commonSpecs = [
    ProductSpec(
      id: 'color',
      name: '外观颜色',
      options: [
        ProductSpecOption(label: '极夜黑', value: 'black'),
        ProductSpecOption(label: '硬派灰', value: 'grey'),
      ],
    ),
    ProductSpec(
      id: 'spec',
      name: '适用规格',
      options: [
        ProductSpecOption(label: 'BJ40专用', value: 'bj40', priceMod: 0),
        ProductSpecOption(label: 'BJ60专用', value: 'bj60', priceMod: 50),
      ],
    ),
  ];

  static final List<StoreCategory> categories = [
    // 首页
    StoreCategory(
      id: 'home',
      name: '首页',
      slides: [
        const HeroSlide(
          image: 'https://p.sda1.dev/29/a5876f40a89aaf9f085d58bf8d34e32b/0daf825e130979beb562eaa32c62a7a9.jpg',
          title: '探索自然 无界生活',
          subtitle: '户外露营系列新品上市',
        ),
        const HeroSlide(
          image: 'https://p.sda1.dev/29/689afc0950f39e975a482ef34f06531a/207b47ae890c1a757bd91718379c9afc.jpg',
          title: '舒适座舱 悦享旅程',
          subtitle: '打造移动的家',
        ),
      ],
      features: [
        const StoreFeature(
          id: 'owner',
          title: '车主专属',
          subtitle: 'BJ40 定制装备',
          type: 'large',
          image: 'https://p.sda1.dev/29/1e7b491dbe319d8dbc052e744ed10c25/9ffa76eea21a9a2091f581b812717125.jpg',
        ),
        const StoreFeature(
          id: 'points',
          title: '积分好礼',
          subtitle: '0元兑换',
          type: 'small',
          image: 'https://p.sda1.dev/29/86c143bb4c4691b95b048113ef792bd6/8c07e8cc985b558b828118b9be1c2338.jpg',
        ),
        const StoreFeature(
          id: 'seasonal',
          title: '冬季出行',
          subtitle: '防冻必备',
          type: 'small',
          image: 'https://p.sda1.dev/29/678f2159735cd9d265f59f0c9ed5b17e/8d3b6a256747aecb48a968886d0a0cb8.jpg',
        ),
      ],
      hotProducts: [
        StoreProduct(
          id: 1001,
          title: '宇航员门厅自动帐篷DM-1015L',
          price: 699,
          originalPrice: 899,
          image: 'https://youke3.picui.cn/s1/2026/01/06/695cca5f0d0b3.jpg',
          tags: const ['爆款'],
          points: 600,
          specifications: _commonSpecs,
          type: 'physical',
          detailImages: const [
            "https://youke3.picui.cn/s1/2026/01/06/695cca9a97958.jpg",
            "https://youke3.picui.cn/s1/2026/01/06/695cca9bd3151.jpg"
          ],
        ),
        const StoreProduct(
          id: 1002,
          title: '多开门折叠收纳箱',
          price: 69,
          image: 'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          tags: ['热销'],
          points: 50,
          type: 'physical',
        ),
        const StoreProduct(
          id: 1003,
          title: '车内悠享小桌板',
          price: 499,
          image: 'https://images.unsplash.com/photo-1533090481720-856c6e3c1fdc?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 300,
          type: 'physical',
        ),
        const StoreProduct(
          id: 1004,
          title: '四季通用脚垫',
          price: 298,
          originalPrice: 399,
          image: 'https://images.unsplash.com/photo-1584813539806-2538b8d918c6?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 200,
          type: 'physical',
        ),
        const StoreProduct(
          id: 1005,
          title: '强力车载吸尘器',
          price: 199,
          image: 'https://images.unsplash.com/photo-1593113598332-cd288d649433?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 150,
          type: 'physical',
        ),
      ],
      sections: [
        const StoreSection(
          id: 'winter',
          title: '周边好物 | 提升冬日幸福感',
          bannerImage: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=800&auto=format&fit=crop',
          products: [
            StoreProduct(
              id: 2001,
              title: '北京越野六角天幕',
              price: 299,
              image: 'https://p.sda1.dev/29/7c4158055d50cf66ca01b831838ad3f3/e5bb6ba8307b638fb2524835719281d1.jpg',
              tags: ['特惠'],
              points: 200,
              type: 'physical',
              gallery: [
                'https://youke3.picui.cn/s1/2026/01/06/695cc5ff74b2c.jpg',
                'https://youke3.picui.cn/s1/2026/01/06/695cc617b1c85.jpg',
                'https://youke3.picui.cn/s1/2026/01/06/695cc61be5029.jpg',
              ],
              detailImages: [
                'https://p.sda1.dev/30/11b47f20faa8716f5174a11e493d3455/3b6aeaa2194a59587e7048a378169f63.jpg',
                'https://p.sda1.dev/30/4948f91a688feae975aa96f2de57b63c/21c7d79055fa857d8120b5d9ae5fd277.jpg',
              ],
            ),
            StoreProduct(
              id: 2002,
              title: '冬季毛绒方向盘套',
              price: 89,
              originalPrice: 129,
              image: 'https://p.sda1.dev/29/ed08772052eca2ca891b4c3849329f6f/f702ebaf61ca4cdc62c7142b653a1bd5.jpg',
              tags: ['新品'],
              points: 80,
              type: 'physical',
            ),
            StoreProduct(
              id: 2003,
              title: '智能温控保温杯',
              price: 199,
              image: 'https://p.sda1.dev/29/221a80415fbc81346f917a1e30c3bad4/dd8aebba7825b59950e2dc77202d6ce4.jpg',
              points: 100,
              type: 'physical',
            ),
            StoreProduct(
              id: 2004,
              title: '车载电热毯',
              price: 158,
              originalPrice: 298,
              image: 'https://p.sda1.dev/29/46c3fd35ebf1362cd79df7af599ead4c/b3bdbf878fabee9524b4cae3c57a4cc9.jpg',
              tags: ['限时'],
              points: 150,
              type: 'physical',
            ),
            StoreProduct(
              id: 2005,
              title: '香氛补充装 (暖阳)',
              price: 69,
              image: 'https://p.sda1.dev/29/f28d8c9ff9d7b85db9b766bfc5b884a5/f86037c9c6a612e30dd4d6e2cc1ce83a.jpg',
              points: 60,
              type: 'physical',
            ),
            StoreProduct(
              id: 2006,
              title: '应急启动电源',
              price: 399,
              image: 'https://p.sda1.dev/29/7f1075a7ee4b205251bd7a8c00479c6a/7fc281b69e6ba6688a767c2cfbb6321c.jpg',
              points: 390,
              type: 'physical',
            ),
          ],
        ),
      ],
    ),

    // 改装
    const StoreCategory(
      id: 'modification',
      name: '改装',
      slides: [
        HeroSlide(
          image: 'https://p.sda1.dev/29/fdea5f958f610e4b82e6d628c03eee3c/f2c5c29234a83ab5781c88605ae61d9e.jpg',
          title: '硬派改装 极致性能',
          subtitle: 'BJ40 专属专业改装套件',
        ),
        HeroSlide(
          image: 'https://p.sda1.dev/29/248910c8366e18b0f740f8175eee0b79/8b0862df3ae063ef327ccba5f6a0db8c.jpg',
          title: '征服荒野 无所畏惧',
          subtitle: '全地形越野装备升级',
        ),
      ],
      hotProducts: [
        StoreProduct(
          id: 3001,
          title: '40寸弧形LED越野射灯',
          price: 1280,
          image: 'https://p.sda1.dev/29/cdc7d1682adbcd49c68f14a300759586/469347e1f4c547e368918405eed11ddb.jpg',
          tags: ['亮度之王'],
          points: 1000,
          type: 'service',
        ),
        StoreProduct(
          id: 3002,
          title: 'BJ40前竞技杠',
          price: 2800,
          image: 'https://p.sda1.dev/29/17d7c9c5506e4b8d9ee5f5a4f2c307c3/af2f12c4c79582bd18c5443c852c3739.jpg',
          points: 2000,
          type: 'service',
        ),
        StoreProduct(
          id: 3003,
          title: '铝合金车顶平台',
          price: 1680,
          originalPrice: 1980,
          image: 'https://p.sda1.dev/29/b1e60d765ed37b811423ddfd68a00521/963fad723ed4fb60b24ac889e5cfb3b1.jpg',
          points: 1200,
          type: 'service',
        ),
        StoreProduct(
          id: 3004,
          title: '电动绞盘 (12000磅)',
          price: 3200,
          image: 'https://p.sda1.dev/29/20eadfc3037be0d49bbf675eb8672c0a/5f04dbd6f8ac2441ed9b92dd40300dfb.jpg',
          tags: ['救援'],
          points: 2500,
          type: 'service',
        ),
      ],
      sections: [
        StoreSection(
          id: 'hardcore',
          title: '硬核装备 | 越野必备',
          bannerImage: 'https://p.sda1.dev/29/61376bb77d0df166302a21a01adb74fb/2022192b500f448dd8139441972faf03.jpg',
          products: [
            StoreProduct(
              id: 4001,
              title: 'BJ40专业竞技前杠',
              price: 2800,
              image: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
              tags: ['硬派必备'],
              points: 2000,
              type: 'service',
            ),
            StoreProduct(
              id: 4002,
              title: '越野车顶行李架平台',
              price: 1580,
              image: 'https://images.unsplash.com/photo-1626847037657-fd3622613ce3?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
              points: 1000,
              type: 'service',
            ),
            StoreProduct(
              id: 4003,
              title: '全地形AT越野轮胎 (单条)',
              price: 1200,
              originalPrice: 1500,
              image: 'https://images.unsplash.com/photo-1578844251758-2f71da64522f?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
              tags: ['特惠'],
              points: 800,
              type: 'service',
            ),
            StoreProduct(
              id: 4004,
              title: '12000磅电动绞盘',
              price: 3200,
              image: 'https://images.unsplash.com/photo-1519752440832-628a52cfd771?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
              points: 2500,
              type: 'service',
            ),
            StoreProduct(
              id: 4005,
              title: '升高套件 (2英寸)',
              price: 4500,
              image: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
              tags: ['专业'],
              points: 3000,
              type: 'service',
            ),
            StoreProduct(
              id: 4006,
              title: '涉水喉 (BJ40专用)',
              price: 800,
              image: 'https://images.unsplash.com/photo-1600712242805-5f786716d566?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
              points: 500,
              type: 'service',
            ),
          ],
        ),
      ],
    ),

    // 智能
    const StoreCategory(
      id: 'smart',
      name: '智能',
      slides: [
        HeroSlide(
          image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=800&auto=format&fit=crop',
          title: '虚拟服务 畅享生活',
          subtitle: '加油卡、保养券一键兑换',
        ),
      ],
      hotProducts: [
        StoreProduct(
          id: 5001,
          title: '500元电子加油卡',
          price: 485,
          image: 'https://images.unsplash.com/photo-1545262810-77515befe149?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          tags: ['折扣'],
          points: 500,
          type: 'virtual',
        ),
        StoreProduct(
          id: 5002,
          title: '4K高清行车记录仪',
          price: 599,
          image: 'https://images.unsplash.com/photo-1593113616825-d6e8f4b343e6?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 400,
          type: 'physical',
        ),
        StoreProduct(
          id: 5003,
          title: '基础保养兑换券 (A类)',
          price: 580,
          originalPrice: 680,
          image: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 600,
          type: 'virtual',
        ),
      ],
    ),

    // 户外
    const StoreCategory(
      id: 'outdoor',
      name: '户外',
      slides: [
        HeroSlide(
          image: 'https://images.unsplash.com/photo-1628172813155-2e650f934575?q=80&w=800&auto=format&fit=crop',
          title: '精致露营 拥抱山野',
          subtitle: '车顶帐篷与户外家具系列',
        ),
      ],
      hotProducts: [
        StoreProduct(
          id: 6001,
          title: '全自动液压车顶帐篷',
          price: 4999,
          image: 'https://images.unsplash.com/photo-1628172813155-2e650f934575?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          tags: ['新品'],
          points: 3000,
          type: 'physical',
        ),
        StoreProduct(
          id: 6002,
          title: '便携式户外折叠椅',
          price: 129,
          image: 'https://images.unsplash.com/photo-1596238699684-28b9c6f2a406?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          tags: ['买一送一'],
          points: 80,
          type: 'physical',
        ),
        StoreProduct(
          id: 6003,
          title: '双头户外防风炉具',
          price: 399,
          image: 'https://images.unsplash.com/photo-1595568582736-231a47738241?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 200,
          type: 'physical',
        ),
      ],
    ),

    // 周边
    const StoreCategory(
      id: 'peripherals',
      name: '周边',
      slides: [
        HeroSlide(
          image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=800&auto=format&fit=crop',
          title: '品牌生活 潮酷随行',
          subtitle: '北京汽车官方联名周边',
        ),
      ],
      hotProducts: [
        StoreProduct(
          id: 7001,
          title: 'BJ40合金车模 (1:18)',
          price: 599,
          image: 'https://images.unsplash.com/photo-1594787318286-3d835c1d207f?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 400,
          type: 'physical',
        ),
        StoreProduct(
          id: 7002,
          title: '定制款机能冲锋衣',
          price: 899,
          image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          tags: ['联名'],
          points: 700,
          type: 'physical',
        ),
        StoreProduct(
          id: 7003,
          title: '越野风格棒球帽',
          price: 99,
          image: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=400&auto=format&fit=crop&bg=FFFFFF',
          points: 50,
          type: 'physical',
        ),
      ],
    ),
  ];

  // 热门搜索词
  static const List<String> trendingSearches = [
    'BJ40改装',
    '车顶帐篷',
    '玻璃水',
    '行车记录仪',
    '脚垫',
    '机油',
    '收纳箱',
    '车载冰箱',
  ];
}
