import React, { useState } from 'react';
import { ArrowLeft, Car, Calendar, Gauge, Check, Search, ChevronRight, Loader2 } from 'lucide-react';

interface TradeInViewProps {
  onBack: () => void;
}

const BRANDS = ['大众', '丰田', '本田', '北京', '别克', '福特', '吉利', '长安'];

const TradeInView: React.FC<TradeInViewProps> = ({ onBack }) => {
  const [step, setStep] = useState<'form' | 'result'>('form');
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({ brand: '', year: '', mileage: '' });

  const handleEstimate = () => {
      setLoading(true);
      setTimeout(() => {
          setLoading(false);
          setStep('result');
      }, 1500);
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-all"><ArrowLeft size={24} className="text-[#111]" /></button>
        <div className="text-[17px] font-bold text-[#111]">置换估值</div>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5">
          {step === 'form' ? (
              <div className="space-y-6">
                  {/* Radius-L (24px) for major form card */}
                  <div className="bg-white rounded-3xl p-6 shadow-sm border border-white">
                      <h2 className="text-[20px] font-bold text-[#111] mb-6">您的爱车目前价值多少？</h2>
                      <div className="mb-6">
                          <label className="text-[12px] font-bold text-gray-400 mb-3 block">品牌型号</label>
                          <div className="grid grid-cols-4 gap-3 mb-4">
                              {BRANDS.map(brand => (
                                  /* Radius-M (16px) for brand options */
                                  <button key={brand} onClick={() => setFormData({...formData, brand})} className={`py-2 rounded-xl text-[13px] border-2 transition-all ${formData.brand === brand ? 'bg-[#111] text-white border-[#111] shadow-md' : 'bg-gray-50 text-gray-500 border-transparent'}`}>{brand}</button>
                              ))}
                          </div>
                      </div>
                      <div className="mb-6">
                          <label className="text-[12px] font-bold text-gray-400 mb-3 block">上牌年份</label>
                          <div className="flex gap-3 overflow-x-auto no-scrollbar pb-1">
                              {['2023', '2022', '2021', '2020', '2019'].map(year => (
                                  <button key={year} onClick={() => setFormData({...formData, year})} className={`px-5 py-2 rounded-xl text-[14px] font-oswald font-bold border-2 transition-all ${formData.year === year ? 'bg-[#111] text-white border-[#111]' : 'bg-white border-gray-100 text-[#333]'}`}>{year}</button>
                              ))}
                          </div>
                      </div>
                      <div className="mb-2">
                          <label className="text-[12px] font-bold text-gray-400 mb-3 block">行驶里程 (万公里)</label>
                          <input type="number" placeholder="0.0" value={formData.mileage} onChange={e => setFormData({...formData, mileage: e.target.value})} className="w-full bg-gray-50 rounded-2xl px-4 py-3 text-[18px] font-bold outline-none border-2 border-transparent focus:border-[#111] transition-all" />
                      </div>
                  </div>
                  <button onClick={handleEstimate} disabled={!formData.brand || !formData.year || loading} className="w-full h-14 rounded-full bg-[#111] text-white font-bold shadow-lg disabled:opacity-40 active:scale-95 transition-all flex items-center justify-center gap-2">{loading ? <Loader2 size={18} className="animate-spin" /> : '开始极速估值'} {!loading && <ChevronRight size={18} />}</button>
              </div>
          ) : (
              <div className="animate-in fade-in slide-in-from-bottom duration-500">
                  {/* Radius-L (24px) for result display */}
                  <div className="bg-white rounded-3xl p-8 shadow-lg text-center mb-6 relative overflow-hidden border border-white">
                      <div className="absolute top-0 left-0 w-full h-2 bg-[#FF6B00]" />
                      <div className="text-[13px] text-gray-400 mb-2 font-medium">预计置换抵扣金额</div>
                      <div className="flex justify-center items-baseline gap-1 text-[#FF6B00] mb-6">
                          <span className="text-[20px] font-bold">¥</span>
                          <span className="text-[48px] font-bold font-oswald tracking-tight">8.5 - 9.2</span>
                          <span className="text-[16px] font-bold ml-1">万</span>
                      </div>
                      {/* Radius-M (16px) for details sub-card */}
                      <div className="bg-[#F9FAFB] rounded-2xl p-5 flex justify-between items-center text-left border border-gray-50">
                          <div><div className="text-[15px] font-bold text-[#111]">{formData.brand} 热门车型</div><div className="text-[12px] text-gray-400 font-medium">{formData.year}年 · {formData.mileage || 5}万公里</div></div>
                          <button onClick={() => setStep('form')} className="text-[12px] text-[#FF6B00] font-bold bg-orange-50 px-3 py-1.5 rounded-lg">重测</button>
                      </div>
                  </div>
                  <div className="bg-[#111] rounded-3xl p-6 text-white mb-8 shadow-xl">
                      <div className="flex items-center gap-3 mb-5"><div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center text-[#FF6B00]"><Car size={20} /></div><div className="text-[16px] font-bold">本月置换权益</div></div>
                      <div className="space-y-4">
                          <div className="flex items-start gap-3"><Check size={18} className="text-[#FF6B00] shrink-0" /><p className="text-[14px] leading-relaxed">最高享 <span className="text-[#FF6B00] font-bold font-oswald text-[18px]">12,000</span> 元现金直补</p></div>
                          <div className="flex items-start gap-3"><Check size={18} className="text-[#FF6B00] shrink-0" /><p className="text-[14px] leading-relaxed">免费官方上门检测，10分钟出价</p></div>
                      </div>
                  </div>
                  <button className="w-full h-14 rounded-full bg-[#FF6B00] text-white text-[16px] font-bold shadow-lg shadow-orange-200 active:scale-95 transition-all">立即预约高价卖车</button>
              </div>
          )}
      </div>
    </div>
  );
};

export default TradeInView;