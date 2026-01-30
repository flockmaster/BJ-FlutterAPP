
import React, { useState } from 'react';
import { ArrowLeft, Ticket } from 'lucide-react';

interface MyCouponsViewProps {
  onBack: () => void;
}

const COUPONS = [
    { id: 1, type: 'discount', amount: '50', unit: '元', title: '商城通用立减券', sub: '满 200 元可用', expiry: '2024.02.28', status: 'valid' },
    { id: 2, type: 'service', amount: '8.8', unit: '折', title: '保养工时费折扣券', sub: '全国4S店通用', expiry: '2024.06.30', status: 'valid' },
    { id: 3, type: 'charging', amount: '20', unit: '度', title: '免费充电额度', sub: '仅限自营充电站', expiry: '2024.01.31', status: 'valid' },
    { id: 4, type: 'discount', amount: '100', unit: '元', title: '新人专享券', sub: '无门槛', expiry: '2023.12.31', status: 'expired' },
];

const MyCouponsView: React.FC<MyCouponsViewProps> = ({ onBack }) => {
  const [activeTab, setActiveTab] = useState<'valid' | 'expired'>('valid');

  const filteredCoupons = COUPONS.filter(c => 
      activeTab === 'valid' ? c.status === 'valid' : c.status === 'expired'
  );

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">我的卡券</div>
        <div className="w-9" />
      </div>

      <div className="flex gap-8 px-5 pt-4 pb-2 bg-[#F5F7FA]">
          {['valid', 'expired'].map((tab) => (
              <button 
                key={tab}
                onClick={() => setActiveTab(tab as any)}
                className={`text-[14px] font-bold transition-colors ${
                    activeTab === tab ? 'text-[#111]' : 'text-gray-400'
                }`}
              >
                  {tab === 'valid' ? '未使用' : '已失效'}
              </button>
          ))}
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-4">
          {filteredCoupons.map(coupon => (
              <div 
                key={coupon.id} 
                className={`relative h-[100px] flex overflow-hidden rounded-xl shadow-sm ${
                    coupon.status === 'valid' ? 'bg-white' : 'bg-gray-100 opacity-70'
                }`}
              >
                  {/* Left Side (Amount) */}
                  <div className={`w-[100px] flex flex-col items-center justify-center text-white ${
                      coupon.status === 'valid' 
                        ? (coupon.type === 'discount' ? 'bg-[#FF6B00]' : coupon.type === 'service' ? 'bg-[#111]' : 'bg-[#00B894]') 
                        : 'bg-gray-400'
                  }`}>
                      <div className="flex items-baseline font-oswald font-bold">
                          <span className="text-[32px]">{coupon.amount}</span>
                          <span className="text-[14px] ml-0.5">{coupon.unit}</span>
                      </div>
                      <div className="text-[10px] opacity-80">{coupon.type === 'discount' ? '代金券' : coupon.type === 'service' ? '折扣券' : '兑换券'}</div>
                  </div>

                  {/* Right Side (Info) */}
                  <div className="flex-1 p-4 flex flex-col justify-between relative">
                      <div>
                          <div className="text-[15px] font-bold text-[#111] mb-1">{coupon.title}</div>
                          <div className="text-[11px] text-gray-500">{coupon.sub}</div>
                      </div>
                      <div className="text-[10px] text-gray-400 font-oswald border-t border-gray-100 pt-2 w-full">
                          有效期至 {coupon.expiry}
                      </div>

                      {/* Ticket Punch Circles */}
                      <div className="absolute -left-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-[#F5F7FA] rounded-full" />
                      
                      {coupon.status === 'valid' && (
                          <button className="absolute right-4 top-1/2 -translate-y-1/2 bg-[#FF6B00] text-white text-[11px] font-bold px-3 py-1 rounded-full shadow-md active:scale-95">
                              去使用
                          </button>
                      )}
                  </div>
              </div>
          ))}

          {filteredCoupons.length === 0 && (
              <div className="flex flex-col items-center justify-center py-20 text-gray-400">
                  <Ticket size={48} className="mb-2 opacity-50" />
                  <span className="text-[12px]">暂无卡券</span>
              </div>
          )}
      </div>
    </div>
  );
};

export default MyCouponsView;
