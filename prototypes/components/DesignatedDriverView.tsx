
import React, { useState } from 'react';
// Added ChevronRight to imports
import { ArrowLeft, MapPin, Search, Clock, User, Phone, ShieldCheck, Navigation, ChevronRight } from 'lucide-react';

interface DesignatedDriverViewProps {
  onBack: () => void;
}

const DesignatedDriverView: React.FC<DesignatedDriverViewProps> = ({ onBack }) => {
  return (
    <div className="absolute inset-0 z-[150] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* Map Background */}
      <div className="absolute inset-0 bg-gray-100">
          <div 
            className="absolute inset-0 bg-cover bg-center grayscale-[0.2] opacity-70" 
            style={{backgroundImage: 'url(https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=1000&auto=format&fit=crop)'}}
          />
          {/* Fake Drivers */}
          {[1,2,3,4].map(i => (
              <div key={i} className="absolute w-9 h-9 bg-[#111] text-white rounded-full flex items-center justify-center text-[10px] font-bold border-2 border-white shadow-xl animate-bounce" style={{ top: `${20 + i * 15}%`, left: `${25 + i * 12}%`, animationDelay: `${i * 0.4}s` }}>
                  代
              </div>
          ))}
      </div>

      {/* Header - V3.1 Floating Style */}
      <div className="absolute top-0 left-0 right-0 pt-[54px] px-5 pb-3 flex items-center gap-3 z-10 pointer-events-none">
          <button onClick={onBack} className="w-10 h-10 rounded-full bg-white shadow-lg flex items-center justify-center pointer-events-auto active:scale-90 transition-transform text-[#111] border border-gray-50">
              <ArrowLeft size={22} />
          </button>
          <div className="flex-1 bg-white shadow-lg h-10 rounded-full flex items-center px-4 gap-2 pointer-events-auto border border-gray-50">
              <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
              <span className="text-[13px] font-bold text-[#111]">当前位置</span>
              <span className="text-[12px] text-gray-400 truncate flex-1 font-medium">北京市朝阳区建国路88号</span>
          </div>
      </div>

      {/* Bottom Panel - Radius-L+ (32px) */}
      <div className="absolute bottom-0 left-0 right-0 p-4 pb-[40px] z-20">
          <div className="bg-white rounded-[32px] shadow-[0_-10px_40px_rgba(0,0,0,0.12)] p-7 animate-in slide-in-from-bottom duration-500 border border-gray-50">
              <div className="w-12 h-1.5 bg-gray-100 rounded-full mx-auto mb-6" />
              <h2 className="text-[20px] font-bold text-[#111] mb-6">呼叫极速代驾</h2>
              
              <div className="space-y-4 mb-8">
                  <div className="flex items-center gap-4 p-4 rounded-2xl bg-[#F9FAFB] border border-gray-50 active:bg-gray-100 transition-colors cursor-pointer group">
                      <div className="w-8 h-8 rounded-full bg-white flex items-center justify-center text-[#9CA3AF] shadow-sm">
                          <Navigation size={16} />
                      </div>
                      <div className="flex-1">
                          <div className="text-[12px] text-gray-400 mb-0.5">您要去哪儿？</div>
                          <div className="text-[16px] font-bold text-gray-300 group-active:text-gray-400">请输入目的地</div>
                      </div>
                      <ChevronRight size={18} className="text-gray-300" />
                  </div>

                  <div className="flex items-center gap-4 p-4 rounded-2xl bg-[#F9FAFB] border border-gray-50 active:bg-gray-100 transition-colors cursor-pointer">
                      <div className="w-8 h-8 rounded-full bg-white flex items-center justify-center text-[#111] shadow-sm">
                          <Clock size={16} />
                      </div>
                      <div className="flex-1">
                          <div className="text-[12px] text-gray-400 mb-0.5">出发时间</div>
                          <div className="text-[16px] font-bold text-[#111]">现在出发</div>
                      </div>
                      <ChevronRight size={18} className="text-gray-300" />
                  </div>
              </div>

              <div className="flex items-center justify-between mb-8 px-1">
                  <div className="flex items-center gap-2">
                      <ShieldCheck size={18} className="text-green-500" />
                      <div className="flex flex-col">
                        <span className="text-[13px] font-bold text-[#111]">北汽官方严选</span>
                        <span className="text-[10px] text-gray-400">千万级驾乘险保障 · 五星级司机</span>
                      </div>
                  </div>
                  <div className="text-right">
                    <div className="text-[11px] text-gray-400 mb-0.5">预估费用</div>
                    <div className="text-[20px] font-oswald font-bold text-[#FF6B00]">¥38 <span className="text-[12px] font-bold">起</span></div>
                  </div>
              </div>

              <button className="w-full h-14 rounded-2xl bg-[#111] text-white text-[16px] font-bold shadow-xl shadow-black/20 active:scale-[0.98] transition-all flex items-center justify-center gap-2">
                  立即呼叫
              </button>
          </div>
      </div>
    </div>
  );
};

export default DesignatedDriverView;
