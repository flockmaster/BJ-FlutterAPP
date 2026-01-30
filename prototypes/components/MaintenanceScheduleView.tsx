
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Calendar, 
  MapPin, 
  Clock, 
  ChevronRight, 
  Package,
  Info,
  Check
} from 'lucide-react';

interface MaintenanceScheduleViewProps {
  onBack: () => void;
}

const PACKAGES = [
    { id: 'A', name: 'A类基础保养', price: 580, items: ['更换机油', '更换机滤', '全车检查'], recommend: true },
    { id: 'B', name: 'B类深度保养', price: 1280, items: ['更换机油机滤', '更换空气滤芯', '更换空调滤芯', '制动液检查'] },
];

const TIME_SLOTS = ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'];

const MaintenanceScheduleView: React.FC<MaintenanceScheduleViewProps> = ({ onBack }) => {
  const [selectedPackage, setSelectedPackage] = useState(PACKAGES[0]);
  const [selectedDate, setSelectedDate] = useState('2025-01-20');
  const [selectedTime, setSelectedTime] = useState('10:00');

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
        {/* Header - V3.1 Standard */}
        <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100/50">
            <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-all active:scale-90">
                <ArrowLeft size={24} className="text-[#111]" />
            </button>
            <div className="text-[17px] font-bold text-[#111]">预约保养</div>
            <div className="w-10" />
        </div>

        <div className="flex-1 overflow-y-auto no-scrollbar p-5 pb-32">
            {/* Car Info Card - Radius-M (16px) */}
            <div className="bg-white rounded-2xl p-4 flex items-center gap-4 shadow-[0_2px_14px_rgba(0,0,0,0.04)] mb-5 border border-white">
                <div className="w-20 h-14 bg-[#F5F7FA] rounded-xl flex items-center justify-center p-2 overflow-hidden">
                    <img 
                      src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" 
                      className="w-full h-full object-cover mix-blend-multiply" 
                      alt="BJ40"
                    />
                </div>
                <div>
                    <div className="text-[15px] font-bold text-[#111] mb-0.5">北京BJ40 PLUS</div>
                    <div className="text-[12px] text-gray-500 font-oswald">京A·12345 · <span className="text-gray-400">行驶 8,521 km</span></div>
                </div>
            </div>

            {/* Package Selection */}
            <div className="mb-6">
                <div className="text-[15px] font-bold text-[#111] mb-3 ml-1 flex items-center justify-between">
                    <div className="flex items-center gap-2">选择保养套餐 <Info size={14} className="text-gray-300" /></div>
                    <span className="text-[11px] text-gray-400 font-medium">查看项目详情</span>
                </div>
                <div className="space-y-3">
                    {PACKAGES.map(pkg => (
                        <div 
                            key={pkg.id}
                            onClick={() => setSelectedPackage(pkg)}
                            className={`rounded-2xl p-5 border-2 transition-all cursor-pointer relative active:scale-[0.98] ${
                                selectedPackage.id === pkg.id 
                                    ? 'bg-white border-[#111] shadow-[0_8px_20px_rgba(0,0,0,0.06)]' 
                                    : 'bg-white border-transparent shadow-[0_2px_14px_rgba(0,0,0,0.04)]'
                            }`}
                        >
                            <div className="flex justify-between items-start mb-3">
                                <div>
                                    <div className="text-[16px] font-bold text-[#111] mb-1">{pkg.name}</div>
                                    <div className="text-[12px] text-gray-400 leading-relaxed">{pkg.items.join(' + ')}</div>
                                </div>
                                <div className="text-right">
                                    <div className="text-[20px] font-bold font-oswald text-[#FF6B00]">¥{pkg.price}</div>
                                    {pkg.recommend && (
                                        <div className="text-[10px] text-white bg-[#FF6B00] px-2 py-0.5 rounded-md mt-1 inline-block font-bold">推荐</div>
                                    )}
                                </div>
                            </div>
                            {selectedPackage.id === pkg.id && (
                                <div className="absolute top-0 right-0 bg-[#111] text-white w-7 h-7 rounded-bl-2xl rounded-tr-2xl flex items-center justify-center shadow-sm">
                                    <Check size={14} strokeWidth={3} />
                                </div>
                            )}
                        </div>
                    ))}
                </div>
            </div>

            {/* Dealer Card - Radius-M (16px) */}
            <div className="bg-white rounded-2xl p-5 shadow-[0_2px_14px_rgba(0,0,0,0.04)] mb-5 border border-white active:bg-gray-50 transition-colors cursor-pointer">
                <div className="flex justify-between items-center mb-4">
                    <div className="text-[15px] font-bold text-[#111]">服务门店</div>
                    <div className="text-[12px] text-gray-400 flex items-center font-medium">
                        更换门店 <ChevronRight size={14} className="ml-0.5" />
                    </div>
                </div>
                <div className="flex items-start gap-4">
                    <div className="w-11 h-11 bg-[#F5F7FA] rounded-full flex items-center justify-center shrink-0 text-[#111]">
                        <MapPin size={22} strokeWidth={1.5} />
                    </div>
                    <div>
                        <div className="text-[15px] font-bold text-[#111] mb-1.5 line-clamp-1">北京汽车越野4S店（朝阳）</div>
                        <div className="text-[12px] text-gray-400 mb-3">北京市朝阳区建国路88号</div>
                        <div className="flex gap-2">
                            <span className="text-[10px] bg-green-50 text-green-600 px-2 py-0.5 rounded-md font-bold">官方直营</span>
                            <span className="text-[10px] bg-[#F5F7FA] text-gray-500 px-2 py-0.5 rounded-md font-medium">距您 <span className="font-oswald">2.3</span>km</span>
                        </div>
                    </div>
                </div>
            </div>

            {/* Time Selection - Radius-M (16px) */}
            <div className="bg-white rounded-2xl p-5 shadow-[0_2px_14px_rgba(0,0,0,0.04)] mb-5 border border-white">
                <div className="text-[15px] font-bold text-[#111] mb-5 flex items-center gap-2">
                    <Calendar size={18} className="text-gray-400" /> 到店时间
                </div>
                
                {/* Date Scroller */}
                <div className="flex overflow-x-auto no-scrollbar gap-3 mb-6 pb-1">
                    {[0,1,2,3,4,5,6].map(i => {
                        const d = new Date();
                        d.setDate(d.getDate() + i + 1);
                        const dateStr = `${d.getMonth()+1}-${d.getDate()}`;
                        const dayStr = ['周日','周一','周二','周三','周四','周五','周六'][d.getDay()];
                        const isSelected = i === 0; 
                        
                        return (
                            <button 
                                key={i}
                                className={`flex flex-col items-center justify-center w-[64px] h-[74px] rounded-xl border-2 transition-all shrink-0 active:scale-95 ${
                                    isSelected 
                                      ? 'bg-[#111] border-[#111] text-white shadow-lg shadow-black/10' 
                                      : 'bg-[#F9FAFB] border-transparent text-gray-400 hover:bg-gray-100'
                                }`}
                            >
                                <span className={`text-[11px] font-medium mb-1.5 ${isSelected ? 'text-white/60' : 'text-gray-400'}`}>{dayStr}</span>
                                <span className="text-[15px] font-bold font-oswald tracking-tight">{dateStr}</span>
                            </button>
                        )
                    })}
                </div>

                {/* Time Slots */}
                <div className="grid grid-cols-3 gap-3">
                    {TIME_SLOTS.map(t => (
                        <button
                            key={t}
                            onClick={() => setSelectedTime(t)}
                            className={`py-2.5 rounded-lg text-[13px] font-bold border-2 transition-all active:scale-95 ${
                                selectedTime === t 
                                    ? 'border-[#111] text-[#111] bg-gray-50' 
                                    : 'border-transparent bg-[#F9FAFB] text-gray-500'
                            }`}
                        >
                            {t}
                        </button>
                    ))}
                </div>
            </div>
        </div>

        {/* Footer - Immersive Glass Style */}
        <div className="absolute bottom-0 left-0 right-0 bg-white/90 backdrop-blur-xl border-t border-gray-100/50 px-6 pt-3 pb-[34px] shadow-[0_-4px_24px_rgba(0,0,0,0.04)] flex justify-between items-center z-20">
            <div>
                <div className="text-[11px] text-gray-400 mb-0.5 font-medium">预计费用 (含工时)</div>
                <div className="flex items-baseline gap-1 text-[#FF6B00]">
                    <span className="text-[14px] font-bold">¥</span>
                    <span className="text-[28px] font-bold font-oswald leading-none">{selectedPackage.price}</span>
                </div>
            </div>
            <button 
                onClick={() => alert('预约成功！系统已为您锁定工位。')}
                className="h-12 px-10 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-xl shadow-black/20 active:scale-95 transition-all"
            >
                确认预约
            </button>
        </div>
    </div>
  );
};

export default MaintenanceScheduleView;
