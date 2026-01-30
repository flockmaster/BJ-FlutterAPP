
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Plus, 
  Star, 
  Clock, 
  Gauge, 
  ShieldCheck, 
  MousePointer2,
  AlertTriangle,
  Trash2,
  ChevronRight,
  Fuel,
  Settings
} from 'lucide-react';

interface MyVehiclesViewProps {
  onBack: () => void;
  onAddVehicle: () => void;
  hasVehicle: boolean;
}

const MyVehiclesView: React.FC<MyVehiclesViewProps> = ({ onBack, onAddVehicle, hasVehicle }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [showUnbindHint, setShowUnbindHint] = useState(false);
  const [showUnbindModal, setShowUnbindModal] = useState(false);
  const longPressTimer = useRef<any>(null);

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 800);
    return () => clearTimeout(timer);
  }, []);

  const handleMouseDown = () => {
    longPressTimer.current = setTimeout(() => {
      setShowUnbindModal(true);
    }, 1000);
    setShowUnbindHint(true);
  };

  const handleMouseUp = () => {
    if (longPressTimer.current) clearTimeout(longPressTimer.current);
    setShowUnbindHint(false);
  };

  if (isLoading) {
      return (
          <div className="absolute inset-0 z-50 bg-[#F5F7FA] overflow-hidden">
             <div className="pt-[54px] px-5 py-4 border-b border-gray-100 bg-white flex justify-between items-center">
                <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
                <div className="w-32 h-6 bg-gray-100 rounded animate-shimmer" />
                <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
             </div>
             <div className="p-5 space-y-5">
                {[1,2].map(i => (
                    <div key={i} className="h-[180px] bg-white rounded-2xl p-5 shadow-sm">
                        <div className="flex gap-4">
                            <div className="w-1/3 h-24 bg-gray-100 rounded-xl animate-shimmer" />
                            <div className="flex-1 space-y-3">
                                <div className="w-full h-5 bg-gray-100 rounded animate-shimmer" />
                                <div className="w-2/3 h-4 bg-gray-100 rounded animate-shimmer" />
                            </div>
                        </div>
                    </div>
                ))}
             </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-50 bg-[#F5F7FA] flex flex-col overflow-hidden animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 bg-white border-b border-gray-100 shrink-0 pt-[54px] z-10">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
          <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">我的车辆</div>
        <button onClick={onAddVehicle} className="w-10 h-10 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
          <Plus size={24} className="text-[#111]" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-[40px]">
        {/* Page Title Section */}
        <div className="px-5 py-8 bg-white mb-2 shadow-sm">
          <div className="flex justify-between items-end">
            <div>
                <h1 className="text-[24px] font-bold text-[#111] mb-1">我的车库</h1>
                <div className="text-[13px] text-gray-400">
                    {hasVehicle ? '管理您的 3 辆北京汽车' : '暂无绑定车辆'}
                </div>
            </div>
            {hasVehicle && (
                <div className="text-right">
                    <div className="text-[24px] font-oswald font-bold text-[#111] leading-none">12,450</div>
                    <div className="text-[10px] text-gray-400 mt-1 uppercase tracking-widest">Mileage (km)</div>
                </div>
            )}
          </div>
        </div>

        <div className="px-5 py-4 space-y-4">
          {hasVehicle ? (
              <>
                {/* Active Car Card - Optimized to match Mine Page layout */}
                <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-50 relative group active:scale-[0.99] transition-transform">
                    {/* Subtle Active Glow */}
                    <div className="absolute top-0 right-0 w-32 h-32 bg-orange-50 rounded-full blur-3xl -mr-10 -mt-10 opacity-30" />
                    
                    <div className="flex justify-between items-start mb-6 border-b border-gray-50 pb-4 relative z-10">
                        <div className="flex-1">
                            <div className="flex items-center gap-2 mb-1">
                                <h3 className="text-[17px] font-bold text-[#111]">北京BJ40 PLUS</h3>
                                <span className="bg-[#111] text-[#E5C07B] text-[9px] font-bold px-2 py-0.5 rounded flex items-center gap-1">
                                    <Star size={8} fill="currentColor" /> 主驾
                                </span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="text-[11px] text-gray-500 font-oswald font-medium bg-gray-50 px-2 py-0.5 rounded border border-gray-100">京A·12345</span>
                                <span className="text-[11px] text-[#00B894] font-bold flex items-center gap-1 bg-[#E6FFFA] px-2 py-0.5 rounded-md">
                                    <ShieldCheck size={12} /> 认证车主
                                </span>
                            </div>
                        </div>
                        <div className="w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center text-gray-400">
                            <Settings size={18} />
                        </div>
                    </div>

                    <div className="flex items-center gap-5 relative z-10">
                        {/* Showroom Image - Matches Mine Page */}
                        <div className="w-[110px] h-[70px] bg-[#F5F7FA] rounded-xl overflow-hidden relative flex items-center justify-center shrink-0">
                            <img 
                                src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" 
                                className="w-full h-full object-cover group-active:scale-110 transition-transform duration-500" 
                                alt="My Car"
                            />
                        </div>
                        
                        <div className="flex-1 grid grid-cols-2 gap-4">
                            <div className="flex flex-col">
                                <span className="text-[10px] text-gray-400 mb-0.5 font-medium">剩余油量</span>
                                <div className="flex items-baseline gap-0.5">
                                    <span className="text-[18px] font-bold font-oswald text-[#111]">85</span>
                                    <span className="text-[10px] text-gray-500 font-bold">%</span>
                                </div>
                            </div>
                            <div className="flex flex-col">
                                <span className="text-[10px] text-gray-400 mb-0.5 font-medium">总计里程</span>
                                <div className="flex items-baseline gap-0.5">
                                    <span className="text-[18px] font-bold font-oswald text-[#111]">8,521</span>
                                    <span className="text-[10px] text-gray-500 font-bold">km</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="flex gap-3 mt-6 pt-5 border-t border-gray-50 relative z-10">
                        <button className="flex-1 h-11 rounded-xl bg-[#111] text-white text-[14px] font-bold active:scale-[0.98] transition-all flex items-center justify-center gap-2 shadow-sm">
                            车辆远程控制
                        </button>
                        <button 
                        className="w-11 h-11 rounded-xl bg-white border border-gray-200 text-gray-300 flex items-center justify-center active:bg-red-50 active:text-red-500 active:border-red-100 transition-colors"
                        onMouseDown={handleMouseDown}
                        onMouseUp={handleMouseUp}
                        onMouseLeave={handleMouseUp}
                        onTouchStart={handleMouseDown}
                        onTouchEnd={handleMouseUp}
                        >
                        <Trash2 size={20} />
                        </button>
                    </div>
                </div>

                {/* Under Review Car */}
                <div className="bg-white rounded-2xl p-5 shadow-sm border border-transparent opacity-60">
                    <div className="flex justify-between items-start mb-4">
                        <div>
                            <h3 className="text-[16px] font-bold text-[#111] mb-1">北京BJ60 旗舰版</h3>
                            <div className="flex items-center gap-2">
                                <span className="text-[12px] text-gray-400 font-oswald">京B·67890</span>
                                <span className="text-[11px] text-orange-500 font-bold flex items-center gap-1 bg-orange-50 px-2 py-0.5 rounded">
                                    <Clock size={12} /> 审核中
                                </span>
                            </div>
                        </div>
                    </div>

                    <div className="flex gap-5 items-center">
                        <div className="w-[110px] h-[70px] bg-[#F5F7FA] rounded-xl overflow-hidden flex items-center justify-center grayscale opacity-30">
                            <img 
                                src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" 
                                className="w-full h-full object-cover" 
                                alt="Review Car"
                            />
                        </div>
                        <div className="flex-1">
                            <p className="text-[12px] text-gray-400 leading-relaxed">
                                车辆绑定审核预计在 24 小时内完成，请耐心等待。
                            </p>
                        </div>
                    </div>
                </div>
              </>
          ) : (
              <div className="py-10 text-center">
                  <div className="w-32 h-32 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6 text-gray-300">
                      <Plus size={48} strokeWidth={1} />
                  </div>
                  <h3 className="text-[16px] font-bold text-[#111] mb-2">车库空空如也</h3>
                  <p className="text-[13px] text-gray-400 mb-8 max-w-[200px] mx-auto">
                      立即绑定您的北京汽车，享受远程控制、车况查询等专属服务
                  </p>
              </div>
          )}

          {/* Add Entry Card */}
          <div 
            onClick={onAddVehicle}
            className={`bg-[#F5F7FA] rounded-2xl border-2 border-dashed border-gray-200 p-8 flex flex-col items-center justify-center cursor-pointer active:bg-gray-100 active:border-gray-300 transition-all ${!hasVehicle ? 'bg-white shadow-lg border-[#111] border-solid' : ''}`}
          >
             <div className={`w-12 h-12 rounded-full flex items-center justify-center mb-3 shadow-sm ${!hasVehicle ? 'bg-[#111] text-white' : 'bg-white text-gray-300'}`}>
               <Plus size={24} strokeWidth={3} />
             </div>
             <span className={`text-[15px] font-bold ${!hasVehicle ? 'text-[#111]' : 'text-gray-500'}`}>添加我的车辆</span>
             <span className="text-[11px] text-gray-400 mt-1">认证车主，解锁专属权益</span>
          </div>
        </div>
      </div>

      {/* Long Press Tooltip */}
      {hasVehicle && (
        <div className={`fixed bottom-28 left-1/2 -translate-x-1/2 bg-black/85 backdrop-blur-md text-white px-6 py-3 rounded-full text-[13px] font-medium flex items-center gap-2 transition-all duration-300 pointer-events-none z-[100] ${showUnbindHint ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'}`}>
            <MousePointer2 size={16} className="text-orange-400" /> 长按按钮 1 秒以发起解绑
        </div>
      )}

      {/* Unbind Dialog */}
      {showUnbindModal && (
        <div className="absolute inset-0 z-[150] flex items-center justify-center p-6">
           <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200" onClick={() => setShowUnbindModal(false)} />
           <div className="bg-white w-full max-w-xs rounded-[32px] p-8 relative z-10 animate-in zoom-in-95 duration-200 shadow-2xl text-center">
               <div className="w-16 h-16 bg-red-50 rounded-full flex items-center justify-center text-red-500 mx-auto mb-4">
                  <AlertTriangle size={32} />
               </div>
               <h3 className="text-[18px] font-bold text-[#111] mb-2">确认解除绑定？</h3>
               <p className="text-[14px] text-gray-500 leading-relaxed mb-8">
                 解绑后您将无法使用该车辆的手机远程控制、维保预约等数字化功能。
               </p>
               <div className="flex flex-col gap-3">
                  <button 
                    onClick={() => {
                        setShowUnbindModal(false);
                        alert('解绑申请已提交，请等待处理结果。');
                    }}
                    className="w-full py-3.5 bg-[#111] rounded-xl text-white font-bold text-[14px] active:scale-95 transition-transform"
                  >
                    确认解除
                  </button>
                  <button 
                    onClick={() => setShowUnbindModal(false)}
                    className="w-full py-3.5 bg-gray-50 rounded-xl text-[#666] font-bold text-[14px] active:bg-gray-100"
                  >
                    暂不解除
                  </button>
               </div>
           </div>
        </div>
      )}
    </div>
  );
};

export default MyVehiclesView;
