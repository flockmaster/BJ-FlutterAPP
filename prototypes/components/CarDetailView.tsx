
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Share2, 
  ChevronRight, 
  Play, 
  Pause, 
  Volume2, 
  VolumeX, 
  ArrowUpRight, 
  MoveHorizontal, 
  Maximize2, 
  Ruler, 
  Wrench, 
  Hammer, 
  Settings
} from 'lucide-react';
import { CarModel } from '../types';

const ChevronDownIcon = () => (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M6 9l6 6 6-6"/>
    </svg>
);

const SpecItem = ({ value, unit, label }: { value: string, unit: string, label: string }) => (
    <div className="flex flex-col items-center flex-1">
        <div className="flex items-baseline gap-0.5 mb-1">
            <span className="text-[24px] font-oswald font-bold text-[#111]">{value}</span>
            {unit && <span className="text-[12px] text-gray-500 font-medium">{unit}</span>}
        </div>
        <div className="text-[12px] text-gray-400 font-medium">{label}</div>
    </div>
);

const ScrollReveal = ({ children, className = "" }: { children?: React.ReactNode, className?: string }) => {
  const [isVisible, setIsVisible] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.disconnect();
        }
      },
      { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }
    );
    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, []);

  return (
    <div ref={ref} className={`transition-all duration-1000 ease-out transform ${className} ${isVisible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-16"}`}>
      {children}
    </div>
  );
};

interface CarDetailViewProps {
  car: CarModel;
  onBack: () => void;
  onOrder: () => void;
  onTestDrive: () => void;
}

const CarDetailView: React.FC<CarDetailViewProps> = ({ car, onBack, onOrder, onTestDrive }) => {
  const [activeFeatureIndex, setActiveFeatureIndex] = useState(0);
  const carouselRef = useRef<HTMLDivElement>(null);
  const [scrollProgress, setScrollProgress] = useState(0);
  const videoRef = useRef<HTMLVideoElement>(null);
  const [isVideoPlaying, setIsVideoPlaying] = useState(false);
  const pageScrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handlePageScroll = () => {
      if (pageScrollRef.current) {
        const scrollTop = pageScrollRef.current.scrollTop;
        const opacity = Math.min(scrollTop / 300, 1);
        setScrollProgress(opacity);
      }
    };
    const el = pageScrollRef.current;
    if (el) el.addEventListener('scroll', handlePageScroll);
    return () => el?.removeEventListener('scroll', handlePageScroll);
  }, []);

  const handleCarouselScroll = () => {
    if (carouselRef.current) {
      const scrollLeft = carouselRef.current.scrollLeft;
      const width = carouselRef.current.offsetWidth;
      const index = Math.round(scrollLeft / width);
      if (index !== activeFeatureIndex) setActiveFeatureIndex(index);
    }
  };

  const handleVideoToggle = () => {
      if (videoRef.current) {
          if (videoRef.current.paused) {
              videoRef.current.play().catch(e => console.error("Play failed:", e));
              setIsVideoPlaying(true);
          } else {
              videoRef.current.pause();
              setIsVideoPlaying(false);
          }
      }
  };

  const carouselFeatures = [
    { title: "五屏联动智能座舱", desc: "由双10.25英寸联屏与中控屏组成，支持多指飞屏操作，将越野路况、导航信息实时流转。", image: "https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=800&auto=format&fit=crop" },
    { title: "女王副驾，尊享体验", desc: "配备电动腿托与零重力模式，支持12向电动调节、通风、加热及按摩功能。", image: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop" },
    { title: "丹拿高保真音响", desc: "12扬声器环绕音响系统，配合ANC主动降噪技术，隔绝车外喧嚣。", image: "https://images.unsplash.com/photo-1583267746897-2cf415887172?q=80&w=800&auto=format&fit=crop" }
  ];

  const modKits = [
      { name: '雨林穿越版', image: 'https://youke3.picui.cn/s1/2026/01/07/695df03c5243a.jpg', tags: ['涉水喉', 'MT胎'] },
      { name: '黑武士版', image: 'https://youke3.picui.cn/s1/2026/01/07/695df06febd20.jpg', tags: ['全黑涂装', '升高'] },
      { name: '荒野露营版', image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=600&auto=format&fit=crop', tags: ['车顶帐篷', '侧帐'] },
  ];

  return (
    <div className="absolute inset-0 z-[2000] bg-white flex flex-col animate-in slide-in-from-right duration-500 font-sans overflow-hidden">
      {/* 1. Immersive Header - Radius-Full buttons */}
      <div className="absolute top-0 left-0 right-0 z-[2100] pt-[54px] px-5 pb-3 flex justify-between items-center transition-all duration-300" style={{ backgroundColor: `rgba(255, 255, 255, ${scrollProgress})`, borderBottom: scrollProgress > 0.9 ? '1px solid rgba(0,0,0,0.05)' : 'none' }}>
         <button 
           onClick={onBack} 
           className={`w-9 h-9 rounded-full flex items-center justify-center transition-all active:scale-90 ${scrollProgress > 0.5 ? 'bg-gray-100 text-[#111]' : 'bg-black/20 text-white backdrop-blur-md'}`}
         >
             <ArrowLeft size={20} />
         </button>
         <div className="text-[16px] font-bold text-[#111] transition-opacity duration-300" style={{ opacity: scrollProgress }}>{car.name} 详情</div>
         <div className="flex gap-2">
            <button className={`w-9 h-9 rounded-full flex items-center justify-center transition-all active:scale-90 ${scrollProgress > 0.5 ? 'bg-gray-100 text-[#111]' : 'bg-black/20 text-white backdrop-blur-md'}`}>
                <Share2 size={18} />
            </button>
         </div>
      </div>

      <div ref={pageScrollRef} className="flex-1 overflow-y-auto no-scrollbar bg-white relative">
          {/* Hero Section - Uses h-full to fill available flex space perfectly */}
          <div className="relative w-full bg-[#111] h-full">
              <img src="https://p.sda1.dev/29/dbaf76958fd40c38093331ef8952ef36/7a5f657b4c35395b6f910b6c1933da20.jpg" className="absolute inset-0 w-full h-full object-cover" alt="Hero" />
              {/* Adjusted Gradient Overlay for better brightness */}
              <div className="absolute inset-0 bg-gradient-to-b from-black/10 via-transparent to-black/40" />
              <div className="absolute bottom-[80px] left-0 right-0 px-6 text-center text-white">
                  <div className="inline-block px-3 py-1 rounded-lg bg-white/10 backdrop-blur-md border border-white/20 text-[10px] font-bold tracking-widest uppercase mb-4">Masterpiece</div>
                  <h1 className="text-[48px] font-bold leading-none mb-3 tracking-tight drop-shadow-md">{car.name}</h1>
                  <p className="text-[16px] font-medium opacity-90 mb-6 tracking-wide drop-shadow-sm">{car.subtitle}</p>
                  <div className="flex justify-center items-end gap-1 mb-8 drop-shadow-md">
                      <span className="text-[14px] opacity-90 mb-1 font-bold">¥</span>
                      <span className="text-[36px] font-oswald font-bold leading-none">{car.price}</span>
                      <span className="text-[14px] opacity-90 mb-1 font-bold">{car.priceUnit}</span>
                  </div>
              </div>
              <div className="absolute bottom-10 left-1/2 -translate-x-1/2 animate-bounce opacity-40">
                  <ChevronDownIcon />
              </div>
          </div>

          {/* Quick Specs - Full Width Clean */}
          <ScrollReveal>
            <div className="bg-white py-12 px-6">
                <div className="flex justify-between items-center border-b border-gray-100 pb-12">
                    <SpecItem value="380" unit="N·m" label="最大扭矩" />
                    <div className="w-[1px] h-8 bg-gray-100"></div>
                    <SpecItem value="8AT" unit="" label="变速箱" />
                    <div className="w-[1px] h-8 bg-gray-100"></div>
                    <SpecItem value="220" unit="mm" label="离地间隙" />
                </div>
            </div>
          </ScrollReveal>

          {/* Space Blueprint - Full Bleed / No Radius */}
          <ScrollReveal>
             <div className="mb-16">
                 <div className="mb-8 px-6">
                    <h2 className="text-[32px] font-bold text-[#111] leading-tight mb-2">黄金比例，<br/>越野空间学。</h2>
                    <p className="text-[15px] text-gray-400 font-medium">2745mm 超长轴距，为您提供宽适驾乘体验。</p>
                 </div>
                 
                 {/* Full width container, no radius */}
                 <div className="w-full bg-[#F5F7FA] py-10 px-6 relative overflow-hidden border-y border-gray-100">
                     <div className="absolute inset-0 opacity-[0.03] pointer-events-none" style={{backgroundImage: 'linear-gradient(#000 1px, transparent 1px), linear-gradient(90deg, #000 1px, transparent 1px)', backgroundSize: '30px 30px'}}></div>
                     
                     <div className="relative h-[220px] w-full mb-10 flex items-center justify-center">
                         {/* UPDATED: Use the realistic image from service card */}
                         <img 
                            src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" 
                            className="h-[95%] object-contain drop-shadow-2xl" 
                            alt="Side Profile" 
                         />
                         <div className="absolute inset-0 pointer-events-none">
                             <div className="absolute bottom-0 left-[10%] right-[10%] h-[1px] bg-[#111] opacity-40">
                                 <div className="absolute -left-[1px] -top-1 w-[1.5px] h-3 bg-[#111]"></div>
                                 <div className="absolute -right-[1px] -top-1 w-[1.5px] h-3 bg-[#111]"></div>
                                 <span className="absolute -bottom-6 left-1/2 -translate-x-1/2 bg-[#F5F7FA] px-2 text-[12px] font-oswald font-bold text-[#111]">4790 mm</span>
                             </div>
                         </div>
                     </div>

                     {/* Stats - Clean Divider Look - No Cards */}
                     <div className="grid grid-cols-2 divide-x divide-gray-200 border-t border-gray-200 pt-8">
                         <div className="px-4 text-center">
                             <div className="flex items-center justify-center gap-2 mb-1 text-gray-400 text-[11px] font-bold uppercase tracking-wider">
                                <MoveHorizontal size={14} className="text-[#FF6B00]" /> 车宽
                             </div>
                             <div className="text-3xl font-oswald font-bold text-[#111]">1940 <span className="text-[12px] font-normal text-gray-400">mm</span></div>
                         </div>
                         <div className="px-4 text-center">
                             <div className="flex items-center justify-center gap-2 mb-1 text-gray-400 text-[11px] font-bold uppercase tracking-wider">
                                <Maximize2 size={14} className="text-[#FF6B00]" /> 容积
                             </div>
                             <div className="text-3xl font-oswald font-bold text-[#111]">1120 <span className="text-[12px] font-normal text-gray-400">L</span></div>
                         </div>
                     </div>
                 </div>
             </div>
          </ScrollReveal>

          {/* Design Aesthetic - Full Bleed / No Radius */}
          <ScrollReveal>
            <div className="mb-16">
                <div className="mb-8 px-6">
                    <h2 className="text-[32px] font-bold text-[#111] leading-tight mb-3">经典外观，<br/>致敬传奇。</h2>
                </div>
                
                {/* Full width image, no radius */}
                <div className="w-full aspect-[4/5] relative bg-gray-100 group">
                    <img src="https://youke3.picui.cn/s1/2026/01/07/695dd9e808861.jpeg" className="w-full h-full object-cover" />
                    
                    {/* Overlay Text - No floating card */}
                    <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-transparent to-transparent flex flex-col justify-end p-8">
                        <div className="w-10 h-1 bg-[#FF6B00] mb-4"></div>
                        <div className="text-[24px] font-bold text-white mb-2">一体式高强度防滚架</div>
                        <div className="text-[14px] text-white/70 font-medium leading-relaxed max-w-[80%]">
                            赛车级安全防护标准，为越野保驾护航。高强度钢材构建坚固堡垒。
                        </div>
                    </div>
                </div>
            </div>
          </ScrollReveal>

          {/* Customization Kits - Full Bleed Carousel */}
          <ScrollReveal>
              <div className="mb-16">
                  <div className="px-6 mb-6">
                      <h2 className="text-[32px] font-bold text-[#111] leading-tight mb-2">百变改装，<br/>千人千面。</h2>
                  </div>
                  {/* Changed to w-full items, snap scrolling, aspect-4/3 to match Smart Cockpit style */}
                  <div className="flex overflow-x-auto no-scrollbar snap-x snap-mandatory">
                      {modKits.map((kit, idx) => (
                          /* Full width & 4:3 aspect ratio like Cabin Carousel */
                          <div key={idx} className="w-full shrink-0 snap-center relative aspect-[4/3] group cursor-pointer">
                              <img src={kit.image} className="w-full h-full object-cover" />
                              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />
                              <div className="absolute bottom-0 left-0 right-0 p-8 text-white">
                                  <div className="flex items-center gap-2 mb-2 opacity-80">
                                      <Wrench size={14} className="text-[#FF6B00]" />
                                      <span className="text-[11px] font-bold uppercase tracking-wider">Official Kit</span>
                                  </div>
                                  <h3 className="text-[24px] font-bold mb-3">{kit.name}</h3>
                                  <div className="flex gap-2">
                                      {kit.tags.map(t => (
                                          <span key={t} className="text-[11px] text-white/90 border border-white/30 px-2.5 py-1 rounded backdrop-blur-sm">
                                              {t}
                                          </span>
                                      ))}
                                  </div>
                              </div>
                          </div>
                      ))}
                  </div>
              </div>
          </ScrollReveal>

          {/* Frameless Doors - Full Bleed / No Radius */}
          <ScrollReveal>
            <div className="mb-16">
                <div className="mb-8 px-6">
                    <h2 className="text-[32px] font-bold text-[#111] leading-tight mb-3">无框车门，<br/>先锋美学。</h2>
                </div>
                
                {/* Full width image, no radius */}
                <div className="w-full aspect-[4/3] relative bg-gray-100 group">
                    <img src="https://img.pcauto.com.cn/images/ttauto/2023/11/30/7306806780938715688/9619c2693aaa41bd95316e48118eb0a7.png" className="w-full h-full object-cover" alt="Frameless Door" />
                    
                    {/* Overlay Text */}
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent flex flex-col justify-end p-8">
                        <div className="w-10 h-1 bg-[#FF6B00] mb-4"></div>
                        <div className="text-[24px] font-bold text-white mb-2">同级罕见无框设计</div>
                        <div className="text-[14px] text-white/70 font-medium leading-relaxed max-w-[90%]">
                            打破传统越野定义，融合跑车设计元素。双层夹胶玻璃，在展现极致个性的同时，静谧性依然出色。
                        </div>
                    </div>
                </div>
            </div>
          </ScrollReveal>

          {/* Cabin Carousel - Full Width Swiper */}
          <ScrollReveal>
            <div className="mb-16">
                <div className="px-6 mb-6">
                    <h2 className="text-[32px] font-bold text-[#111] leading-tight mb-2">智能座舱，<br/>越野亦从容。</h2>
                </div>
                <div className="relative w-full">
                    {/* Full width items, snap scroll */}
                    <div ref={carouselRef} className="flex overflow-x-auto snap-x snap-mandatory no-scrollbar" onScroll={handleCarouselScroll}>
                        {carouselFeatures.map((feat, index) => (
                            <div key={index} className="w-full shrink-0 snap-center relative aspect-[4/3]">
                                <img src={feat.image} className="w-full h-full object-cover" />
                                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />
                                <div className="absolute bottom-0 left-0 right-0 p-8 text-white">
                                    <h3 className="text-[24px] font-bold mb-2">{feat.title}</h3>
                                    <p className="text-[14px] text-white/70 leading-relaxed font-medium">{feat.desc}</p>
                                </div>
                            </div>
                        ))}
                    </div>
                    {/* Indicators */}
                    <div className="absolute top-6 right-6 flex gap-1.5">
                        {carouselFeatures.map((_, idx) => (
                            <div key={idx} className={`h-1 transition-all duration-300 ${activeFeatureIndex === idx ? 'w-6 bg-white' : 'w-2 bg-white/30'}`} />
                        ))}
                    </div>
                </div>
            </div>
          </ScrollReveal>

          {/* Immersive Video - Full Bleed */}
          <ScrollReveal>
            <div className="mb-20">
                <div className="mb-6 px-6">
                    <h2 className="text-[32px] font-bold text-[#111] leading-tight mb-3">全地形征服者。</h2>
                </div>
                {/* Full Width Video */}
                <div 
                    className="w-full aspect-video relative bg-black group cursor-pointer" 
                    onClick={handleVideoToggle}
                >
                    <video ref={videoRef} className="w-full h-full object-cover" loop muted={false} playsInline poster="https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop">
                        <source src="images/bj402.mp4" type="video/mp4" />
                    </video>
                    <div className={`absolute inset-0 flex items-center justify-center bg-black/20 group-hover:bg-black/30 transition-all duration-500 z-10 ${isVideoPlaying ? 'opacity-0 pointer-events-none' : 'opacity-100'}`}>
                        <div className="w-16 h-16 bg-white/10 backdrop-blur-sm border border-white/30 flex items-center justify-center">
                            <Play size={24} className="fill-white text-white ml-1" />
                        </div>
                    </div>
                    <div className="absolute bottom-6 right-6 text-white text-[12px] font-bold font-oswald tracking-wider">00:45</div>
                </div>
            </div>
          </ScrollReveal>
      </div>

      {/* Bottom Floating Bar - Radius-Full Buttons, No Blur, Solid Background */}
      <div className="flex-none bg-white border-t border-gray-100 px-6 py-4 pb-[34px] z-[2100] flex items-center gap-5 shadow-[0_-8px_30px_rgba(0,0,0,0.04)]">
          <div className="flex flex-col">
              <span className="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-0.5">Price starts</span>
              <div className="flex items-baseline gap-0.5">
                  <span className="text-[14px] font-bold text-[#FF6B00]">¥</span>
                  <span className="text-[28px] font-oswald font-bold text-[#111] leading-none">{car.price}</span>
                  <span className="text-[11px] text-gray-400 font-bold ml-1">{car.priceUnit}</span>
              </div>
          </div>
          <div className="flex-1 flex gap-3">
              <button 
                onClick={onTestDrive} 
                className="flex-1 h-12 rounded-full bg-white border border-gray-200 text-[#111] text-[15px] font-bold active:scale-95 transition-all shadow-sm"
              >
                  预约试驾
              </button>
              <button 
                onClick={onOrder} 
                className="flex-1 h-12 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-lg shadow-black/20 active:scale-95 transition-all"
              >
                  立即定购
              </button>
          </div>
      </div>
    </div>
  );
};

export default CarDetailView;
