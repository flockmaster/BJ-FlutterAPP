
import React, { useState, useMemo, useEffect } from 'react';
import { 
  ArrowLeft, 
  Check, 
  ChevronRight, 
  Info, 
  RotateCw, 
  Maximize2,
  Armchair,
  Palette,
  Disc,
  Layers,
  ChevronUp,
  ChevronDown,
  CreditCard,
  Heart
} from 'lucide-react';
import { CarModel, WishlistConfig, CarVersion } from '../types';

interface CarOrderViewProps {
  car: CarModel;
  onBack: () => void;
  onSaveWishlist: (config: WishlistConfig) => void;
  initialVersionId?: string;
}

// --- Data Constants ---

const COLORS = [
    { id: 'orange', name: '熔岩橙', hex: '#FF6B00', type: '金属漆', price: 0 },
    { id: 'black', name: '极夜黑', hex: '#1A1A1A', type: '珠光漆', price: 0 },
    { id: 'white', name: '雪域白', hex: '#F5F5F5', type: '普通漆', price: 2000 },
    { id: 'green', name: '丛林绿', hex: '#4A5D48', type: '哑光漆', price: 5000 },
    { id: 'silver', name: '星际银', hex: '#9CA3AF', type: '金属漆', price: 0 },
];

const INTERIOR_COLORS = [
    { id: 'black', name: '暗夜黑', hex: '#222222', material: 'Nappa真皮', image: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop' },
    { id: 'brown', name: '摩卡棕', hex: '#5D4037', material: '高级打孔皮', image: 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=800&auto=format&fit=crop' },
    { id: 'red', name: '波尔多红', hex: '#7F1D1D', material: '运动翻毛皮', image: 'https://images.unsplash.com/photo-1583267746897-2cf415887172?q=80&w=800&auto=format&fit=crop' },
];

const WHEELS = [
    { id: '17', name: '17英寸熏黑轮毂', price: 0, desc: '标配全地形轮胎' },
    { id: '18', name: '18英寸AT防脱圈', price: 3000, desc: '含全尺寸备胎' },
    { id: '19', name: '19英寸锻造轮毂', price: 6000, desc: '轻量化设计' },
];

const TABS = [
    { id: 'version', label: '版本', icon: Layers },
    { id: 'exterior', label: '外观', icon: Palette },
    { id: 'wheels', label: '轮毂', icon: Disc },
    { id: 'interior', label: '内饰', icon: Armchair },
];

// --- Sub-Components ---

// 1. Interactive Car Visualizer (SVG Manipulation)
const CarVisualizer = ({ colorId, showInterior, interiorImage }: { colorId: string, showInterior: boolean, interiorImage?: string }) => {
    const [svgContent, setSvgContent] = useState<string | null>(null);

    const getPalette = (id: string) => {
        switch(id) {
            case 'black': return { main: 'rgb(30, 30, 30)', shadow: 'rgb(10, 10, 10)', highlight: 'rgb(60, 60, 60)' };
            case 'white': return { main: 'rgb(240, 240, 240)', shadow: 'rgb(180, 180, 180)', highlight: 'rgb(255, 255, 255)' };
            case 'green': return { main: 'rgb(60, 80, 60)', shadow: 'rgb(30, 40, 30)', highlight: 'rgb(90, 110, 90)' };
            case 'silver': return { main: 'rgb(160, 160, 160)', shadow: 'rgb(100, 100, 100)', highlight: 'rgb(200, 200, 200)' };
            case 'orange': default: return { main: 'rgb(241,137,33)', shadow: 'rgb(195,92,6)', highlight: 'rgb(227,149,65)' };
        }
    };

    useEffect(() => {
        fetch('bj40.svg').then(res => res.text()).then(setSvgContent).catch(console.error);
    }, []);

    const finalSvg = useMemo(() => {
        if (!svgContent) return null;
        const p = getPalette(colorId);
        let mod = svgContent;
        mod = mod.replace(/rgb\(\s*241\s*,\s*137\s*,\s*33\s*\)/gi, p.main);
        mod = mod.replace(/rgb\(\s*195\s*,\s*92\s*,\s*6\s*\)/gi, p.shadow);
        mod = mod.replace(/rgb\(\s*227\s*,\s*149\s*,\s*65\s*\)/gi, p.highlight);
        mod = mod.replace(/rgb\(\s*253\s*,\s*253\s*,\s*253\s*\)/gi, 'transparent'); // BG removal
        return mod;
    }, [svgContent, colorId]);

    return (
        <div className="relative w-full h-full flex items-center justify-center transition-all duration-700">
            {/* Interior View */}
            <div className={`absolute inset-0 transition-opacity duration-700 ${showInterior ? 'opacity-100 z-20' : 'opacity-0 z-0'}`}>
                <div 
                    className="w-full h-full bg-cover bg-center transition-all duration-700 transform"
                    style={{ backgroundImage: `url(${interiorImage})` }}
                />
                <div className="absolute inset-0 bg-black/10" />
            </div>

            {/* Exterior View */}
            <div className={`absolute inset-0 flex items-center justify-center transition-all duration-700 p-6 ${showInterior ? 'opacity-0 scale-110 z-0' : 'opacity-100 scale-100 z-10'}`}>
                {finalSvg ? (
                    <div className="w-full h-full flex items-center justify-center drop-shadow-2xl" dangerouslySetInnerHTML={{ __html: finalSvg }} />
                ) : (
                    <div className="animate-pulse bg-gray-200 w-64 h-32 rounded-xl" />
                )}
                <div className="absolute bottom-10 z-[-1] w-[60%] h-[20px] bg-black/20 blur-xl rounded-[100%]" />
            </div>
        </div>
    );
};

// --- Main Component ---

const CarOrderView: React.FC<CarOrderViewProps> = ({ car, onBack, onSaveWishlist, initialVersionId }) => {
  // Config State
  const [activeTab, setActiveTab] = useState('version');
  const [selectedTrimId, setSelectedTrimId] = useState<string>(initialVersionId || '');
  const [colorId, setColorId] = useState('orange');
  const [wheelId, setWheelId] = useState('17');
  const [interiorId, setInteriorId] = useState('black');
  
  // UI State
  const [showFinance, setShowFinance] = useState(false);
  const [isRotating, setIsRotating] = useState(false); // Fake rotate effect

  // Derived Data
  const trims = useMemo(() => {
      if (car.versions) return Object.values(car.versions);
      return [
          { id: 'std', name: '标准版', price: '159,800', features: ['2.0T+8AT', '织物座椅'] },
          { id: 'pro', name: 'Pro版', price: '179,800', features: ['真皮座椅', 'L2辅助驾驶'] }
      ];
  }, [car]);

  // Ensure selectedTrim is valid
  useEffect(() => {
      if (!selectedTrimId && trims.length > 0) setSelectedTrimId(trims[0].id);
  }, [trims, selectedTrimId]);

  const selectedTrim = trims.find(t => t.id === selectedTrimId) || trims[0];
  const selectedColor = COLORS.find(c => c.id === colorId) || COLORS[0];
  const selectedWheel = WHEELS.find(w => w.id === wheelId) || WHEELS[0];
  const selectedInterior = INTERIOR_COLORS.find(i => i.id === interiorId) || INTERIOR_COLORS[0];

  // Price Calculation
  const basePrice = parseFloat(selectedTrim.price.toString().replace(/,/g, ''));
  const totalPrice = basePrice + selectedColor.price + selectedWheel.price;
  
  // Handlers
  const handleTabChange = (id: string) => {
      setActiveTab(id);
      // Auto-switch view perspective
      if (id === 'interior') {
          // View switches inside Visualizer automatically via props
      } 
  };

  const handleSave = () => {
      onSaveWishlist({
          modelId: car.id,
          trimId: selectedTrim.id,
          trimName: selectedTrim.name,
          colorId: selectedColor.id,
          colorName: selectedColor.name,
          colorHex: selectedColor.hex,
          interiorId: selectedInterior.id,
          interiorName: selectedInterior.name,
          interiorHex: selectedInterior.hex,
          wheelId: selectedWheel.id,
          wheelName: selectedWheel.name,
          totalPrice,
          timestamp: Date.now()
      });
  };

  const toggleRotate = () => {
      setIsRotating(true);
      setTimeout(() => setIsRotating(false), 800);
  };

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      
      {/* 1. Immersive Header (Transparent) */}
      <div className="absolute top-0 left-0 right-0 z-30 pt-[54px] px-5 pb-2 flex justify-between items-center pointer-events-none">
          <button 
            onClick={onBack} 
            className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center bg-white/10 backdrop-blur-md border border-white/20 text-black shadow-sm pointer-events-auto active:scale-90 transition-transform"
          >
              <ArrowLeft size={20} />
          </button>
          
          {/* Visualizer Controls */}
          <div className="flex gap-2 pointer-events-auto">
              <button 
                onClick={toggleRotate}
                className="w-10 h-10 rounded-full flex items-center justify-center bg-white/10 backdrop-blur-md border border-white/20 text-black shadow-sm active:scale-90 transition-transform"
              >
                  <RotateCw size={18} className={isRotating ? 'animate-spin' : ''} />
              </button>
              <button className="w-10 h-10 rounded-full flex items-center justify-center bg-white/10 backdrop-blur-md border border-white/20 text-black shadow-sm active:scale-90 transition-transform">
                  <Maximize2 size={18} />
              </button>
          </div>
      </div>

      {/* 2. Main Visualizer Area (Top Half) */}
      <div className="relative h-[45%] w-full bg-gradient-to-b from-[#Eef2f5] to-[#F5F7FA] overflow-hidden">
          <CarVisualizer 
             colorId={colorId} 
             showInterior={activeTab === 'interior'}
             interiorImage={selectedInterior.image}
          />
          
          {/* Info Badge Overlay */}
          <div className="absolute bottom-6 left-6 pointer-events-none animate-in fade-in slide-in-from-bottom-4 duration-700">
              <h2 className="text-[32px] font-bold font-oswald text-[#111] leading-none mb-1">{car.name}</h2>
              <div className="flex items-center gap-2 text-[13px] text-gray-500 font-medium">
                  <span className="bg-white/50 backdrop-blur-md px-2 py-0.5 rounded border border-white/40">{selectedTrim.name}</span>
                  <span>{activeTab === 'interior' ? selectedInterior.name : selectedColor.name}</span>
              </div>
          </div>
      </div>

      {/* 3. Configuration Panel (Bottom Half - Scrollable) */}
      <div className="flex-1 bg-white rounded-t-[32px] shadow-[0_-10px_40px_rgba(0,0,0,0.06)] relative z-20 flex flex-col overflow-hidden">
          
          {/* Sticky Tab Bar */}
          <div className="flex items-center justify-between px-6 pt-2 pb-2 border-b border-gray-50 bg-white z-20">
              {TABS.map(tab => {
                  const Icon = tab.icon;
                  const isActive = activeTab === tab.id;
                  return (
                      <button
                        key={tab.id}
                        onClick={() => handleTabChange(tab.id)}
                        className={`flex flex-col items-center gap-1.5 py-3 relative transition-all px-2 ${isActive ? 'text-[#111]' : 'text-gray-400'}`}
                      >
                          <div className={`w-10 h-10 rounded-2xl flex items-center justify-center transition-all ${isActive ? 'bg-[#111] text-white shadow-lg shadow-black/20 scale-110' : 'bg-gray-50'}`}>
                              <Icon size={18} />
                          </div>
                          <span className="text-[11px] font-bold">{tab.label}</span>
                      </button>
                  )
              })}
          </div>

          {/* Scrollable Options Area */}
          <div className="flex-1 overflow-y-auto no-scrollbar p-6 bg-[#FAFAFA]">
              
              {/* VERSION SELECTION */}
              {activeTab === 'version' && (
                  <div className="space-y-3 animate-in slide-in-from-right-4 fade-in duration-300">
                      {trims.map(trim => (
                          <div 
                            key={trim.id}
                            onClick={() => setSelectedTrimId(trim.id)}
                            className={`p-5 rounded-2xl border-2 transition-all cursor-pointer relative ${
                                selectedTrimId === trim.id 
                                    ? 'bg-white border-[#111] shadow-md' 
                                    : 'bg-white border-transparent shadow-sm opacity-80'
                            }`}
                          >
                              <div className="flex justify-between items-start mb-2">
                                  <span className="text-[16px] font-bold text-[#111]">{trim.name}</span>
                                  <span className="text-[16px] font-bold font-oswald text-[#FF6B00]">{trim.price}</span>
                              </div>
                              <div className="flex gap-2">
                                  {trim.features.map((f: string, i: number) => (
                                      <span key={i} className="text-[10px] bg-gray-50 text-gray-500 px-2 py-1 rounded">{f}</span>
                                  ))}
                              </div>
                              {selectedTrimId === trim.id && (
                                  <div className="absolute top-0 right-0 bg-[#111] text-white p-1 rounded-bl-xl rounded-tr-xl">
                                      <Check size={12} />
                                  </div>
                              )}
                          </div>
                      ))}
                  </div>
              )}

              {/* EXTERIOR COLOR */}
              {activeTab === 'exterior' && (
                  <div className="animate-in slide-in-from-right-4 fade-in duration-300">
                      <div className="text-[13px] text-gray-400 font-bold mb-4 ml-1 uppercase tracking-wider">选择车漆</div>
                      <div className="grid grid-cols-4 gap-4">
                          {COLORS.map(color => (
                              <button 
                                key={color.id}
                                onClick={() => setColorId(color.id)}
                                className="flex flex-col items-center gap-2 group"
                              >
                                  <div className={`w-14 h-14 rounded-full shadow-sm relative flex items-center justify-center transition-all duration-300 ${
                                      colorId === color.id ? 'scale-110 ring-2 ring-offset-2 ring-[#111]' : 'scale-100 group-hover:scale-105'
                                  }`} style={{ backgroundColor: color.hex }}>
                                      {color.id === 'white' && <div className="absolute inset-0 rounded-full border border-gray-200" />}
                                      {colorId === color.id && <Check size={20} className={color.id === 'white' ? 'text-black' : 'text-white'} />}
                                  </div>
                                  <div className="text-center">
                                      <div className={`text-[12px] font-bold ${colorId === color.id ? 'text-[#111]' : 'text-gray-500'}`}>{color.name}</div>
                                      {color.price > 0 && <div className="text-[10px] text-[#FF6B00] font-oswald">+¥{color.price}</div>}
                                  </div>
                              </button>
                          ))}
                      </div>
                  </div>
              )}

              {/* INTERIOR */}
              {activeTab === 'interior' && (
                  <div className="animate-in slide-in-from-right-4 fade-in duration-300 space-y-3">
                      {INTERIOR_COLORS.map(interior => (
                          <div 
                            key={interior.id}
                            onClick={() => setInteriorId(interior.id)}
                            className={`flex items-center gap-4 p-3 rounded-2xl border-2 transition-all cursor-pointer ${
                                interiorId === interior.id ? 'bg-white border-[#111] shadow-md' : 'bg-white border-transparent shadow-sm'
                            }`}
                          >
                              <div className="w-12 h-12 rounded-full border border-gray-100 shadow-inner" style={{ backgroundColor: interior.hex }} />
                              <div className="flex-1">
                                  <div className="text-[14px] font-bold text-[#111]">{interior.name}</div>
                                  <div className="text-[11px] text-gray-400">{interior.material}</div>
                              </div>
                              {interiorId === interior.id && <Check size={18} className="text-[#111] mr-2" />}
                          </div>
                      ))}
                  </div>
              )}

              {/* WHEELS */}
              {activeTab === 'wheels' && (
                  <div className="animate-in slide-in-from-right-4 fade-in duration-300 space-y-3">
                      {WHEELS.map(wheel => (
                          <div 
                            key={wheel.id}
                            onClick={() => setWheelId(wheel.id)}
                            className={`flex items-center gap-4 p-4 rounded-2xl border-2 transition-all cursor-pointer ${
                                wheelId === wheel.id ? 'bg-white border-[#111] shadow-md' : 'bg-white border-transparent shadow-sm'
                            }`}
                          >
                              <div className="w-14 h-14 bg-gray-100 rounded-full flex items-center justify-center text-gray-400">
                                  <Disc size={28} />
                              </div>
                              <div className="flex-1">
                                  <div className="text-[14px] font-bold text-[#111]">{wheel.name}</div>
                                  <div className="text-[11px] text-gray-400">{wheel.desc}</div>
                              </div>
                              <div className="text-right mr-2">
                                  {wheel.price > 0 ? (
                                      <div className="text-[13px] font-bold font-oswald text-[#FF6B00]">+¥{wheel.price}</div>
                                  ) : (
                                      <div className="text-[11px] font-bold text-gray-400 bg-gray-100 px-2 py-0.5 rounded">标配</div>
                                  )}
                              </div>
                          </div>
                      ))}
                  </div>
              )}
          </div>

          {/* 4. Bottom Action Bar (Fixed) */}
          <div className="bg-white border-t border-gray-100 px-6 pt-3 pb-[34px] shadow-[0_-4px_30px_rgba(0,0,0,0.06)] relative z-30">
              
              {/* Finance Toggle (Expandable) */}
              <div 
                onClick={() => setShowFinance(!showFinance)}
                className="flex items-center justify-between mb-3 text-[12px] text-gray-500 cursor-pointer active:opacity-60 select-none"
              >
                  <div className="flex items-center gap-1.5">
                      <CreditCard size={14} />
                      <span>分期方案预估</span>
                  </div>
                  <div className="flex items-center gap-1">
                      <span className="font-oswald">首付 ¥{(totalPrice * 0.1).toLocaleString()}</span>
                      {showFinance ? <ChevronDown size={14} /> : <ChevronUp size={14} />}
                  </div>
              </div>

              {/* Finance Detail (Animated) */}
              {showFinance && (
                  <div className="mb-4 p-3 bg-gray-50 rounded-xl text-[12px] text-gray-600 space-y-1 animate-in slide-in-from-bottom-2 fade-in">
                      <div className="flex justify-between"><span>贷款金额</span><span className="font-oswald font-bold">¥{(totalPrice * 0.9).toLocaleString()}</span></div>
                      <div className="flex justify-between"><span>月供 (36期)</span><span className="font-oswald font-bold text-[#FF6B00]">¥{Math.round(totalPrice * 0.9 / 36 * 1.04).toLocaleString()}</span></div>
                  </div>
              )}

              {/* Main Actions */}
              <div className="flex items-center gap-4">
                  <div className="flex flex-col">
                      <span className="text-[10px] text-gray-400 font-bold uppercase tracking-tight">Total Price</span>
                      <div className="flex items-baseline gap-0.5 text-[#111] font-oswald leading-none">
                          <span className="text-[16px] font-bold">¥</span>
                          <span className="text-[32px] font-bold tracking-tight">{totalPrice.toLocaleString()}</span>
                      </div>
                  </div>
                  <div className="flex gap-2 flex-1">
                      <button 
                        onClick={handleSave}
                        className="w-12 h-12 rounded-full border border-gray-200 flex items-center justify-center text-gray-400 active:text-[#FF6B00] active:border-[#FF6B00] active:bg-orange-50 transition-all"
                      >
                          <Heart size={20} />
                      </button>
                      <button 
                        onClick={() => alert('订单已提交，请前往支付')}
                        className="flex-1 h-12 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-xl shadow-black/20 active:scale-[0.98] transition-transform flex items-center justify-center gap-2"
                      >
                          立即定购 <ChevronRight size={16} />
                      </button>
                  </div>
              </div>
          </div>
      </div>
    </div>
  );
};

export default CarOrderView;
