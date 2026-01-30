import React, { useState } from 'react';
import { ArrowLeft, ChevronRight, PieChart, Calculator, RefreshCw } from 'lucide-react';
import { CarModel } from '../types';

interface FinanceCalculatorViewProps {
  car: CarModel;
  onBack: () => void;
}

const FinanceCalculatorView: React.FC<FinanceCalculatorViewProps> = ({ car, onBack }) => {
  const basePrice = parseFloat(car.price) * 10000;
  const [downPaymentRatio, setDownPaymentRatio] = useState(0.3);
  const [term, setTerm] = useState(36);
  const interestRate = 0.04;

  const downPayment = basePrice * downPaymentRatio;
  const loanAmount = basePrice - downPayment;
  const totalInterest = loanAmount * interestRate * (term / 12);
  const monthlyPayment = (loanAmount + totalInterest) / term;

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50"><ArrowLeft size={24} className="text-[#111]" /></button>
        <div className="text-[17px] font-bold text-[#111]">金融计算器</div>
        <div className="w-9" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-10">
          {/* Radius-L (24px) for result card */}
          <div className="m-5 bg-white rounded-3xl p-6 shadow-sm relative overflow-hidden border border-white">
              <div className="flex justify-between items-start mb-6">
                  <div>
                      <div className="text-[12px] text-gray-400 mb-1">预估月供 ({term}期)</div>
                      <div className="flex items-baseline gap-1 text-[#FF6B00]">
                          <span className="text-[16px] font-bold">¥</span>
                          <span className="text-[40px] font-bold font-oswald leading-none">{Math.round(monthlyPayment).toLocaleString()}</span>
                      </div>
                  </div>
                  <div className="w-14 h-14 rounded-full border-[6px] border-[#F5F7FA] relative flex items-center justify-center" style={{ background: `conic-gradient(#FF6B00 0% ${(1-downPaymentRatio)*100}%, #111827 ${(1-downPaymentRatio)*100}% 100%)` }}>
                      <div className="w-8 h-8 bg-white rounded-full flex items-center justify-center text-gray-300"><PieChart size={14} /></div>
                  </div>
              </div>

              {/* Radius-M (16px) for sub-details */}
              <div className="grid grid-cols-2 gap-4 bg-[#F9FAFB] rounded-2xl p-5 border border-gray-50">
                  <div><div className="text-[10px] text-gray-400 mb-1">首付金额</div><div className="text-[15px] font-bold font-oswald">¥{downPayment.toLocaleString()}</div></div>
                  <div><div className="text-[10px] text-gray-400 mb-1">贷款总额</div><div className="text-[15px] font-bold font-oswald">¥{loanAmount.toLocaleString()}</div></div>
                  <div><div className="text-[10px] text-gray-400 mb-1">利息总额</div><div className="text-[15px] font-bold font-oswald">¥{Math.round(totalInterest).toLocaleString()}</div></div>
                  <div><div className="text-[10px] text-gray-400 mb-1">购车总价</div><div className="text-[15px] font-bold font-oswald">¥{(basePrice + totalInterest).toLocaleString()}</div></div>
              </div>
          </div>

          <div className="px-5 space-y-6">
              {/* Radius-M (16px) for input cards */}
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-white">
                  <div className="flex justify-between mb-4"><span className="text-[15px] font-bold text-[#111]">首付比例</span><span className="text-[15px] font-bold text-[#FF6B00] font-oswald">{Math.round(downPaymentRatio * 100)}%</span></div>
                  <input type="range" min="0.1" max="0.9" step="0.1" value={downPaymentRatio} onChange={(e) => setDownPaymentRatio(parseFloat(e.target.value))} className="w-full h-1.5 bg-gray-100 rounded-full appearance-none cursor-pointer accent-[#111]" />
                  <div className="flex justify-between mt-2 text-[10px] text-gray-400 font-medium"><span>10%</span><span>50%</span><span>90%</span></div>
              </div>

              <div className="bg-white rounded-2xl p-5 shadow-sm border border-white">
                  <div className="flex justify-between mb-4"><span className="text-[15px] font-bold text-[#111]">分期期限</span><span className="text-[15px] font-bold text-[#FF6B00] font-oswald">{term}期</span></div>
                  <div className="grid grid-cols-3 gap-3">
                      {[12, 24, 36, 48, 60].map(t => (
                          <button key={t} onClick={() => setTerm(t)} className={`py-2.5 rounded-xl text-[13px] font-bold border-2 transition-all ${term === t ? 'bg-[#111] text-white border-[#111]' : 'bg-white text-gray-500 border-gray-50'}`}>{t}期</button>
                      ))}
                  </div>
              </div>
          </div>
      </div>

      <div className="p-5 bg-white border-t border-gray-100 pb-[34px]">
          <button onClick={onBack} className="w-full h-12 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-lg shadow-black/20 active:scale-95 transition-all">立即申请金融方案</button>
      </div>
    </div>
  );
};

export default FinanceCalculatorView;