import React, { useState } from 'react';
import { ArrowLeft } from 'lucide-react';
import { CarModel } from '../types';

interface CarSpecsViewProps {
  car: CarModel;
  onBack: () => void;
}

const CarSpecsView: React.FC<CarSpecsViewProps> = ({ car, onBack }) => {
  const [activeGroup, setActiveGroup] = useState('动力');

  const specs = {
      '动力': [
          { label: '发动机', value: '2.0T 224马力 L4' },
          { label: '最大功率(kW)', value: '165' },
          { label: '最大扭矩(N·m)', value: '380' },
          { label: '变速箱', value: '8挡手自一体' },
          { label: '0-100km/h(s)', value: '10.5' },
      ],
      '底盘': [
          { label: '驱动方式', value: '前置四驱' },
          { label: '四驱形式', value: '分时四驱' },
          { label: '车体结构', value: '非承载式' },
      ],
      '越野': [
          { label: '接近角(°)', value: '37' },
          { label: '离去角(°)', value: '31' },
          { label: '涉水深度(mm)', value: '750' },
      ]
  };

  return (
    <div className="absolute inset-0 z-[150] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-all"><ArrowLeft size={24} className="text-[#111]" /></button>
        <div className="text-[17px] font-bold text-[#111]">参数配置</div>
        <div className="w-10" />
      </div>

      <div className="flex flex-1 overflow-hidden">
          <div className="w-[90px] bg-[#F5F7FA] overflow-y-auto no-scrollbar">
              {Object.keys(specs).map(group => (
                  <button key={group} onClick={() => setActiveGroup(group)} className={`w-full py-5 text-[13px] font-medium transition-colors relative ${activeGroup === group ? 'bg-white text-[#111] font-bold' : 'text-gray-400'}`}>
                      {group}
                      {activeGroup === group && <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-5 bg-[#111] rounded-r-full" />}
                  </button>
              ))}
          </div>

          <div className="flex-1 overflow-y-auto no-scrollbar p-5">
              <div className="flex justify-between items-center mb-6">
                <h3 className="text-[18px] font-bold text-[#111]">{activeGroup}核心参数</h3>
                <span className="text-[10px] font-bold text-gray-300 uppercase tracking-widest">Specifications</span>
              </div>
              {/* Radius-M (16px) for spec container */}
              <div className="bg-[#F9FAFB] rounded-2xl overflow-hidden border border-gray-50">
                  {(specs as any)[activeGroup].map((item: any, idx: number) => (
                      <div key={idx} className="flex justify-between items-center px-4 py-4 border-b border-gray-100/50 last:border-0">
                          <span className="text-[12px] text-gray-500 font-medium">{item.label}</span>
                          <span className="text-[13px] font-bold text-[#111] text-right">{item.value}</span>
                      </div>
                  ))}
              </div>
          </div>
      </div>
    </div>
  );
};

export default CarSpecsView;