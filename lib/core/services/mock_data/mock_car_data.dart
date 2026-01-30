import '../../models/car_model.dart';
// If needed for Result wrappers, but here we return raw list

class MockCarData {
  static final List<Map<String, dynamic>> carModelsJson = [
    {
      "id": 1,
      "model_key": "BJ30",
      "name": "BJ30",
      "full_name": "北京BJ30",
      "subtitle": "城市 越野 时尚 SUV",
      "price": 10.99,
      "price_unit": "万元",
      // "background_image": "https://p3.dcarimg.com/img/motor-img/6274479e0a0a501a3070409746e10816_1200x800_1_q80.jpg",
      "background_image": "https://youke3.picui.cn/s1/2026/01/07/695e236e0200d.jpg",
      "promo_price": "8,000元",
      "highlight_image": "https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop",
      "highlight_text": "一图看懂北京BJ30",
      "vr_image": "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop",
      "is_preview": 0,
      "versions": {} 
    },
    {
      "id": 2,
      "model_key": "BJ40",
      "name": "BJ40",
      "full_name": "北京BJ40",
      "subtitle": "硬派 越野 经典 SUV",
      "price": 15.98,
      "price_unit": "万元",
      "background_image": "https://p3.dcarimg.com/img/motor-img/12c176378e9c60634641773489379854_1200x800_1_q80.jpg",
      "promo_price": "12,000元",
      "highlight_image": "https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop",
      "highlight_text": "一图看懂北京BJ40",
      "vr_image": "https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop",
      "is_preview": 0,
      "versions": {}
    },
    {
      "id": 3,
      "model_key": "BJ60",
      "name": "BJ60",
      "full_name": "北京BJ60",
      "subtitle": "豪华 越野 大型 SUV",
      "price": 25.98,
      "price_unit": "万元",
      "background_image": "https://p3.dcarimg.com/img/motor-img/4f72740d7c0065751965155986566066_1200x800_1_q80.jpg",
      "promo_price": "18,000元",
      "highlight_image": "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?q=80&w=800&auto=format&fit=crop",
      "highlight_text": "一图看懂北京BJ60",
      "vr_image": "https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop",
      "is_preview": 0,
      "versions": {}
    },
    {
      "id": 4,
      "model_key": "BJ80",
      "name": "BJ80",
      "full_name": "北京BJ80",
      "subtitle": "旗舰 越野 大型 SUV",
      "price": 29.8,
      "price_unit": "万元",
      "background_image": "https://p3.dcarimg.com/img/motor-img/4223d772935272a80696803704256247_1200x800_1_q80.jpg",
      "promo_price": "25,000元",
      "highlight_image": "https://images.unsplash.com/photo-1514565131-fce0801e5785?q=80&w=800&auto=format&fit=crop",
      "highlight_text": "一图看懂北京BJ80",
      "vr_image": "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800&auto=format&fit=crop",
      "is_preview": 0,
      "versions": {}
    },
    {
      "id": 5,
      "model_key": "WARRIOR",
      "name": "WARRIOR",
      "full_name": "WARRIOR 战士皮卡",
      "subtitle": "硬派 越野 全能 皮卡",
      "price": 0.0,
      "price_unit": "万元",
      "background_image": "https://images.unsplash.com/photo-1579567761406-4684ee0c75b6?q=80&w=800&auto=format&fit=crop",
      "promo_price": "敬请期待",
      "highlight_image": "https://images.unsplash.com/photo-1553440569-bcc63803a83d?q=80&w=800&auto=format&fit=crop",
      "highlight_text": "WARRIOR 即将登场",
      "vr_image": "https://images.unsplash.com/photo-1514565131-fce0801e5785?q=80&w=800&auto=format&fit=crop",
      "is_preview": 1,
      "release_date": "2025-03-15T00:00:00",
      "versions": {},
      "previewFeatures": [
        {"title": "外骨骼架构", "description": "由超硬30X冷轧不锈钢制成"},
        {"title": "防弹玻璃", "description": "超强防护能力"}
      ]
    }
  ];

  static List<CarModel> getCarModels() {
    return carModelsJson.map((e) => CarModel.fromJson(e)).toList();
  }
}
