import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Share2, 
  ShoppingCart, 
  ChevronRight, 
  Minus, 
  Plus, 
  Store, 
  X, 
  CheckCircle2, 
  Heart,
  Truck,
  Shield,
  Star
} from 'lucide-react';
import { StoreProduct } from '../types';
import { ActionButton } from './ui/Button';

interface StoreProductDetailViewProps {
  product: StoreProduct;
  isInitiallyFavorited?: boolean;
  onBack: () => void;
  onCheckout: (orderData: any) => void;
  onAddToCart?: (item: any) => void;
  onGoToCart?: () => void;
  onToggleFavorite?: (id: string) => void;
  cartCount?: number;
}

const SKU_ATTRIBUTES = [
    {
        id: 'color',
        name: '外观颜色',
        options: [
            { label: '极夜黑', value: 'black' },
            { label: '硬派灰', value: 'grey' }
        ]
    },
    {
        id: 'spec',
        name: '适用规格',
        options: [
            { label: 'BJ40专用', value: 'bj40', priceMod: 0 },
            { label: 'BJ60专用', value: 'bj60', priceMod: 50 }
        ]
    }
];

const DETAIL_STREAM_IMAGES = [
    'https://i.imgs.ovh/2025/12/25/CG5HDa.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG52Fe.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5JIt.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5oaq.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG545C.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5EE4.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5l0A.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5tbN.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5K2H.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5pXU.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5hFX.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5GDQ.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5mhF.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5xam.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5B59.jpeg'
];

const StoreProductDetailView: React.FC<StoreProductDetailViewProps> = ({ 
  product, 
  isInitiallyFavorited = false, 
  onBack, 
  onCheckout, 
  onAddToCart, 
  onGoToCart, 
  onToggleFavorite, 
  cartCount = 0 
}) => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [showSkuModal, setShowSkuModal] = useState(false);
  const [isFavorited, setIsFavorited] = useState(isInitiallyFavorited);
  const [currentGalleryIndex, setCurrentGalleryIndex] = useState(1);
  const scrollRef = useRef<HTMLDivElement>(null);
  const galleryRef = useRef<HTMLDivElement>(null);
  
  const [selections, setSelections] = useState<Record<string, any>>({
      color: SKU_ATTRIBUTES[0].options[0],
      spec: SKU_ATTRIBUTES[1].options[0]
  });
  const [quantity, setQuantity] = useState(1);

  const basePrice = parseFloat(product.price.replace(',', ''));
  const specPrice = basePrice + (selections.spec?.priceMod || 0);
  const galleryImages = DETAIL_STREAM_IMAGES.slice(0, 5);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        setIsScrolled(scrollRef.current.scrollTop > 100);
      }
    };
    const el = scrollRef.current;
    if (el) {
        el.addEventListener('scroll', handleScroll);
        return () => el.removeEventListener('scroll', handleScroll);
    }
  }, []);

  const handleGalleryScroll = () => {
      if (galleryRef.current) {
          const scrollLeft = galleryRef.current.scrollLeft;
          const width = galleryRef.current.offsetWidth;
          const index = Math.round(scrollLeft / width) + 1;
          setCurrentGalleryIndex(index);
      }
  };

  const handleToggleFav = () => {
      setIsFavorited(!isFavorited);
      onToggleFavorite?.(product.id);
  };

  const doAddToCart = () => {
      onAddToCart?.({
          ...product,
          price: specPrice.toLocaleString(),
          selectedSpec: `${selections.color.label} ${selections.spec.label}`,
          quantity: quantity
      });
      setShowSkuModal(false);
  };

  const doBuyNow = () => {
      const checkoutData = [{
          product: { ...product, price: specPrice.toLocaleString() },
          spec: `${selections.color.label} ${selections.spec.label}`,
          quantity: quantity
      }];
      onCheckout(checkoutData);
      setShowSkuModal(false);
  };

  return (
    <div className="absolute inset-0 z-[200] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className={`absolute top-0 left-0 right-0 z-50 pt-[54px] transition-all duration-300 ${
          isScrolled ? 'bg-white/95 backdrop-blur-md shadow-sm text-[#111]' : 'bg-transparent text-white' 
      }`}>
         <div className="flex items-center justify-between px-5 pb-3 relative z-10">
             <button onClick={onBack} className={`w-9 h-9 rounded-full flex items-center justify-center transition-all active:scale-90 ${isScrolled ? 'bg-gray-100' : 'bg-black/20 backdrop-blur-md'}`}>
                 <ArrowLeft size={22} />
             </button>
             <div className={`text-[16px] font-bold transition-opacity duration-300 ${isScrolled ? 'opacity-100' : 'opacity-0'}`}>商品详情</div>
             <div className="flex gap-2">
                 <button onClick={handleToggleFav} className={`w-9 h-9 rounded-full flex items-center justify-center transition-all active:scale-125 ${isScrolled ? 'bg-gray-100' : 'bg-black/20 backdrop-blur-md'}`}>
                     <Heart size={20} className={isFavorited ? 'fill-[#FF4D4F] text-[#FF4D4F]' : ''} />
                 </button>
                 <button className={`w-9 h-9 rounded-full flex items-center justify-center transition-all active:scale-90 ${isScrolled ? 'bg-gray-100' : 'bg-black/20 backdrop-blur-md'}`}><Share2 size={20} /></button>
             </div>
         </div>
      </div>

      <div ref={scrollRef} className="flex-1 overflow-y-auto no-scrollbar pb-[120px]">
          <div className="relative h-[440px] w-full bg-white overflow-hidden">
              <div ref={galleryRef} onScroll={handleGalleryScroll} className="flex h-full overflow-x-auto snap-x snap-mandatory no-scrollbar">
                  {galleryImages.map((img, i) => (
                      <div key={i} className="w-full h-full shrink-0 snap-center bg-gray-50 flex items-center justify-center">
                          <img src={img} className="w-full h-full object-cover" alt={`Gallery ${i}`} />
                      </div>
                  ))}
              </div>
              <div className="absolute bottom-6 right-6 bg-black/40 backdrop-blur-md text-white text-[11px] font-bold font-oswald px-3 py-1 rounded-full border border-white/10 shadow-lg tracking-wider">
                  {currentGalleryIndex} / {galleryImages.length}
              </div>
          </div>

          <div className="px-4 space-y-3 pt-5 pb-10">
              <div className="bg-white p-6 rounded-[24px] shadow-sm border border-white">
                  <div className="flex items-baseline gap-1 text-[#FF6B00] font-oswald mb-2">
                      <span className="text-[16px] font-bold">¥</span>
                      <span className="text-[38px] font-bold leading-none">{basePrice.toLocaleString()}</span>
                      {product.originalPrice && (
                          <span className="text-[14px] text-gray-300 line-through font-normal ml-3">¥{product.originalPrice}</span>
                      )}
                  </div>
                  <h1 className="text-[21px] font-bold text-[#111] leading-tight mb-6">{product.title}</h1>
                  <div className="flex items-center justify-between bg-[#F9FAFB] rounded-2xl p-4 border border-gray-100">
                      <div className="flex gap-5">
                          <TrustBadge icon={CheckCircle2} text="官方正品" />
                          <TruckBadge icon={Truck} text="顺丰直发" />
                          <TrustBadge icon={Shield} text="品质保障" />
                      </div>
                      <ChevronRight size={16} className="text-gray-300" />
                  </div>
              </div>

              <div onClick={() => setShowSkuModal(true)} className="bg-white p-5 rounded-2xl shadow-sm flex justify-between items-center cursor-pointer active:bg-gray-50 border border-white">
                  <div className="flex items-center gap-4">
                      <span className="text-[13px] font-bold text-gray-400">已选</span>
                      <span className="text-[14px] font-bold text-[#111]">{selections.color.label} · {selections.spec.label} · {quantity}件</span>
                  </div>
                  <ChevronRight size={18} className="text-gray-300" />
              </div>

              <div className="bg-white p-5 rounded-2xl shadow-sm border border-white">
                  <div className="flex justify-between items-center mb-5">
                      <div className="flex items-center gap-2">
                          <span className="text-[15px] font-bold text-[#111]">用户评价</span>
                          <span className="text-[11px] text-gray-400 font-medium">(128+)</span>
                      </div>
                      <button className="flex items-center text-[12px] font-bold text-[#FF6B00]">
                          99% 好评率 <ChevronRight size={14} className="ml-0.5" />
                      </button>
                  </div>
                  <div className="bg-[#F9FAFB] rounded-xl p-4 border border-gray-100/50">
                      <div className="flex justify-between items-center mb-3">
                          <div className="flex items-center gap-2">
                              <img src="https://randomuser.me/api/portraits/men/32.jpg" className="w-6 h-6 rounded-full border border-white shadow-sm" />
                              <span className="text-[12px] font-bold text-[#111]">越野老炮***</span>
                          </div>
                          <div className="flex gap-0.5">
                              {[1,2,3,4,5].map(s => <Star key={s} size={10} className="fill-[#FF6B00] text-[#FF6B00]" />)}
                          </div>
                      </div>
                      <p className="text-[13px] text-[#4B5563] leading-relaxed line-clamp-2 mb-3">
                          东西做工扎实，严丝合缝。北京汽车官方出的精品确实不一样，安装很简单，无损替换原车位。
                      </p>
                      <div className="text-[10px] text-gray-400 font-medium flex gap-3">
                          <span>极夜黑 · BJ40专用</span>
                          <span>2024-01-12</span>
                      </div>
                  </div>
              </div>

              <div className="pt-6">
                  <div className="px-1 mb-6 flex items-center gap-3">
                      <div className="w-1.5 h-5 bg-[#111] rounded-full" />
                      <h2 className="text-[19px] font-bold text-[#111] tracking-tight">图文详情</h2>
                  </div>
                  <div className="-mx-4 flex flex-col">
                      {DETAIL_STREAM_IMAGES.map((img, i) => (
                          <div key={i} className="w-full bg-gray-50 overflow-hidden">
                              <img src={img} className="w-full h-auto block" alt={`Detail ${i}`} loading="lazy" />
                          </div>
                      ))}
                  </div>
                  <div className="py-16 text-center">
                      <div className="w-12 h-0.5 bg-gray-200 mx-auto mb-5 rounded-full" />
                      <p className="text-[10px] text-gray-300 font-bold uppercase tracking-[0.4em]">Precision Engineered by Baic Official</p>
                  </div>
              </div>
          </div>
      </div>

      <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-xl border-t border-gray-100 px-5 pt-3 pb-[34px] z-[60] flex items-center gap-4 shadow-[0_-8px_30px_rgba(0,0,0,0.06)]">
          <div className="flex gap-6 shrink-0 ml-1">
              <button className="flex flex-col items-center gap-1.5 text-[#111] active:opacity-60 transition-opacity">
                  <Store size={20} strokeWidth={2} />
                  <span className="text-[10px] font-bold">店铺</span>
              </button>
              <button onClick={onGoToCart} className="flex flex-col items-center gap-1.5 text-[#111] relative active:opacity-60 transition-opacity">
                  <ShoppingCart size={20} strokeWidth={2} />
                  <span className="text-[10px] font-bold">购物车</span>
                  {cartCount > 0 && <span className="absolute -top-1.5 -right-2 w-4 h-4 bg-[#FF6B00] text-white text-[9px] font-bold rounded-full flex items-center justify-center border-2 border-white shadow-sm">{cartCount}</span>}
              </button>
          </div>
          <div className="flex-1 flex gap-2.5">
              <ActionButton label="加入购物车" variant="secondary" className="flex-1" onClick={() => setShowSkuModal(true)} />
              <ActionButton label="立即购买" className="flex-1" onClick={() => setShowSkuModal(true)} />
          </div>
      </div>

      {showSkuModal && (
          <div className="absolute inset-0 z-[300] flex flex-col justify-end">
              <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-in fade-in duration-300" onClick={() => setShowSkuModal(false)} />
              <div className="bg-white w-full rounded-t-[28px] relative z-10 h-auto max-h-[65%] flex flex-col animate-in slide-in-from-bottom duration-400 shadow-2xl">
                  <div className="px-5 py-4 flex gap-4 border-b border-gray-50 relative shrink-0">
                      <div className="w-[84px] h-[84px] bg-white rounded-xl p-0.5 shadow-lg -mt-10 border border-white overflow-hidden">
                          <img src={galleryImages[0]} className="w-full h-full object-cover rounded-lg" />
                      </div>
                      <div className="flex-1">
                          <div className="flex items-baseline gap-1 text-[#FF6B00] font-oswald">
                              <span className="text-[14px] font-bold">¥</span>
                              <span className="text-[28px] font-bold leading-none">{specPrice.toLocaleString()}</span>
                          </div>
                          <div className="text-[10px] text-gray-400 font-bold uppercase tracking-tight mt-1">官方直营 · 预计 3 日内送达</div>
                      </div>
                      <button onClick={() => setShowSkuModal(false)} className="w-8 h-8 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 active:bg-gray-100"><X size={18} /></button>
                  </div>

                  <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-6">
                      {SKU_ATTRIBUTES.map(attr => (
                          <div key={attr.id}>
                              <div className="text-[13px] font-bold text-[#111] mb-3 flex items-center gap-2">
                                  <div className="w-1 h-3.5 bg-[#111] rounded-full" />
                                  {attr.name}
                              </div>
                              <div className="flex flex-wrap gap-2.5">
                                  {attr.options.map(opt => {
                                      const isSelected = selections[attr.id]?.value === (opt as any).value;
                                      return (
                                          <button 
                                            key={(opt as any).value} 
                                            onClick={() => setSelections(prev => ({ ...prev, [attr.id]: opt }))} 
                                            className={`px-5 py-2.5 rounded-xl text-[12px] font-bold transition-all border-2 ${
                                                isSelected 
                                                ? 'bg-[#111] text-white border-[#111] shadow-md' 
                                                : 'bg-[#F9FAFB] text-gray-400 border-transparent'
                                            }`}
                                          >
                                              {opt.label}
                                          </button>
                                      )
                                  })}
                              </div>
                          </div>
                      ))}

                      <div className="flex justify-between items-center bg-[#F9FAFB] px-4 py-3 rounded-xl border border-gray-100/50">
                          <div className="text-[13px] font-bold text-[#111]">购买数量</div>
                          <div className="flex items-center gap-4 bg-white rounded-lg p-1 border border-gray-100 shadow-sm">
                              <button onClick={() => setQuantity(Math.max(1, quantity - 1))} disabled={quantity <= 1} className="w-7 h-7 rounded flex items-center justify-center text-[#111] active:bg-gray-50 disabled:opacity-20"><Minus size={14} /></button>
                              <span className="text-[15px] font-bold font-oswald w-5 text-center">{quantity}</span>
                              <button onClick={() => setQuantity(quantity + 1)} className="w-7 h-7 rounded flex items-center justify-center text-[#111] active:bg-gray-50"><Plus size={14} /></button>
                          </div>
                      </div>
                  </div>

                  <div className="px-5 pt-3 pb-8 border-t border-gray-100 flex gap-3">
                      <ActionButton label="加入购物车" variant="secondary" className="flex-1" onClick={doAddToCart} />
                      <ActionButton label="立即购买" className="flex-1" onClick={doBuyNow} />
                  </div>
              </div>
          </div>
      )}
    </div>
  );
};

const TrustBadge: React.FC<{ icon: any, text: string }> = ({ icon: Icon, text }) => (
    <div className="flex items-center gap-1.5 text-[11px] text-gray-500 font-bold">
        <Icon size={12} className="text-[#111]" /> {text}
    </div>
);

const TruckBadge: React.FC<{ icon: any, text: string }> = ({ icon: Icon, text }) => (
    <div className="flex items-center gap-1.5 text-[11px] text-[#FF6B00] font-bold">
        <Icon size={12} /> {text}
    </div>
);

export default StoreProductDetailView;