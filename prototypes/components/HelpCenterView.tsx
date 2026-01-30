
import React, { useState } from 'react';
import { ArrowLeft, Search, ChevronRight, BookOpen, Truck, Wrench, Headset } from 'lucide-react';
import { CAR_DATA } from '../data';

interface HelpCenterViewProps {
  onBack: () => void;
  onContactService: () => void;
}

const LIFECYCLE_STAGES = [
    { id: 'buy', label: '看车选购', icon: Search },
    { id: 'delivery', label: '新车提取', icon: Truck },
    { id: 'use', label: '用车指南', icon: BookOpen },
    { id: 'service', label: '售后维保', icon: Wrench },
];

const FAQS = {
    buy: [
        'BJ40 不同版本有什么区别？',
        '现在的购车优惠政策有哪些？',
        '如何预约到店试驾？',
        '置换补贴的流程是怎样的？'
    ],
    delivery: [
        '提车时需要带什么证件？',
        '如何激活车联网服务？',
        '新车磨合期需要注意什么？',
        '验车流程及注意事项'
    ],
    use: [
        '如何使用分时四驱系统？',
        '胎压监测报警如何处理？',
        '车机系统如何升级 (OTA)？',
        '定速巡航功能使用说明'
    ],
    service: [
        '保养周期和费用是多少？',
        '道路救援电话是多少？',
        '配件保修政策说明',
        '如何查询附近的维修网点？'
    ]
};

const HelpCenterView: React.FC<HelpCenterViewProps> = ({ onBack, onContactService }) => {
  const [selectedModel, setSelectedModel] = useState('BJ40');
  const [activeStage, setActiveStage] = useState('use');

  const models = Object.keys(CAR_DATA).filter(k => k !== 'WARRIOR');

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      
      {/* 1. Header - 紧凑型顶部 */}
      <div className="pt-[54px] px-5 pb-2 flex justify-between items-center bg-[#F5F7FA] z-20">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-200/50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111] tracking-[0.05em]">帮助中心</div>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar">
          
          {/* 2. Model Selector - 统一使用用户提供的 WebP 图片 */}
          <div className="py-3 overflow-hidden">
              <div className="flex gap-10 overflow-x-auto no-scrollbar px-10 items-end">
                  {models.map(key => {
                      const car = CAR_DATA[key];
                      const isSelected = selectedModel === key;
                      // 统一替换为用户指定的图
                      const displayImg = 'https://i.imgs.ovh/2025/12/23/CpkkOO.webp';
                      
                      return (
                          <div 
                            key={key} 
                            onClick={() => setSelectedModel(key)}
                            className={`shrink-0 flex flex-col items-center gap-3 transition-all duration-700 cursor-pointer ${
                                isSelected ? 'scale-110 opacity-100' : 'scale-90 opacity-20 grayscale'
                            }`}
                          >
                              <img 
                                src={displayImg} 
                                className="h-[45px] object-contain drop-shadow-[0_10px_20px_rgba(0,0,0,0.1)]" 
                                alt={car.name}
                              />
                              <div className="flex flex-col items-center gap-1.5">
                                  <span className={`text-[11px] font-bold tracking-tight transition-colors duration-500 ${isSelected ? 'text-[#111]' : 'text-gray-400'}`}>
                                      {car.name}
                                  </span>
                                  <div className={`h-0.5 rounded-full bg-[#111] transition-all duration-500 ${isSelected ? 'w-4 opacity-100' : 'w-0 opacity-0'}`} />
                              </div>
                          </div>
                      )
                  })}
              </div>
          </div>

          {/* 3. Search Bar */}
          <div className="px-5 mb-4">
              <div className="h-11 bg-white rounded-2xl flex items-center px-5 shadow-[0_4px_15px_rgba(0,0,0,0.02)] border border-white">
                  <Search size={16} className="text-gray-300 mr-3" />
                  <input 
                    type="text" 
                    placeholder={`搜索 ${CAR_DATA[selectedModel].name} 的问题`}
                    className="flex-1 text-[13px] outline-none text-[#111] bg-transparent placeholder:text-gray-300"
                  />
              </div>
          </div>

          {/* 4. Lifecycle Stages */}
          <div className="px-5 mb-6">
              <div className="flex justify-between items-start px-2">
                  {LIFECYCLE_STAGES.map(stage => {
                      const Icon = stage.icon;
                      const isActive = activeStage === stage.id;
                      return (
                          <div 
                            key={stage.id}
                            onClick={() => setActiveStage(stage.id)}
                            className="flex flex-col items-center gap-2.5 cursor-pointer group"
                          >
                              <div className={`w-[52px] h-[52px] rounded-full flex items-center justify-center transition-all duration-500 ${
                                  isActive 
                                    ? 'bg-[#111] text-white shadow-[0_10px_20px_rgba(0,0,0,0.15)] -translate-y-1' 
                                    : 'bg-white text-gray-400 shadow-[0_2px_10px_rgba(0,0,0,0.02)] border border-gray-100'
                              }`}>
                                  <Icon size={24} strokeWidth={1.5} />
                              </div>
                              <span className={`text-[11px] font-bold transition-colors duration-300 ${isActive ? 'text-[#111]' : 'text-gray-400'}`}>
                                  {stage.label}
                              </span>
                          </div>
                      )
                  })}
              </div>
          </div>

          {/* 5. FAQ List */}
          <div className="px-5 pb-40">
              <div className="flex items-center gap-2.5 mb-5 ml-1">
                  <div className="w-1.5 h-4.5 bg-[#111] rounded-full" />
                  <div className="text-[14px] font-bold text-[#111] uppercase tracking-[0.1em]">
                      {LIFECYCLE_STAGES.find(s => s.id === activeStage)?.label}常见问题
                  </div>
              </div>
              
              <div className="bg-white rounded-[32px] overflow-hidden shadow-[0_12px_40px_rgba(0,0,0,0.04)] border border-white">
                  <div className="divide-y divide-gray-50">
                      {(FAQS as any)[activeStage].map((q: string, idx: number) => (
                          <div 
                            key={idx} 
                            className="py-5 px-7 flex justify-between items-center cursor-pointer active:bg-gray-50 transition-all group"
                          >
                              <span className="text-[15px] text-[#333] font-medium leading-snug group-active:text-[#111]">{q}</span>
                              <ChevronRight size={18} className="text-gray-300 shrink-0 transition-transform group-active:translate-x-1" />
                          </div>
                      ))}
                  </div>
              </div>
          </div>
      </div>

      {/* 6. Floating Contact Bar */}
      <div className="absolute bottom-10 left-5 right-5 h-16 bg-[#111] rounded-full shadow-[0_25px_50px_rgba(0,0,0,0.25)] flex items-center justify-between px-7 text-white cursor-pointer active:scale-95 transition-all overflow-hidden border border-white/5" onClick={onContactService}>
          <div className="absolute inset-0 bg-gradient-to-tr from-white/10 to-transparent pointer-events-none" />
          <div className="flex items-center gap-4 relative z-10">
              <div className="w-10 h-10 rounded-full bg-white/15 flex items-center justify-center backdrop-blur-xl border border-white/10">
                  <Headset size={20} /> 
              </div>
              <div className="flex flex-col">
                  <span className="text-[14px] font-bold tracking-tight">寻求人工帮助</span>
                  <span className="text-[10px] opacity-40 uppercase font-bold tracking-widest">Professional Expert</span>
              </div>
          </div>
          <div className="flex items-center gap-1.5 text-[12px] font-bold relative z-10 bg-white/10 px-4 py-1.5 rounded-full border border-white/10">
              立即咨询 <ChevronRight size={14} />
          </div>
      </div>
    </div>
  );
};

export default HelpCenterView;
