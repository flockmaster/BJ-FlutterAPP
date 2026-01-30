
import React, { useState, useEffect, useRef } from 'react';
import { 
  ChevronRight, 
  ChevronDown, 
  Navigation, 
  List,
  Calculator,
  RefreshCw,
  BookOpen,
  Mountain,
  Truck,
  Settings,
  Shield,
  Play,
  Heart,
  Trash2,
  Sparkles,
  Loader2
} from 'lucide-react';
import { CAR_DATA } from '../data';
import { WishlistConfig } from '../types'; 
import CarDetailView from './CarDetailView';
import CarOrderView from './CarOrderView';
import TestDriveView from './TestDriveView';
import VRExperienceView from './VRExperienceView';
import CarCompareView from './CarCompareView';
import FinanceCalculatorView from './FinanceCalculatorView'; 
import TradeInView from './TradeInView'; 
import CarSpecsView from './CarSpecsView'; 
import NearbyStoresView from './NearbyStoresView'; 

interface CarBuyingViewProps {
  currentModelKey: string;
  setCurrentModelKey: (key: string) => void;
  onChatOpen: () => void;
}

const MODEL_KEYS = Object.keys(CAR_DATA);

// --- DS 3.1 Constants ---
const COLOR_BG = 'bg-[#F5F7FA]'; 
const COLOR_SURFACE = 'bg-white'; 
const COLOR_PRIMARY = 'text-[#FF6B00]'; 
const BG_DARK = 'bg-[#111111]'; 
const COLOR_TEXT_MAIN = 'text-[#111827]'; 
const SHADOW_CARD = 'shadow-[0_4px_20px_rgba(0,0,0,0.05)]'; 

const CarBuyingView: React.FC<CarBuyingViewProps> = ({ currentModelKey, setCurrentModelKey, onChatOpen }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [isOrdering, setIsOrdering] = useState(false); 
  const [currentVersionKey, setCurrentVersionKey] = useState<string>('home');
  const [showStickyHeader, setShowStickyHeader] = useState(false);
  const [showFloatingBar, setShowFloatingBar] = useState(false);
  
  const [wishlist, setWishlist] = useState<WishlistConfig | null>(null);

  const scrollContainerRef = useRef<HTMLDivElement>(null);
  const videoRef = useRef<HTMLVideoElement>(null);
  const touchStartX = useRef(0);
  const touchEndX = useRef(0);
  
  const [activeSubView, setActiveSubView] = useState<'none' | 'detail' | 'order' | 'test-drive' | 'vr' | 'compare' | 'finance' | 'trade-in' | 'specs' | 'stores'>('none');
  
  const car = CAR_DATA[currentModelKey];
  const version = car.versions?.[currentVersionKey] || (car.versions ? Object.values(car.versions)[0] : null);

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 1000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (videoRef.current) {
        videoRef.current.load();
        videoRef.current.play().catch(e => console.error("Autoplay blocked:", e));
    }
  }, [currentModelKey, car.heroVideo]);

  useEffect(() => {
    if (wishlist && currentModelKey !== wishlist.modelId) {
        setCurrentModelKey(wishlist.modelId);
    }
  }, [wishlist, currentModelKey, setCurrentModelKey]);

  useEffect(() => {
    const container = scrollContainerRef.current;
    if (!container) return;

    const handleScroll = () => {
      const scrollY = container.scrollTop;
      setShowStickyHeader(scrollY > 150 && !wishlist);
      
      const scrollHeight = container.scrollHeight;
      const clientHeight = container.clientHeight;
      const distanceFromBottom = scrollHeight - (scrollY + clientHeight);
      setShowFloatingBar(distanceFromBottom < 300);
    };

    container.addEventListener('scroll', handleScroll);
    return () => container.removeEventListener('scroll', handleScroll);
  }, [isLoading, wishlist]);

  useEffect(() => {
    if (car.versions && !wishlist) {
      const firstKey = Object.keys(car.versions)[0];
      setCurrentVersionKey(firstKey);
    }
  }, [currentModelKey, car, wishlist]);

  const handleTouchStart = (e: React.TouchEvent) => {
    if (wishlist) return; 
    touchStartX.current = e.targetTouches[0].clientX;
  };

  const handleTouchEnd = (e: React.TouchEvent) => {
    if (wishlist) return; 
    touchEndX.current = e.changedTouches[0].clientX;
    handleSwipe();
  };

  const handleSwipe = () => {
    const diff = touchStartX.current - touchEndX.current;
    const threshold = 50;
    const currentIndex = MODEL_KEYS.indexOf(currentModelKey);

    if (Math.abs(diff) > threshold) {
      if (diff > 0) {
        const nextIndex = (currentIndex + 1) % MODEL_KEYS.length;
        setCurrentModelKey(MODEL_KEYS[nextIndex]);
      } else {
        const prevIndex = (currentIndex - 1 + MODEL_KEYS.length) % MODEL_KEYS.length;
        setCurrentModelKey(MODEL_KEYS[prevIndex]);
      }
    }
  };

  const scrollToTop = () => {
    scrollContainerRef.current?.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleSaveWishlist = (config: WishlistConfig) => {
      setWishlist(config);
      setActiveSubView('none');
  };

  const handleRemoveWishlist = (e: React.MouseEvent) => {
      e.stopPropagation();
      if (window.confirm('确定要放弃当前的心愿单配置吗？')) {
          setWishlist(null);
      }
  };

  const handleOrderClick = () => {
      setIsOrdering(true);
      setTimeout(() => {
          setIsOrdering(false);
          setActiveSubView('order');
      }, 500); 
  };

  const renderTabs = (isSticky = false) => (
    <div className={`flex gap-3 overflow-x-auto no-scrollbar px-5 py-3 ${isSticky ? 'justify-start' : ''}`}>
      {MODEL_KEYS.map((key) => (
        <button
          key={key}
          onClick={() => {
            setCurrentModelKey(key);
            if(isSticky) scrollToTop();
          }}
          className={`px-6 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all duration-300 active:scale-95 ${
            currentModelKey === key
              ? `${BG_DARK} text-white shadow-lg shadow-black/10`
              : 'bg-white text-gray-500 border border-gray-100 hover:bg-gray-50'
          }`}
        >
          {CAR_DATA[key].name}
        </button>
      ))}
    </div>
  );

  if (isLoading) {
      return (
          <div className={`h-full w-full ${COLOR_BG} overflow-hidden`}>
              <div className="pt-[68px] px-5 pb-2">
                  <div className="w-32 h-8 bg-gray-200 rounded animate-shimmer" />
              </div>
              <div className="flex gap-3 px-5 mb-4 overflow-hidden">
                  {[1,2,3,4].map(i => <div key={i} className="w-20 h-9 rounded-full bg-gray-200 animate-shimmer shrink-0" />)}
              </div>
              <div className="mx-5 h-[480px] rounded-3xl bg-gray-200 animate-shimmer mb-4" />
              <div className="mx-5 h-20 rounded-2xl bg-gray-200 animate-shimmer mb-6" />
              <div className="px-5">
                  <div className="w-24 h-6 bg-gray-200 rounded animate-shimmer mb-4" />
                  <div className="h-[220px] rounded-3xl bg-gray-200 animate-shimmer" />
              </div>
          </div>
      );
  }

  return (
    <div className={`h-full w-full relative ${COLOR_BG} animate-in fade-in duration-500`}>
       {activeSubView === 'detail' && (
           <CarDetailView 
              car={car} 
              onBack={() => setActiveSubView('none')} 
              onOrder={handleOrderClick}
              onTestDrive={() => setActiveSubView('test-drive')}
           />
       )}
       {activeSubView === 'order' && (
           <CarOrderView 
              car={car} 
              onBack={() => setActiveSubView('none')} 
              onSaveWishlist={handleSaveWishlist}
              initialVersionId={currentVersionKey} 
           />
       )}
       {activeSubView === 'test-drive' && (
           <TestDriveView 
              car={car} 
              onBack={() => setActiveSubView('none')} 
           />
       )}
       {activeSubView === 'vr' && (
           <VRExperienceView 
              image="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png"
              carName={car.fullName}
              onClose={() => setActiveSubView('none')} 
           />
       )}
       {activeSubView === 'compare' && (
           <CarCompareView 
              initialModelId={currentModelKey}
              onBack={() => setActiveSubView('none')}
           />
       )}
       {activeSubView === 'finance' && (
           <FinanceCalculatorView
              car={car}
              onBack={() => setActiveSubView('none')}
           />
       )}
       {activeSubView === 'trade-in' && (
           <TradeInView
              onBack={() => setActiveSubView('none')}
           />
       )}
       {activeSubView === 'specs' && (
           <CarSpecsView
              car={car}
              onBack={() => setActiveSubView('none')}
           />
       )}
       {activeSubView === 'stores' && (
           <NearbyStoresView
              onBack={() => setActiveSubView('none')}
           />
       )}

      {!wishlist && (
          <div 
            className={`absolute top-0 left-0 right-0 z-40 bg-[#F5F7FA]/95 backdrop-blur-xl transition-all duration-300 pt-[54px] ${
              showStickyHeader ? 'translate-y-0 opacity-100' : '-translate-y-full opacity-0'
            }`}
          >
            <div className="pb-2">
              {renderTabs(true)}
            </div>
          </div>
      )}

      <div 
        ref={scrollContainerRef}
        className="h-full overflow-y-auto no-scrollbar pb-[120px]"
      >
        <header className="pt-[68px] px-5 pb-2">
          <h1 className={`text-[28px] font-bold tracking-tight ${COLOR_TEXT_MAIN} flex items-center gap-2`}>
              {wishlist ? '我的心愿单' : '选择车型'}
              {wishlist && <Heart size={24} className="fill-[#FF6B00] text-[#FF6B00] animate-pulse" />}
          </h1>
        </header>

        {!wishlist && (
            <div className="mb-4">
              {renderTabs()}
            </div>
        )}

        {wishlist ? (
            <div className="mx-5 relative group animate-in fade-in zoom-in-95 duration-500">
                <div className={`bg-white rounded-3xl overflow-hidden ${SHADOW_CARD} relative border border-white`}>
                    <button 
                        onClick={handleRemoveWishlist}
                        className="absolute top-4 right-4 z-20 w-8 h-8 bg-black/5 rounded-full flex items-center justify-center text-gray-400 hover:bg-red-50 hover:text-red-500 transition-colors"
                    >
                        <Trash2 size={16} />
                    </button>

                    <div className="h-[280px] relative bg-gradient-to-b from-[#F5F7FA] to-white flex items-center justify-center">
                        <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-white/80 to-transparent pointer-events-none" />
                        <img 
                            src={car.backgroundImage} 
                            className="w-[90%] object-contain drop-shadow-xl z-10"
                            style={{ 
                                filter: wishlist.colorId === 'black' ? 'brightness(0.7) contrast(1.2)' : 
                                        wishlist.colorId === 'red' ? 'sepia(0.3) hue-rotate(-50deg) saturate(1.5)' : 
                                        wishlist.colorId === 'green' ? 'sepia(0.2) hue-rotate(60deg) saturate(0.8)' : 'none'
                            }}
                            alt="Configured Car" 
                        />
                        <div className="absolute bottom-6 left-6">
                            <div className="inline-flex items-center gap-1.5 bg-[#111] text-white px-3 py-1 rounded-lg text-[10px] font-bold mb-2 shadow-lg">
                                <Sparkles size={11} fill="white" /> 已保存配置
                            </div>
                            <h2 className="text-[32px] font-bold text-[#111] leading-none mb-1">{car.name}</h2>
                            <div className="text-[14px] text-gray-500 font-medium">{wishlist.trimName}</div>
                        </div>
                    </div>

                    <div className="p-6 border-t border-gray-50">
                        <div className="grid grid-cols-3 gap-3 mb-6">
                            <div className="bg-[#F9FAFB] p-3 rounded-2xl">
                                <div className="text-[11px] text-gray-400 mb-1">外观颜色</div>
                                <div className="flex items-center gap-2">
                                    <div className="w-3 h-3 rounded-full border border-black/10" style={{backgroundColor: wishlist.colorHex}}></div>
                                    <span className="text-[12px] font-bold text-[#111] truncate">{wishlist.colorName}</span>
                                </div>
                            </div>
                            <div className="bg-[#F9FAFB] p-3 rounded-2xl">
                                <div className="text-[11px] text-gray-400 mb-1">内饰主题</div>
                                <div className="flex items-center gap-2">
                                    <div className="w-3 h-3 rounded-full border border-black/10" style={{backgroundColor: wishlist.interiorHex || '#333'}}></div>
                                    <span className="text-[12px] font-bold text-[#111] truncate">{wishlist.interiorName || '标准'}</span>
                                </div>
                            </div>
                            <div className="bg-[#F9FAFB] p-3 rounded-2xl">
                                <div className="text-[11px] text-gray-400 mb-1">轮毂样式</div>
                                <div className="text-[12px] font-bold text-[#111] truncate">{wishlist.wheelName}</div>
                            </div>
                        </div>

                        <div className="flex items-center justify-between">
                            <div>
                                <div className="text-[11px] text-gray-400">预估总价</div>
                                <div className={`text-[24px] font-bold ${COLOR_PRIMARY} font-oswald`}>
                                    ¥{wishlist.totalPrice.toLocaleString()}
                                </div>
                            </div>
                            <button 
                                onClick={handleOrderClick}
                                className="h-11 px-8 bg-[#111] text-white rounded-full font-bold text-[14px] shadow-lg active:scale-95 transition-transform flex items-center gap-2"
                            >
                                {isOrdering && <Loader2 size={14} className="animate-spin" />}
                                立即下单
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        ) : (
            <div 
              key={currentModelKey} 
              className={`relative mx-5 h-[480px] rounded-3xl overflow-hidden ${SHADOW_CARD} transition-all duration-500 group select-none cursor-grab active:cursor-grabbing bg-[#222] animate-in fade-in slide-in-from-right-4 duration-500 border border-white/5`}
              onTouchStart={handleTouchStart}
              onTouchEnd={handleTouchEnd}
            >
              {/* Layer 1: Background Image (Lowest Z) */}
              <div 
                className={`absolute inset-0 bg-cover bg-center transition-all duration-700 z-0 ${car.isPreview ? 'blur-[3px]' : ''}`}
                style={{ backgroundImage: `url(${car.backgroundImage})` }}
              />

              {/* Layer 2: Video (Above Image, Below Gradient) */}
              {car.heroVideo && (
                  <video
                    key={car.heroVideo}
                    ref={videoRef}
                    autoPlay
                    loop
                    muted
                    playsInline
                    className="absolute inset-0 w-full h-full object-cover z-10 pointer-events-none"
                    poster={car.backgroundImage}
                  >
                      <source src={car.heroVideo} type="video/mp4" />
                  </video>
              )}
              
              {/* Layer 3: Gradient Overlay (Above Video) */}
              <div className={`absolute inset-0 z-20 bg-gradient-to-b from-black/30 via-transparent to-black/70 pointer-events-none ${car.isPreview ? 'from-black/40 via-black/20 to-black/50' : ''}`} />

              {/* Layer 4: Content (Top Layer) */}
              <div className="relative z-30 h-full flex flex-col items-center pt-[60px] text-white">
                <h2 className="text-[42px] font-bold tracking-wider drop-shadow-md">
                  {!car.isPreview && <span className="font-bold mr-2">北京</span>}
                  {car.name}
                </h2>
                <p className="mt-2 text-xs tracking-[4px] uppercase opacity-90">{car.subtitle}</p>
                
                <button 
                  onClick={() => setActiveSubView('detail')}
                  className="mt-4 text-[11px] font-bold opacity-80 hover:opacity-100 flex items-center gap-1 transition-opacity border border-white/30 px-3.5 py-1.5 rounded-full backdrop-blur-md"
                >
                  了解详情 <ChevronRight size={14} />
                </button>

                {car.isPreview && (
                   <div className="absolute top-5 right-5 bg-gradient-to-br from-[#FF6B6B] to-[#FF8E53] text-white text-[10px] font-bold px-4 py-1.5 rounded-full shadow-lg border border-white/20">
                      预告
                   </div>
                )}

                <div className="mt-auto w-full px-6 pb-8 text-center">
                  <div className="mb-6 opacity-100 flex flex-col items-center">
                     <span className="text-[11px] text-white/80 mb-1">指导价</span>
                     <div className="flex items-baseline gap-1">
                         <span className="text-3xl font-bold font-oswald">{car.price}</span>
                         {car.priceUnit && <span className="text-sm font-medium">{car.priceUnit}</span>}
                     </div>
                  </div>
                  
                  <div className="flex gap-4">
                     <button 
                       onClick={() => setActiveSubView('test-drive')}
                       className="flex-1 py-3.5 rounded-full border border-white/40 bg-white/10 backdrop-blur-md text-[15px] font-bold hover:bg-white/20 active:scale-95 transition-all"
                     >
                       预约试驾
                     </button>
                     <button 
                       onClick={handleOrderClick}
                       className={`flex-1 py-3.5 rounded-full bg-white text-black text-[15px] font-bold shadow-lg shadow-black/20 active:scale-95 transition-all flex items-center justify-center gap-2`}
                     >
                       {isOrdering && <Loader2 size={16} className="animate-spin text-black" />}
                       立即定购
                     </button>
                  </div>
                </div>
              </div>
            </div>
        )}

        {!car.isPreview && (
          <div className="mx-5 mt-4 bg-orange-50 border border-orange-100 rounded-2xl p-4 text-orange-900 text-[13px] leading-relaxed relative overflow-hidden group animate-in fade-in duration-700 delay-100">
            <div className="relative z-10">
                <p>
                  12月31日24:00前定购可享限时权益，最高价值 <span className={`text-[#FF6B00] font-bold text-base font-oswald`}>{car.promoPrice}</span>。
                </p>
                <button className="mt-2 text-xs text-orange-400 flex items-center gap-1 font-bold group-active:opacity-70">
                  查看全部权益 <ChevronDown size={12} />
                </button>
            </div>
          </div>
        )}

        {!car.isPreview && (
          <section className="mt-6 px-5 animate-in fade-in duration-700 delay-150">
            <h3 className={`text-[20px] font-bold ${COLOR_TEXT_MAIN} mb-4`}>车型亮点</h3>
            <div 
              onClick={() => setActiveSubView('detail')}
              className={`w-full h-[220px] rounded-3xl bg-cover bg-center relative overflow-hidden ${SHADOW_CARD} group cursor-pointer border border-white`}
              style={{ backgroundImage: `url(${car.highlightImage})` }}
            >
               <div className="absolute inset-0 bg-black/20 group-active:bg-black/30 transition-colors" />
               <div className="absolute inset-0 flex items-center justify-center">
                    <div className="w-12 h-12 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center border border-white/40 shadow-lg">
                        <Play size={20} className="text-white fill-white ml-1" />
                    </div>
               </div>
               <div className="absolute bottom-0 left-0 right-0 p-5 bg-gradient-to-t from-black/80 to-transparent">
                  <div className="text-white text-[18px] font-bold tracking-wide">
                    {car.highlightText}
                  </div>
               </div>
            </div>
          </section>
        )}

        {car.isPreview && (
          <section className="mt-6 px-5 animate-in fade-in slide-in-from-bottom-4 duration-700">
             <div className={`text-[20px] font-bold ${COLOR_TEXT_MAIN} mb-4`}>发布预告</div>
             <div className={`${COLOR_SURFACE} rounded-3xl p-6 ${SHADOW_CARD} mb-4 border border-white`}>
                <div className="bg-orange-50 rounded-2xl p-4 mb-5 border border-orange-100">
                   <div className="text-[13px] text-orange-900 leading-relaxed font-medium">
                     预计 <span className="text-[#FF6B00] font-bold">{car.releaseDate}</span> 正式发布
                   </div>
                </div>

                <div className={`text-xl font-bold ${COLOR_TEXT_MAIN} mb-3`}>{car.fullName}</div>
                <div className="text-sm text-gray-500 leading-relaxed mb-6 text-justify">
                  北京汽车全新力作，融合硬派越野基因与皮卡实用性，打造全能型越野皮卡新标杆。非承载式车身、强劲动力、专业越野配置，满足工作与越野双重需求。
                </div>

                <div className="bg-[#F7F8FA] rounded-2xl p-5 mb-5 border border-gray-100">
                   <div className="text-[12px] text-gray-400 text-center mb-4 tracking-widest uppercase font-bold">COUNTDOWN</div>
                   <div className="flex justify-center gap-3">
                      {[car.countdown?.days, car.countdown?.hours, car.countdown?.minutes].map((val, idx) => (
                        <div key={idx} className="text-center bg-white rounded-xl p-3 min-w-[70px] shadow-sm border border-gray-100">
                          <div className={`text-[32px] font-bold leading-none ${COLOR_TEXT_MAIN} font-oswald`}>{val}</div>
                          <div className="text-[10px] text-gray-400 mt-1 font-bold">
                            {['DAYS', 'HOURS', 'MINS'][idx]}
                          </div>
                        </div>
                      ))}
                   </div>
                </div>

                <button className={`w-full py-4 ${BG_DARK} text-white rounded-full text-[15px] font-bold text-center active:scale-95 transition-all shadow-lg shadow-black/10`}>
                  预约发布通知
                </button>
             </div>

             <div className={`text-[20px] font-bold ${COLOR_TEXT_MAIN} mt-8 mb-4`}>核心亮点</div>
             <div className="grid grid-cols-2 gap-3">
               {car.previewFeatures?.map((feature, idx) => (
                 <div key={idx} className={`${COLOR_SURFACE} p-5 rounded-2xl ${SHADOW_CARD} border border-white`}>
                    <div className="w-10 h-10 bg-[#F5F7FA] rounded-full flex items-center justify-center text-[#1A1A1A] mb-3 border border-gray-100">
                       {feature.icon === 'mountain' && <Mountain size={20} />}
                       {feature.icon === 'truck' && <Truck size={20} />}
                       {feature.icon === 'settings' && <Settings size={20} />}
                       {feature.icon === 'shield' && <Shield size={20} />}
                    </div>
                    <div className={`text-[15px] font-bold ${COLOR_TEXT_MAIN} mb-1.5`}>{feature.title}</div>
                    <div className="text-[12px] text-gray-400 leading-snug font-medium">{feature.desc}</div>
                 </div>
               ))}
             </div>
          </section>
        )}

        {!car.isPreview && version && !wishlist && (
          <section className="mt-8 px-5 animate-in fade-in duration-700 delay-200">
             <div className="flex justify-between items-center mb-4">
               <h3 className={`text-[20px] font-bold ${COLOR_TEXT_MAIN}`}>在售车型</h3>
               <button 
                 onClick={() => setActiveSubView('compare')}
                 className="text-[12px] text-gray-400 flex items-center gap-1 font-bold active:text-[#FF6B00] transition-colors"
               >
                 车型对比 <ChevronRight size={14} />
               </button>
             </div>

             <div className={`${COLOR_SURFACE} rounded-3xl p-5 ${SHADOW_CARD} border border-white`}>
                <div className="flex gap-4 border-b border-gray-100 mb-5 overflow-x-auto no-scrollbar pb-1">
                  {car.versions && Object.keys(car.versions).map((vKey) => (
                    <button 
                      key={vKey}
                      onClick={() => setCurrentVersionKey(vKey)}
                      className={`pb-3 text-[15px] font-bold whitespace-nowrap transition-all relative ${
                        currentVersionKey === vKey ? `${COLOR_TEXT_MAIN}` : 'text-gray-400 hover:text-gray-600'
                      }`}
                    >
                      {car.versions![vKey].name}
                      {currentVersionKey === vKey && (
                        <span className={`absolute bottom-0 left-1/2 -translate-x-1/2 w-4 h-1 ${BG_DARK} rounded-full`} />
                      )}
                    </button>
                  ))}
                </div>

                <div className="animate-in fade-in duration-300">
                   <div 
                     className="inline-block px-2.5 py-1 rounded-lg text-[10px] text-white mb-4 font-bold tracking-wide shadow-sm"
                     style={{ background: version.badgeColor || 'linear-gradient(135deg, #111 0%, #333 100%)' }}
                   >
                     {version.badge}
                   </div>

                   <div className="mb-6 grid grid-cols-1 gap-2.5">
                      {version.features.map((feature, i) => (
                        <div key={i} className="flex items-start text-[13px] text-gray-600 leading-relaxed font-medium">
                          <span className={`w-1.5 h-1.5 rounded-full ${BG_DARK} mt-1.5 mr-2.5 shrink-0 opacity-40`}></span>
                          {feature}
                        </div>
                      ))}
                   </div>

                   <div className="flex justify-between items-center pt-5 border-t border-gray-50">
                      <div className="flex flex-col">
                        <span className="text-[10px] text-gray-400 mb-0.5 font-bold">参考价</span>
                        <div className={`flex items-baseline gap-0.5 ${COLOR_PRIMARY} font-oswald`}>
                            <span className="text-sm font-bold">¥</span>
                            <span className="text-2xl font-bold">{version.price}</span>
                        </div>
                      </div>
                      <button 
                        onClick={handleOrderClick}
                        className={`${BG_DARK} text-white px-6 py-2.5 rounded-full text-[13px] font-bold active:scale-95 transition-transform shadow-md flex items-center gap-2`}
                      >
                        {isOrdering && <Loader2 size={14} className="animate-spin" />}
                        选择配置
                      </button>
                   </div>
                </div>
             </div>
          </section>
        )}

        {!car.isPreview && (
          <section className="mt-8 px-5 animate-in fade-in duration-700 delay-300">
            <h3 className={`text-[20px] font-bold ${COLOR_TEXT_MAIN} mb-4`}>购车工具</h3>
            <div className={`${COLOR_SURFACE} rounded-3xl p-6 ${SHADOW_CARD} mb-4 border border-white`}>
               <div className="grid grid-cols-4 gap-2">
                  <ToolItem icon={List} label="参数配置" onClick={() => setActiveSubView('specs')} />
                  <ToolItem icon={Calculator} label="金融计算" onClick={() => setActiveSubView('finance')} />
                  <ToolItem icon={RefreshCw} label="置换估值" onClick={() => setActiveSubView('trade-in')} />
                  <ToolItem icon={BookOpen} label="购车指南" onClick={() => {}} />
               </div>
            </div>

            <div 
              onClick={onChatOpen}
              className={`${COLOR_SURFACE} rounded-2xl p-4 flex items-center justify-between cursor-pointer active:bg-gray-50 transition-colors ${SHADOW_CARD} border border-white`}
            >
              <div className="flex items-center gap-4">
                 <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center overflow-hidden border border-gray-100">
                    <img 
                      src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=100&auto=format&fit=crop&crop=faces" 
                      alt="客服专家" 
                      className="w-full h-full object-cover"
                    />
                 </div>
                 <div>
                     <div className={`text-[15px] font-bold ${COLOR_TEXT_MAIN} mb-0.5`}>在线咨询</div>
                     <div className="text-[11px] text-gray-400 font-medium">专业产品专家为您解答</div>
                 </div>
              </div>
              <div className="w-8 h-8 rounded-full bg-[#F5F7FA] flex items-center justify-center text-gray-400">
                  <ChevronRight size={16} />
              </div>
            </div>
          </section>
        )}

        {!car.isPreview && (
          <section className="mt-8 px-5 animate-in fade-in duration-700 delay-300">
            <div className={`text-[20px] font-bold ${COLOR_TEXT_MAIN} mb-4`}>在线看车</div>
            <div 
               onClick={() => setActiveSubView('vr')}
               className={`w-full h-[220px] rounded-3xl bg-cover bg-center relative overflow-hidden ${SHADOW_CARD} group cursor-pointer active:scale-[0.98] transition-transform border border-white`}
               style={{ backgroundImage: 'url(https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png)' }}
            >
                <div className="absolute inset-0 bg-black/10 group-hover:bg-black/20 transition-colors" />
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-14 h-14 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center border border-white/40 shadow-lg">
                    <span className="text-white text-[11px] font-bold uppercase tracking-wider">VR</span>
                </div>
                <div className="absolute bottom-0 left-0 right-0 p-5">
                    <div className="text-white text-[16px] font-bold drop-shadow-md">360° 全景看车</div>
                </div>
            </div>
          </section>
        )}

        {!car.isPreview && car.store && (
          <section className="mt-8 px-5 mb-8 animate-in fade-in duration-700 delay-300">
             <div className="flex justify-between items-center mb-4">
               <h3 className={`text-[20px] font-bold ${COLOR_TEXT_MAIN}`}>直营门店</h3>
               <button 
                 onClick={() => setActiveSubView('stores')}
                 className="text-[12px] text-gray-400 flex items-center gap-1 font-bold active:text-[#FF6B00] transition-colors"
               >
                 全部网点 <ChevronRight size={14} />
               </button>
             </div>
             
             <div className={`${COLOR_SURFACE} rounded-3xl overflow-hidden ${SHADOW_CARD} border border-white`}>
                <div 
                  className="h-[180px] w-full bg-cover bg-center relative"
                  style={{ backgroundImage: `url(${car.store.image})` }}
                >
                    <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-md px-3 py-1 rounded-lg text-[10px] font-bold text-[#111] shadow-sm">
                        最近门店
                    </div>
                </div>
                <div className="p-5">
                   <h4 className={`text-[16px] font-bold ${COLOR_TEXT_MAIN} mb-2`}>{car.store.name}</h4>
                   <p className="text-[13px] text-gray-500 mb-4 leading-relaxed font-medium">{car.store.address}</p>
                   
                   <div className="flex items-center justify-between">
                      <div className="flex items-center gap-1 text-[13px] text-[#FF6B00] font-bold bg-orange-50 px-2.5 py-1 rounded-lg">
                          <Navigation size={12} />
                          {car.store.distance}
                      </div>
                      <div className="flex gap-3">
                         <button className="w-10 h-10 rounded-full bg-[#F5F7FA] flex items-center justify-center text-[#333] active:bg-[#e0e0e0] transition-colors">
                            <Navigation size={18} />
                         </button>
                         <button 
                           onClick={() => setActiveSubView('test-drive')}
                           className={`px-5 py-2.5 rounded-full ${BG_DARK} text-[13px] font-bold text-white active:scale-95 transition-transform shadow-md shadow-black/10`}
                         >
                            预约试驾
                         </button>
                      </div>
                   </div>
                </div>
             </div>
          </section>
        )}
      </div>

      {!car.isPreview && !wishlist && (
        <div 
          className={`absolute bottom-[80px] left-0 right-0 z-40 bg-white/90 backdrop-blur-xl px-5 py-3 shadow-[0_-4px_20px_rgba(0,0,0,0.08)] transition-all duration-300 transform ${
            showFloatingBar ? 'translate-y-0 opacity-100' : 'translate-y-full opacity-0 pointer-events-none'
          }`}
        >
           <div className="flex items-center justify-between">
              <div className="flex flex-col gap-0.5">
                 <span className="text-[10px] text-gray-400 font-bold">最高可享权益</span>
                 <span className={`text-xl font-bold ${COLOR_PRIMARY} font-oswald`}>{car.promoPrice}</span>
              </div>
              <div className="flex gap-3">
                 <button 
                   onClick={() => setActiveSubView('detail')}
                   className={`px-6 py-3 rounded-full bg-white border border-gray-200 text-sm font-bold ${COLOR_TEXT_MAIN} active:bg-gray-50 transition-colors`}
                 >
                   参数配置
                 </button>
                 <button 
                   onClick={handleOrderClick}
                   className={`px-6 py-3 rounded-full ${BG_DARK} text-white text-sm font-bold shadow-lg shadow-black/10 active:scale-95 transition-transform flex items-center gap-2`}
                 >
                   {isOrdering && <Loader2 size={14} className="animate-spin" />}
                   立即定购
                 </button>
              </div>
           </div>
        </div>
      )}
    </div>
  );
};

const ToolItem: React.FC<{ icon: any, label: string, onClick?: () => void }> = ({ icon: Icon, label, onClick }) => (
    <div 
      onClick={onClick}
      className="flex flex-col items-center gap-2 cursor-pointer active:scale-95 transition-transform p-2 rounded-2xl hover:bg-gray-50"
    >
        <div className="w-12 h-12 bg-[#F5F7FA] rounded-full flex items-center justify-center text-[#333] border border-white">
            <Icon size={22} strokeWidth={1.5} />
        </div>
        <span className="text-[12px] font-bold text-[#333]">{label}</span>
    </div>
);

export default CarBuyingView;
