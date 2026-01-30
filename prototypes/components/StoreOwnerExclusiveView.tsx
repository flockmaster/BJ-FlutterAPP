
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Filter, 
  Car, 
  Tag, 
  ShoppingCart, 
  Star, 
  ChevronDown,
  ShieldCheck,
  Zap
} from 'lucide-react';

interface StoreOwnerExclusiveViewProps {
  onBack: () => void;
}

const PRODUCTS = [
    { id: 'ex1', title: 'BJ40 PLUS 专用TPE脚垫 (全套)', price: '298', originalPrice: '498', image: 'https://images.unsplash.com/photo-1584813539806-2538b8d918c6?q=80&w=400&auto=format&fit=crop', category: '内饰', tag: '专车专用' },
    { id: 'ex2', title: 'BJ40 碳纤维风格内饰贴片套装', price: '128', originalPrice: '198', image: 'https://images.unsplash.com/photo-1600712242805-5f786716d566?q=80&w=400&auto=format&fit=crop', category: '内饰', tag: '无损安装' },
    { id: 'ex3', title: 'BJ40 竞技款前杠 (含射灯支架)', price: '2680', originalPrice: '3280', image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop', category: '改装', tag: '硬派必备' },
    { id: 'ex4', title: 'BJ40 后备箱魔盒收纳系统', price: '1580', originalPrice: '1880', image: 'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?q=80&w=400&auto=format&fit=crop', category: '收纳', tag: '空间扩容' },
    { id: 'ex5', title: 'BJ40 专用手机支架 (重力感应)', price: '68', originalPrice: '98', image: 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?q=80&w=400&auto=format&fit=crop', category: '内饰', tag: '稳固防抖' },
    { id: 'ex6', title: 'BJ40 侧窗磁吸遮阳帘', price: '128', originalPrice: '168', image: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=400&auto=format&fit=crop', category: '内饰', tag: '私密隔热' },
];

const CATEGORIES = ['全部', '内饰', '改装', '收纳', '保养'];

const StoreOwnerExclusiveView: React.FC<StoreOwnerExclusiveViewProps> = ({ onBack }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [activeCategory, setActiveCategory] = useState('全部');
  const [isScrolled, setIsScrolled] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 800);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        setIsScrolled(scrollRef.current.scrollTop > 10);
      }
    };
    const el = scrollRef.current;
    if (el) {
        el.addEventListener('scroll', handleScroll);
        return () => el.removeEventListener('scroll', handleScroll);
    }
  }, [isLoading]);

  const filteredProducts = activeCategory === '全部' 
    ? PRODUCTS 
    : PRODUCTS.filter(p => p.category === activeCategory);

  if (isLoading) {
      return (
          <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col">
              <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
                 <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
                 <div className="w-32 h-6 bg-gray-100 rounded animate-shimmer" />
                 <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
              </div>
              <div className="p-5">
                 <div className="w-full h-[140px] rounded-[24px] bg-gray-200 animate-shimmer mb-6" />
                 <div className="flex gap-3 mb-4">
                     {[1,2,3,4].map(i => <div key={i} className="w-16 h-8 rounded-full bg-gray-200 animate-shimmer" />)}
                 </div>
                 <div className="grid grid-cols-2 gap-3">
                     {[1,2,3,4].map(i => <div key={i} className="h-[240px] rounded-[20px] bg-gray-200 animate-shimmer" />)}
                 </div>
              </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className={`pt-[54px] px-5 pb-3 flex justify-between items-center z-20 transition-all duration-300 ${
          isScrolled ? 'bg-white shadow-[0_4px_20px_rgba(0,0,0,0.03)]' : 'bg-[#F5F7FA]'
      }`}>
          <button onClick={onBack} className="w-10 h-10 -ml-2 flex items-center justify-center rounded-full active:bg-black/5 transition-colors">
              <ArrowLeft size={24} className="text-[#111]" />
          </button>
          <div className="text-[18px] font-bold text-[#111]">车主专属</div>
          <button className="w-10 h-10 -mr-2 flex items-center justify-center rounded-full active:bg-black/5 transition-colors">
              <Search size={22} className="text-[#111]" />
          </button>
      </div>

      <div ref={scrollRef} className="flex-1 overflow-y-auto no-scrollbar relative">
          <div className="px-5 pb-4">
              {/* Radius-L (24px) for car card */}
              <div className="bg-gradient-to-br from-[#1a1a1a] to-[#333] rounded-3xl p-6 text-white shadow-xl shadow-black/10 relative overflow-hidden mb-8 border border-white/5">
                  <div className="relative z-10 flex justify-between items-start">
                      <div>
                          <div className="flex items-center gap-2 mb-2">
                              <span className="text-[20px] font-bold">北京BJ40 PLUS</span>
                              <ChevronDown size={18} className="opacity-40" />
                          </div>
                          <div className="text-[11px] font-bold opacity-80 bg-white/10 w-fit px-2.5 py-0.5 rounded-lg flex items-center gap-1 border border-white/10 backdrop-blur-md">
                              <ShieldCheck size={12} /> 认证车主 · 享专属折扣
                          </div>
                      </div>
                      <div className="w-11 h-11 rounded-full bg-white/10 flex items-center justify-center border border-white/10 backdrop-blur-md">
                          <Car size={22} />
                      </div>
                  </div>
                  
                  <img 
                      src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" 
                      className="absolute -right-8 -bottom-10 w-[220px] opacity-20 pointer-events-none mix-blend-overlay filter brightness-150" 
                  />
                  
                  <div className="relative z-10 mt-8 pt-5 border-t border-white/10 flex gap-8">
                      <div>
                          <div className="text-[10px] text-white/50 font-bold uppercase tracking-wider mb-1">Benefit</div>
                          <div className="font-oswald text-[22px] font-bold text-[#FF6B00]">9.5<span className="text-xs ml-0.5 font-bold">折</span></div>
                      </div>
                      <div>
                          <div className="text-[10px] text-white/50 font-bold uppercase tracking-wider mb-1">Points</div>
                          <div className="font-oswald text-[22px] font-bold">2,450</div>
                      </div>
                  </div>
              </div>

              <div className="sticky top-0 z-10 -mx-5 px-5 bg-[#F5F7FA]/95 backdrop-blur-md pb-5 pt-2">
                  <div className="flex gap-3 overflow-x-auto no-scrollbar">
                      {CATEGORIES.map(cat => (
                          <button
                            key={cat}
                            onClick={() => setActiveCategory(cat)}
                            className={`px-6 py-2 rounded-full text-[13px] font-bold whitespace-nowrap transition-all active:scale-95 ${
                                activeCategory === cat
                                    ? 'bg-[#111] text-white shadow-lg'
                                    : 'bg-white text-gray-400 border border-gray-100 shadow-sm'
                            }`}
                          >
                              {cat}
                          </button>
                      ))}
                  </div>
              </div>

              {/* Radius-M (16px) for product grid */}
              <div className="grid grid-cols-2 gap-4 pb-10">
                  {filteredProducts.map((product, idx) => (
                      <div 
                        key={idx}
                        className="bg-white rounded-2xl overflow-hidden shadow-[0_4px_24px_rgba(0,0,0,0.02)] group cursor-pointer active:scale-[0.98] transition-transform relative border border-white"
                      >
                          <div className="aspect-square bg-[#F9FAFB] relative overflow-hidden">
                              <img src={product.image} className="w-full h-full object-cover group-active:scale-105 transition-transform duration-700" />
                              {product.tag && (
                                  <div className="absolute top-3 left-3 bg-[#FF6B00]/90 backdrop-blur-md text-white text-[9px] font-bold px-2 py-1 rounded-lg shadow-sm border border-white/10">
                                      {product.tag}
                                  </div>
                              )}
                          </div>
                          
                          <div className="p-4">
                              <div className="text-[14px] font-bold text-[#111] line-clamp-2 leading-snug mb-2 h-[40px]">
                                  {product.title}
                              </div>
                              
                              <div className="inline-flex items-center text-[10px] text-[#FF6B00] font-bold bg-orange-50 px-2 py-0.5 rounded-lg mb-3 border border-orange-100">
                                  专属折扣价
                              </div>

                              <div className="flex items-end justify-between">
                                  <div>
                                      <div className="flex items-baseline gap-0.5 text-[#FF6B00] font-oswald">
                                          <span className="text-[12px] font-bold">¥</span>
                                          <span className="text-[20px] font-bold leading-none">{product.price}</span>
                                      </div>
                                      <div className="text-[11px] text-gray-300 line-through font-oswald mt-0.5">
                                          ¥{product.originalPrice}
                                      </div>
                                  </div>
                                  <button className="w-9 h-9 rounded-full bg-[#111] flex items-center justify-center text-white active:scale-90 transition-transform shadow-lg shadow-black/20">
                                      <ShoppingCart size={16} />
                                  </button>
                              </div>
                          </div>
                      </div>
                  ))}
              </div>

              <div className="py-8 text-center text-[10px] text-gray-300 font-oswald tracking-[0.3em] uppercase font-bold">
                  Baic Premium Select
              </div>
          </div>
      </div>
    </div>
  );
};

export default StoreOwnerExclusiveView;
