
import React, { useState } from 'react';
import { ArrowLeft, Zap, Clock, Lock, Settings, BarChart3, Power, MoreHorizontal, ChevronRight } from 'lucide-react';

interface PrivatePileViewProps {
  onBack: () => void;
}

const PrivatePileView: React.FC<PrivatePileViewProps> = ({ onBack }) => {
  const [isLocked, setIsLocked] = useState(false);
  const [isCharging, setIsCharging] = useState(false);

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-transparent z-10">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-black/5 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[18px] font-bold text-[#111]">我的家充桩</div>
        <button className="w-10 h-10 -mr-2 rounded-full flex items-center justify-center active:bg-black/5 transition-colors">
            <Settings size={22} className="text-[#111]" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5">
          {/* Hero Visualizer - Radius-L (32px) */}
          <div className="bg-gradient-to-br from-[#111827] to-[#1F2937] rounded-[32px] p-7 text-white shadow-[0_15px_45px_rgba(0,0,0,0.15)] relative overflow-hidden h-[360px] flex flex-col justify-between mb-6">
              <div className="relative z-10 flex justify-between items-start">
                  <div>
                      <div className="flex items-center gap-2 mb-1">
                          <div className={`w-2 h-2 rounded-full ${isCharging ? 'bg-green-500 animate-pulse shadow-[0_0_8px_#22c55e]' : 'bg-gray-500'}`} />
                          <span className="text-[12px] opacity-70 font-medium">
                              {isCharging ? '正在补能...' : isLocked ? '已锁定' : '待机中'}
                          </span>
                      </div>
                      <h2 className="text-[24px] font-bold tracking-tight">北汽智充 2.0</h2>
                  </div>
                  <div className="bg-white/10 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold border border-white/10">
                      SN: 88293011
                  </div>
              </div>

              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[200px] h-[200px] bg-white/[0.03] rounded-full flex items-center justify-center border border-white/5">
                  <Zap size={64} className={`transition-all duration-700 ${isCharging ? 'text-green-400 fill-green-400 scale-110' : 'text-gray-600'}`} />
                  {isCharging && (
                      <div className="absolute inset-0 border-2 border-green-500 rounded-full animate-spin" style={{animationDuration: '3s', borderTopColor: 'transparent'}} />
                  )}
              </div>

              <div className="relative z-10 grid grid-cols-3 gap-3 bg-white/5 backdrop-blur-xl rounded-2xl p-5 border border-white/10">
                  <StatItem label="实时功率" value={isCharging ? "6.8" : "0.0"} unit="kW" />
                  <StatItem label="今日累计" value={isCharging ? "12.5" : "0"} unit="kWh" />
                  <StatItem label="运行状态" value={isCharging ? "正常" : "良好"} unit="" />
              </div>
          </div>

          {/* Controls - Radius-M (16px) */}
          <div className="grid grid-cols-2 gap-4 mb-6">
              <ControlCard 
                  icon={Power} 
                  label={isCharging ? "停止充电" : "开始充电"} 
                  isActive={isCharging}
                  activeColor="text-green-500"
                  onClick={() => setIsCharging(!isCharging)}
              />
              <ControlCard 
                  icon={Lock} 
                  label={isLocked ? "解锁" : "加锁"} 
                  isActive={isLocked}
                  activeColor="text-orange-500"
                  onClick={() => setIsLocked(!isLocked)}
              />
              <ControlCard icon={Clock} label="预约充电" subLabel="22:00 开始" />
              <ControlCard icon={BarChart3} label="能耗统计" subLabel="本月 245 kWh" />
          </div>

          {/* Shared Management - Radius-M (16px) */}
          <div className="bg-white rounded-2xl p-5 shadow-sm flex items-center justify-between border border-transparent active:bg-gray-50 transition-colors cursor-pointer">
              <div className="flex items-center gap-4">
                  <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-500">
                      <MoreHorizontal size={20} />
                  </div>
                  <div>
                      <div className="text-[15px] font-bold text-[#111]">授权管理</div>
                      <div className="text-[12px] text-gray-400">已授权 2 位家庭成员</div>
                  </div>
              </div>
              <ChevronRight size={18} className="text-gray-300" />
          </div>
      </div>
    </div>
  );
};

const StatItem = ({ label, value, unit }: any) => (
    <div className="flex flex-col items-center">
        <div className="text-[10px] opacity-50 mb-1 font-bold">{label}</div>
        <div className="flex items-baseline gap-0.5">
            <span className="text-[18px] font-bold font-oswald">{value}</span>
            <span className="text-[10px] opacity-60 ml-0.5">{unit}</span>
        </div>
    </div>
);

const ControlCard = ({ icon: Icon, label, subLabel, isActive, activeColor, onClick }: any) => (
    <div 
        onClick={onClick}
        className={`bg-white p-5 rounded-2xl shadow-sm flex flex-col justify-between h-[120px] cursor-pointer active:scale-95 transition-all border-2 ${isActive ? 'border-[#111] shadow-md' : 'border-transparent'}`}
    >
        <div className={`w-10 h-10 rounded-full flex items-center justify-center ${isActive ? 'bg-[#111] text-white' : 'bg-gray-50 text-gray-400'}`}>
            <Icon size={20} />
        </div>
        <div>
            <div className={`text-[14px] font-bold ${isActive ? activeColor : 'text-[#111]'}`}>{label}</div>
            {subLabel && <div className="text-[10px] text-gray-400 mt-1">{subLabel}</div>}
        </div>
    </div>
);

export default PrivatePileView;
