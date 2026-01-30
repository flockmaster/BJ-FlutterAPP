
import React, { useState } from 'react';
import { ArrowLeft, Car, Check, Search, ChevronRight, Calculator, RefreshCw, Loader2 } from 'lucide-react';

interface UsedCarValuationViewProps {
  onBack: () => void;
}

const UsedCarValuationView: React.FC<UsedCarValuationViewProps> = ({ onBack }) => {
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
      {/* Header - V3.1 Standard */}
      <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 active:scale-90 transition-all">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">爱车评估</div>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5">
          {step === 'form' ? (
              <div className="space-y-6">
                  {/* Main Form Container - Radius-L+ (32px) */}
                  <div className="bg-white rounded-[32px] p-7 shadow-[0_4px_24px_rgba(0,0,0,0.04)] border border-white">
                      <div className="flex items-center gap-3 mb-8">
                          <div className="w-11 h-11 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center">
                              <Calculator size={22} strokeWidth={1.5} />
                          </div>
                          <div>
                            <h2 className="text-[18px] font-bold text-[#111]">免费评估您的爱车</h2>
                            <p className="text-[11px] text-gray-400 mt-0.5">大数据精准报价 · 官方认证回收</p>
                          </div>
                      </div>
                      
                      {/* Brand Select - Radius-M (16px) */}
                      <div className="mb-8">
                          <label className="text-[13px] font-bold text-gray-400 mb-3 block ml-1">品牌型号</label>
                          <div className="grid grid-cols-4 gap-3 mb-4">
                              {['大众', '丰田', '本田', '北京'].map(brand => (
                                  <button 
                                    key={brand}
                                    onClick={() => setFormData({...formData, brand})}
                                    className={`py-2.5 rounded-xl text-[14px] font-medium border-2 transition-all active:scale-95 ${
                                        formData.brand === brand 
                                            ? 'bg-[#111] text-white border-[#111] shadow-lg shadow-black/10' 
                                            : 'bg-gray-50 text-gray-500 border-transparent hover:border-gray-200'
                                    }`}
                                  >
                                      {brand}
                                  </button>
                              ))}
                          </div>
                          <div className="flex items-center bg-[#F9FAFB] rounded-2xl px-5 py-4 text-gray-400 text-[14px] border border-gray-50 active:bg-gray-100 transition-colors cursor-pointer">
                              <Search size={16} className="mr-3" /> 搜索其他品牌车型
                          </div>
                      </div>

                      {/* Year Selection */}
                      <div className="mb-8">
                          <label className="text-[13px] font-bold text-gray-400 mb-3 block ml-1">上牌年份</label>
                          <div className="flex gap-3 overflow-x-auto no-scrollbar pb-1">
                              {['2023', '2022', '2021', '2020', '2019'].map(year => (
                                  <button
                                    key={year}
                                    onClick={() => setFormData({...formData, year})}
                                    className={`px-6 py-2.5 rounded-xl text-[15px] font-oswald font-bold border-2 transition-all whitespace-nowrap active:scale-95 ${
                                        formData.year === year 
                                            ? 'bg-[#111] text-white border-[#111] shadow-lg' 
                                            : 'bg-white text-[#333] border-gray-100'
                                    }`}
                                  >
                                      {year}
                                  </button>
                              ))}
                          </div>
                      </div>

                      {/* Mileage Input */}
                      <div className="mb-2">
                          <label className="text-[13px] font-bold text-gray-400 mb-3 block ml-1">行驶里程</label>
                          <div className="relative">
                              <input 
                                  type="number" 
                                  placeholder="0.0"
                                  value={formData.mileage}
                                  onChange={e => setFormData({...formData, mileage: e.target.value})}
                                  className="w-full bg-[#F9FAFB] rounded-2xl px-5 py-4 text-[18px] font-bold outline-none border-2 border-transparent focus:border-[#111] focus:bg-white transition-all font-oswald"
                              />
                              <span className="absolute right-5 top-1/2 -translate-y-1/2 text-[14px] text-gray-400 font-bold">万公里</span>
                          </div>
                      </div>
                  </div>

                  <button 
                    onClick={handleEstimate}
                    disabled={loading || !formData.brand || !formData.year}
                    className="w-full h-14 rounded-2xl bg-[#111] text-white text-[16px] font-bold shadow-xl shadow-black/10 active:scale-[0.97] flex items-center justify-center gap-3 transition-all disabled:opacity-40"
                  >
                      {loading ? <Loader2 size={20} className="animate-spin" /> : <RefreshCw size={20} />}
                      {loading ? '正在评估中...' : '开始免费计算'}
                  </button>
              </div>
          ) : (
              <div className="animate-in fade-in slide-in-from-bottom duration-500">
                  {/* Result Card - Radius-L+ (32px) */}
                  <div className="bg-white rounded-[32px] p-8 shadow-[0_10px_40px_rgba(0,0,0,0.06)] text-center mb-6 relative overflow-hidden border border-white">
                      <div className="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-[#FF6B00] to-[#FFD700]" />
                      <div className="text-[13px] text-gray-400 mb-2 font-medium">预计车主成交价</div>
                      <div className="flex justify-center items-baseline gap-1 text-[#FF6B00] mb-6">
                          <span className="text-[20px] font-bold">¥</span>
                          <span className="text-[52px] font-bold font-oswald tracking-tight leading-none">8.5 - 9.2</span>
                          <span className="text-[16px] font-bold ml-1">万</span>
                      </div>
                      
                      <div className="bg-[#F9FAFB] rounded-2xl p-5 flex justify-between items-center text-left border border-gray-50">
                          <div>
                              <div className="text-[15px] font-bold text-[#111] mb-1">{formData.brand} 某热门车型</div>
                              <div className="text-[12px] text-gray-400 font-medium font-oswald">{formData.year}年 · {formData.mileage || 5}万公里</div>
                          </div>
                          <button onClick={() => setStep('form')} className="text-[13px] text-[#FF6B00] font-bold bg-orange-50 px-3 py-1.5 rounded-lg active:scale-95 transition-transform">
                              重新测试
                          </button>
                      </div>
                  </div>

                  {/* Highlights Grid */}
                  <div className="grid grid-cols-2 gap-4 mb-8">
                      <HighlightItem icon={Check} label="官方上门评估" sub="省时省力" />
                      <HighlightItem icon={Check} label="三方比价保证" sub="拒绝压价" />
                  </div>
                  
                  <button className="w-full h-14 rounded-2xl bg-[#FF6B00] text-white text-[16px] font-bold shadow-xl shadow-orange-200 active:scale-[0.97] transition-all">
                      预约高价卖车
                  </button>
                  <p className="text-center text-[12px] text-gray-400 mt-5 leading-relaxed">
                      * 评估结果基于市场大数据分析，实际价格请以实车评估为准
                  </p>
              </div>
          )}
      </div>
    </div>
  );
};

const HighlightItem = ({ icon: Icon, label, sub }: any) => (
    <div className="bg-white p-4 rounded-2xl border border-gray-50 shadow-sm flex flex-col gap-2">
        <div className="w-8 h-8 rounded-full bg-green-50 flex items-center justify-center text-green-600">
            <Icon size={16} strokeWidth={3} />
        </div>
        <div>
            <div className="text-[13px] font-bold text-[#111]">{label}</div>
            <div className="text-[11px] text-gray-400">{sub}</div>
        </div>
    </div>
);

export default UsedCarValuationView;
