
import React, { useState } from 'react';
import { ArrowLeft, Filter, Zap, ChevronRight } from 'lucide-react';

interface ChargingOrdersViewProps {
  onBack: () => void;
}

const ORDERS = [
    { id: 1, station: '北京汽车超级充电站(朝阳)', time: '2024-01-12 18:30', amount: '45.2', cost: '54.24', status: '已完成' },
    { id: 2, station: '国家电网公共充电站', time: '2024-01-08 12:15', amount: '32.5', cost: '48.75', status: '已完成' },
    { id: 3, station: '特来电充电站(SOHO)', time: '2024-01-01 09:00', amount: '50.0', cost: '75.00', status: '已完成' },
    { id: 4, station: '私人充电桩', time: '2023-12-28 22:00', amount: '42.0', cost: '12.60', status: '已完成', isHome: true },
];

const ChargingOrdersView: React.FC<ChargingOrdersViewProps> = ({ onBack }) => {
  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">充电订单</div>
        <button className="w-10 h-10 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <Filter size={20} className="text-[#111]" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-4">
          {ORDERS.map(order => (
              <div 
                key={order.id} 
                className="bg-white rounded-2xl p-5 shadow-[0_2px_14px_rgba(0,0,0,0.04)] border border-transparent hover:border-gray-100 active:scale-[0.99] transition-all cursor-pointer"
              >
                  <div className="flex justify-between items-start mb-4 border-b border-gray-50 pb-3">
                      <div className="flex items-center gap-3">
                          <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${order.isHome ? 'bg-blue-50 text-blue-500' : 'bg-orange-50 text-[#FF6B00]'}`}>
                              <Zap size={16} fill="currentColor" />
                          </div>
                          <div>
                              <div className="text-[14px] font-bold text-[#111] line-clamp-1">{order.station}</div>
                              <div className="text-[11px] text-gray-400 font-oswald">{order.time}</div>
                          </div>
                      </div>
                      <span className="text-[11px] text-gray-400 font-bold bg-gray-50 px-2 py-0.5 rounded">{order.status}</span>
                  </div>
                  
                  <div className="flex justify-between items-center">
                      <div className="flex flex-col">
                          <span className="text-[10px] text-gray-400 mb-0.5">充电电量</span>
                          <span className="text-[16px] font-bold text-[#111] font-oswald">{order.amount} <span className="text-[11px] font-normal text-gray-400">kWh</span></span>
                      </div>
                      <div className="flex flex-col items-end">
                          <span className="text-[10px] text-gray-400 mb-0.5">支付金额</span>
                          <span className="text-[18px] font-bold text-[#FF6B00] font-oswald">¥{order.cost}</span>
                      </div>
                  </div>
              </div>
          ))}
          
          <div className="text-center text-[10px] text-gray-300 py-6 font-oswald tracking-[0.2em]">
              没有更多订单了
          </div>
      </div>
    </div>
  );
};

export default ChargingOrdersView;
