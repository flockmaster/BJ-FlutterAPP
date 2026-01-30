
import React, { useState, useEffect, useRef } from 'react';
import { 
  Search, 
  ShoppingCart, 
  ArrowRight, 
  Trash2, 
  X, 
  Flame, 
  Ticket, 
  Coins, 
  Heart, 
  ChevronRight, 
  Gift 
} from 'lucide-react';
import { STORE_CATEGORIES, STORE_TRENDING_SEARCHES } from '../data';
import { StoreProduct, StoreSection, StoreFeature } from '../types';
import StoreOwnerExclusiveView from './StoreOwnerExclusiveView'; 
import StoreProductDetailView from './StoreProductDetailView'; 
import StoreCheckoutView from './StoreCheckoutView'; 
import StoreCartView, { CartItem } from './StoreCartView';
import OrderDetailView from './OrderDetailView'; 
import Skeleton from './ui/Skeleton';
import { IconButton } from './ui/Button';

const COLOR_BG = 'bg-[#F5F7FA]';
const COLOR_TEXT_MAIN = 'text-[#111827]';
const SHADOW_CARD = 'shadow-[0_4px_24px_rgba(0,0,0,0.03)]';
const COLOR_PRIMARY = 'text-[#FF6B00]';

const StoreView: React.FC = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [activeCategory, setActiveCategory] = useState(STORE_CATEGORIES[0].id);
  const scrollRef = useRef<HTMLDivElement>(null);
  const [isScrolled, setIsScrolled] = useState(false);
  
  const [renderSearch, setRenderSearch] = useState(false); 
  const [searchVisible, setSearchVisible] = useState(false);
  const [showOwnerExclusive, setShowOwnerExclusive] = useState(false);
  const [viewingProduct, setViewingProduct] = useState<StoreProduct | null>(null);
  const [showCart, setShowCart] = useState(false);
  const [checkoutItems, setCheckoutItems] = useState<any[] | null>(null);
  const [viewingOrder, setViewingOrder] = useState<any>(null); 
  const [cartItems, setCartItems] = useState<CartItem[]>([]);
  const [searchHistory, setSearchHistory] = useState<string[]>(['BJ60脚垫', '露营灯']);
  const [favorites, setFavorites] = useState<string[]>(['h1', 'w1']); 

  const currentCatData = STORE_CATEGORIES.find(c => c.id === activeCategory) || STORE_CATEGORIES[0];

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 1200);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        setIsScrolled(scrollRef.current.scrollTop > 50);
      }
    };
    const element = scrollRef.current;
    if (element) {
        element.addEventListener('scroll', handleScroll);
        return () => element.removeEventListener('scroll', handleScroll);
    }
  }, [isLoading]);

  const handleAddToCart = (item: any) => {
      const newItem: CartItem = { ...item, cartId: `cart_${Date.now()}`, selected: true };
      setCartItems(prev => [...prev, newItem]);
  };

  if (isLoading) {
      return (
          <div className={`relative h-full w-full ${COLOR_BG}`}>
             <div className="pt-[54px] px-5 pb-3">
                 <Skeleton height="44px" className="w-full rounded-full" />
                 <div className="flex gap-8 mt-5 px-2">
                     {[1,2,3,4,5].map(i => <Skeleton key={i} width="48px" height="18px" />)}
                 </div>
             </div>
             <div className="px-5 pt-4 space-y-6">
                 <Skeleton height="220px" className="w-full rounded-[24px]" />
                 <div className="grid grid-cols-2 gap-3">
                      <Skeleton height="240px" className="w-full rounded-2xl" />
                      <Skeleton height="240px" className="w-full rounded-2xl" />
                 </div>
             </div>
          </div>
      );
  }

  return (
    <div className={`relative h-full w-full ${COLOR_BG} animate-in fade-in duration-500`}>
      {/* Modals & Sub-views omitted for brevity, logic remains identical to previous version */}
      {renderSearch && <StoreSearchView isVisible={searchVisible} history={searchHistory} onClose={() => { setSearchVisible(false); setTimeout(() => setRenderSearch(false), 300); }} onSearch={(term) => { if(!searchHistory.includes(term)) setSearchHistory(h => [term, ...h]); setSearchVisible(false); }} onClearHistory={() => setSearchHistory([])} />}
      {showOwnerExclusive && <StoreOwnerExclusiveView onBack={() => setShowOwnerExclusive(false)} />}
      {viewingProduct && <StoreProductDetailView product={viewingProduct} cartCount={cartItems.length} isInitiallyFavorited={favorites.includes(viewingProduct.id)} onBack={() => setViewingProduct(null)} onAddToCart={handleAddToCart} onGoToCart={() => { setViewingProduct(null); setShowCart(true); }} onCheckout={(items) => { setViewingProduct(null); setCheckoutItems(items); }} onToggleFavorite={(id) => setFavorites(prev => prev.includes(id) ? prev.filter(fid => fid !== id) : [...prev, id])} />}
      {showCart && <StoreCartView items={cartItems} onBack={() => setShowCart(false)} onUpdateItems={setCartItems} onCheckout={(items) => { setShowCart(false); const formattedItems = items.map(item => ({ product: item, spec: item.selectedSpec, quantity: item.quantity })); setCheckoutItems(formattedItems); }} />}
      {checkoutItems && <StoreCheckoutView items={checkoutItems} onBack={() => setCheckoutItems(null)} onViewOrder={(id, ex) => { setCheckoutItems(null); setViewingOrder({ id, ...ex }); }} />}
      {viewingOrder && <OrderDetailView order={viewingOrder} onBack={() => setViewingOrder(null)} />}

      {/* Immersive Header */}
      <div className={`absolute top-0 left-0 right-0 z-50 pt-[54px] pb-2 transition-all duration-300 ${isScrolled ? 'bg-[#F5F7FA]/95 backdrop-blur-xl border-b border-gray-100/50' : 'bg-transparent'}`}>
        <div className="px-5 mb-3 flex items-center gap-3">
            <div className={`flex-1 h-11 rounded-full flex items-center px-4 gap-2 transition-all duration-300 cursor-text active:scale-[0.98] ${isScrolled ? 'bg-white shadow-sm border border-gray-100' : 'bg-black/20 backdrop-blur-md border border-white/10'}`} onClick={() => { setRenderSearch(true); setTimeout(() => setSearchVisible(true), 10); }}>
               <Search size={18} className={isScrolled ? 'text-gray-400' : 'text-white/60'} />
               <span className={`text-[14px] font-medium ${isScrolled ? 'text-gray-400' : 'text-white/60'}`}>搜索商品、改装件...</span>
            </div>
            <div className="relative">
                <button onClick={() => setShowCart(true)} className={`w-11 h-11 rounded-full flex items-center justify-center transition-all duration-300 active:scale-90 ${isScrolled ? 'bg-white shadow-sm border border-gray-100 text-[#111]' : 'bg-black/20 backdrop-blur-md border border-white/10 text-white'}`}>
                    <ShoppingCart size={20} />
                </button>
                {cartItems.length > 0 && <span className="absolute -top-0.5 -right-0.5 w-4 h-4 bg-[#FF6B00] text-white text-[9px] font-bold rounded-full flex items-center justify-center border-2 border-white animate-in zoom-in">{cartItems.length}</span>}
            </div>
         </div>
         <div className="flex overflow-x-auto no-scrollbar gap-8 px-6 pb-2">
            {STORE_CATEGORIES.map(cat => {
              const isActive = activeCategory === cat.id;
              return (
                <button key={cat.id} onClick={() => setActiveCategory(cat.id)} className={`pb-2 text-[16px] font-bold whitespace-nowrap relative transition-all duration-300 flex flex-col items-center ${isScrolled ? (isActive ? `${COLOR_TEXT_MAIN} scale-105` : 'text-gray-400') : (isActive ? 'text-white scale-105' : 'text-white/60')}`}>
                  {cat.name}
                  <div className={`h-1 rounded-full mt-1.5 transition-all duration-300 ${isActive ? (isScrolled ? 'w-4 bg-[#111]' : 'w-4 bg-white') : 'w-0 bg-transparent'}`} />
                </button>
              );
            })}
         </div>
      </div>

      <div ref={scrollRef} className="absolute inset-0 overflow-y-auto no-scrollbar z-10">
         <HeroCarousel slides={currentCatData.slides} />
         <div className={`${COLOR_BG} relative z-20 pb-[120px] pt-4`}>
            {currentCatData.features && <FeatureGrid features={currentCatData.features} onItemClick={(id) => id === 'owner' && setShowOwnerExclusive(true)} />}
            {currentCatData.hotProducts && <HotSellers products={currentCatData.hotProducts} favorites={favorites} onToggleFav={(e,id)=>{e.stopPropagation();setFavorites(prev=>prev.includes(id)?prev.filter(f=>f!==id):[...prev,id])}} onProductClick={setViewingProduct} />}
            {currentCatData.sections?.map(section => <ThemeSection key={section.id} section={section} favorites={favorites} onToggleFav={(e,id)=>{e.stopPropagation();setFavorites(prev=>prev.includes(id)?prev.filter(f=>f!==id):[...prev,id])}} onProductClick={setViewingProduct} />)}
         </div>
      </div>
    </div>
  );
};

// Sub-components with precision styling updates
const FeatureGrid: React.FC<{ features: StoreFeature[], onItemClick: (id: string) => void }> = ({ features, onItemClick }) => {
    const largeFeature = features.find(f => f.type === 'large') || features[0];
    const smallFeatures = features.filter(f => f !== largeFeature).slice(0, 2);
    return (
        <div className="grid grid-cols-2 gap-3 px-5 mb-8">
             <div onClick={() => onItemClick(largeFeature.id)} className={`row-span-2 relative h-[240px] rounded-[28px] overflow-hidden group ${SHADOW_CARD} bg-white cursor-pointer active:scale-[0.98] transition-transform border border-white`}>
                 <img src={largeFeature.image} className="w-full h-full object-cover transition-transform duration-1000 group-active:scale-105" />
                 <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent p-6 flex flex-col justify-end">
                     <div className="text-white font-bold text-[20px] mb-1 leading-tight">{largeFeature.title}</div>
                     <div className="text-white/70 text-[11px] font-bold uppercase tracking-widest bg-white/10 backdrop-blur-md w-fit px-2.5 py-1 rounded-lg border border-white/10">{largeFeature.subtitle}</div>
                 </div>
             </div>
             <div className="flex flex-col gap-3 h-[240px]">
                 {smallFeatures.map(feature => (
                     <div key={feature.id} onClick={() => onItemClick(feature.id)} className={`flex-1 relative rounded-[20px] overflow-hidden group ${SHADOW_CARD} bg-white cursor-pointer active:scale-[0.98] transition-transform border border-white`}>
                         <img src={feature.image} className="w-full h-full object-cover transition-transform duration-1000 group-active:scale-105" />
                         <div className="absolute inset-0 bg-gradient-to-l from-black/60 to-transparent p-4 flex flex-col justify-center items-end text-right">
                             <div className="text-white font-bold text-[16px] leading-tight mb-0.5">{feature.title}</div>
                             <div className="text-white/60 text-[10px] font-bold">{feature.subtitle}</div>
                         </div>
                     </div>
                 ))}
             </div>
        </div>
    );
};

const HotSellers: React.FC<{ products: StoreProduct[], favorites: string[], onToggleFav: (e:any, id:string)=>void, onProductClick: (p: StoreProduct) => void }> = ({ products, favorites, onToggleFav, onProductClick }) => (
    <div className="mb-10">
        <div className="flex justify-between items-center px-6 mb-5">
            <h3 className={`text-[18px] font-bold ${COLOR_TEXT_MAIN}`}>官方严选榜单</h3>
            <div className="text-[11px] text-[#6B7280] font-bold flex items-center gap-1 uppercase tracking-widest">Premium Select <ArrowRight size={14} className="text-[#FF6B00]" /></div>
        </div>
        <div className="flex overflow-x-auto no-scrollbar px-5 gap-4 pb-4">
            {products.map((p, index) => (
                <div key={p.id} onClick={() => onProductClick(p)} className="w-[140px] shrink-0 flex flex-col gap-2 group cursor-pointer active:scale-95 transition-transform">
                    <div className={`w-full aspect-square bg-white rounded-2xl overflow-hidden relative shadow-[0_4px_20px_rgba(0,0,0,0.02)] border border-gray-50`}>
                         <div className={`absolute top-0 left-0 w-7 h-7 flex items-center justify-center text-white text-[12px] font-oswald font-bold rounded-br-2xl z-10 ${index < 3 ? 'bg-[#111]' : 'bg-gray-300'}`}>{index + 1}</div>
                         <button onClick={(e) => onToggleFav(e, p.id)} className="absolute top-2.5 right-2.5 z-10 w-8 h-8 rounded-full bg-white/90 backdrop-blur-md flex items-center justify-center shadow-sm active:scale-125 transition-transform"><Heart size={14} className={favorites.includes(p.id) ? 'fill-[#FF4D4F] text-[#FF4D4F]' : 'text-gray-300'} /></button>
                         <img src={p.image} className="w-full h-full object-cover transition-transform duration-700 group-active:scale-110" />
                    </div>
                    <div className="px-1">
                        <div className="text-[13px] font-bold text-[#111] line-clamp-1 mb-1 leading-snug">{p.title}</div>
                        <div className="flex items-baseline gap-1"><span className="text-[11px] font-bold text-[#FF6B00] font-oswald">¥</span><span className="text-[18px] font-bold text-[#FF6B00] font-oswald tracking-tight">{p.price}</span></div>
                    </div>
                </div>
            ))}
        </div>
    </div>
);

const ThemeSection: React.FC<{ section: StoreSection, favorites: string[], onToggleFav: (e:any, id:string)=>void, onProductClick: (p: StoreProduct) => void }> = ({ section, favorites, onToggleFav, onProductClick }) => (
    <div className="mb-10 px-5">
         <div onClick={() => {}} className={`w-full h-[140px] relative overflow-hidden rounded-[20px] mb-5 ${SHADOW_CARD} group cursor-pointer active:scale-[0.99] transition-transform border border-white`}>
             <img src={section.bannerImage} className="w-full h-full object-cover transition-transform duration-1000 group-active:scale-105" />
             <div className="absolute inset-0 bg-gradient-to-r from-[#111827]/80 via-[#111827]/40 to-transparent flex flex-col justify-center px-6">
                <div className="text-[10px] text-white/90 font-bold tracking-[0.3em] mb-2 bg-[#FF6B00] w-fit px-2.5 py-1 rounded-md uppercase shadow-lg">New Arrival</div>
                <div className="text-xl font-bold text-white mb-1 leading-tight">{section.title.split('|')[0]}</div>
                <div className="text-[12px] text-white/70 font-medium">{section.title.split('|')[1]}</div>
             </div>
         </div>
         <div className="grid grid-cols-2 gap-4">
             {section.products.map(p => (
                 <div key={p.id} onClick={() => onProductClick(p)} className={`bg-white rounded-[24px] overflow-hidden ${SHADOW_CARD} group cursor-pointer active:scale-[0.98] transition-transform border border-white`}>
                     <div className="aspect-square relative overflow-hidden bg-gray-50">
                         <button onClick={(e) => onToggleFav(e, p.id)} className="absolute top-3.5 right-3.5 z-10 w-9 h-9 rounded-full bg-white/90 backdrop-blur-md flex items-center justify-center shadow-md active:scale-125 transition-transform"><Heart size={16} className={favorites.includes(p.id) ? 'fill-[#FF4D4F] text-[#FF4D4F]' : 'text-gray-300'} /></button>
                         <img src={p.image} className="w-full h-full object-cover transition-transform duration-1000 group-active:scale-110" />
                         {p.tags && p.tags[0] && <div className="absolute bottom-2 left-2 bg-[#111] text-white text-[9px] font-bold px-2 py-0.5 rounded-md shadow-lg">{p.tags[0]}</div>}
                     </div>
                     <div className="p-4 flex flex-col justify-between h-[100px]">
                         <div className="text-[14px] font-bold text-[#111] line-clamp-2 leading-snug mb-2">{p.title}</div>
                         <div className="flex items-end justify-between">
                             <div className="flex items-baseline gap-0.5 text-[#FF6B00] font-oswald"><span className="text-[12px] font-bold">¥</span><span className="text-[20px] font-bold leading-none tracking-tight">{p.price}</span></div>
                             <div className="w-8 h-8 rounded-full bg-[#111] flex items-center justify-center text-white active:scale-90 transition-transform shadow-lg shadow-black/10"><ShoppingCart size={14} /></div>
                         </div>
                     </div>
                 </div>
             ))}
         </div>
    </div>
);

const HeroCarousel: React.FC<{ slides: any[] }> = ({ slides }) => {
    const [currentSlide, setCurrentSlide] = useState(0);
    useEffect(() => {
      const timer = setInterval(() => setCurrentSlide(prev => (prev + 1) % slides.length), 6000);
      return () => clearInterval(timer);
    }, [slides.length]);
    return (
      <div className="relative h-[55vh] w-full overflow-hidden bg-[#111]">
        {slides.map((slide, index) => (
           <div key={index} className={`absolute inset-0 transition-opacity duration-1500 ease-in-out ${index === currentSlide ? 'opacity-100' : 'opacity-0'}`}>
              <img src={slide.image} className="w-full h-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-transparent to-[#F5F7FA]" />
              <div className="absolute bottom-24 left-6 right-6 z-20 flex flex-col">
                  <div className="text-[11px] text-white/60 font-bold tracking-[0.4em] uppercase mb-2">Winter Collection</div>
                  <h2 className="text-[32px] font-bold text-white mb-3 leading-tight drop-shadow-xl">{slide.title}</h2>
                  <div className="flex items-center justify-between">
                      <p className="text-[14px] text-white/80 font-medium">{slide.subtitle}</p>
                      <button className="h-11 px-6 rounded-full border border-white/40 bg-white/10 backdrop-blur-md text-white text-[13px] font-bold active:scale-95 transition-all flex items-center gap-2 hover:bg-white/20">立即探索 <ArrowRight size={16} /></button>
                  </div>
              </div>
           </div>
        ))}
        <div className="absolute bottom-10 left-6 flex gap-2 z-20">
           {slides.map((_, idx) => (
              <div key={idx} className={`h-1.5 rounded-full transition-all duration-500 ${idx === currentSlide ? `w-10 bg-white` : 'w-2 bg-white/30'}`} />
           ))}
        </div>
      </div>
    );
};

const StoreSearchView: React.FC<{ isVisible: boolean, history: string[], onClose: () => void, onSearch: (t: string) => void, onClearHistory: () => void }> = ({ isVisible, history, onClose, onSearch, onClearHistory }) => {
  const [inputValue, setInputValue] = useState('');
  return (
    <div className={`absolute inset-0 z-[60] ${COLOR_BG} flex flex-col ${isVisible ? 'animate-slide-in-bottom' : 'animate-slide-out-bottom'}`}>
       <div className="pt-[54px] px-5 pb-4 flex items-center gap-3 bg-white border-b border-gray-100 shadow-sm shrink-0">
          <div className="flex-1 h-11 bg-[#F5F7FA] rounded-full flex items-center px-4 gap-3 border border-transparent focus-within:border-[#111] focus-within:bg-white transition-all">
             <Search size={18} className="text-gray-400" />
             <input autoFocus type="text" value={inputValue} onChange={(e) => setInputValue(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && inputValue.trim() && onSearch(inputValue.trim())} placeholder="搜索商品、改装件" className="flex-1 bg-transparent text-[15px] text-[#111] font-medium focus:outline-none" />
          </div>
          <button onClick={onClose} className="text-[15px] font-bold text-[#111] px-2 active:opacity-60">取消</button>
       </div>
       <div className="flex-1 overflow-y-auto px-6 py-8">
          {history.length > 0 && (
            <div className="mb-10">
               <div className="flex justify-between items-center mb-5"><h3 className="text-[17px] font-bold text-[#111]">搜索历史</h3><button onClick={onClearHistory} className="text-gray-300 p-1"><Trash2 size={18} /></button></div>
               <div className="flex flex-wrap gap-2.5">{history.map((term, idx) => (<button key={idx} onClick={() => onSearch(term)} className="px-5 py-2.5 bg-white border border-gray-100 text-[13px] text-gray-600 font-bold rounded-2xl active:bg-gray-50 shadow-sm">{term}</button>))}</div>
            </div>
          )}
          <div><h3 className="text-[17px] font-bold text-[#111] mb-5">热门搜索</h3><div className="flex flex-wrap gap-2.5">{STORE_TRENDING_SEARCHES.map((term, idx) => (<button key={idx} onClick={() => onSearch(term)} className={`px-5 py-2.5 text-[13px] font-bold rounded-2xl shadow-sm border transition-all ${idx < 3 ? 'bg-[#111] text-white border-[#111]' : 'bg-white text-gray-500 border-gray-100 hover:border-gray-300'}`}>{term}</button>))}</div></div>
       </div>
    </div>
  );
};

export default StoreView;
