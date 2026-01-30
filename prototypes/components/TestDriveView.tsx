import React, { useState } from 'react';
import { 
  ArrowLeft, 
  MapPin, 
  Calendar, 
  User, 
  Phone,
  ChevronRight,
  CheckCircle2
} from 'lucide-react';
import { CarModel } from '../types';

interface TestDriveViewProps {
  car: CarModel;
  onBack: () => void;
}

const TestDriveView: React.FC<TestDriveViewProps> = ({ car, onBack }) => {
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [formData, setFormData] = useState({
      name: '张越野',
      phone: '138****8888',
      city: '北京市',
      dealer: '北京汽车北京朝阳4S店',
      date: '2025-01-15'
  });

  const handleSubmit = () => {
      setTimeout(() => setIsSubmitted(true), 800);
  };

  if (isSubmitted) {
      return (
          <div className="absolute inset-0 z-[100] bg-white flex flex-col items-center justify-center p-8 animate-in zoom-in-95 duration-300">
              <div className="w-20 h-20 bg-green-50 rounded-full flex items-center justify-center mb-6 text-green-500"><CheckCircle2 size={40} /></div>
              <h2 className="text-2xl font-bold text-[#111] mb-2">预约成功</h2>
              <p className="text-[#666] text-center mb-8 leading-relaxed">您的试驾预约已提交。<br/>销售顾问将在 24 小时内与您联系。</p>
              <div className="w-full space-y-3">
                  <button onClick={onBack} className="w-full h-12 rounded-full bg-[#111] text-white font-bold">返回</button>
                  <button className="w-full h-12 rounded-full bg-gray-50 text-[#111] font-bold">查看我的预约</button>
              </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
       <div className="pt-[54px] px-5 pb-3 flex items-center gap-3 bg-white border-b border-gray-100">
          <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors"><ArrowLeft size={24} className="text-[#111]" /></button>
          <div className="text-[17px] font-bold text-[#111]">预约试驾</div>
       </div>

       <div className="flex-1 overflow-y-auto no-scrollbar p-5">
           {/* Radius-M (16px) for car info card */}
           <div className="bg-white rounded-2xl p-4 flex gap-4 shadow-sm mb-6 border border-white">
               <div className="w-[120px] h-[80px] bg-gray-50 rounded-xl overflow-hidden shrink-0">
                   <img src={car.backgroundImage} className="w-full h-full object-cover" />
               </div>
               <div className="flex-1 py-1">
                   <div className="text-[16px] font-bold text-[#111] mb-1">{car.name}</div>
                   <div className="text-[12px] text-gray-500 mb-2">{car.subtitle}</div>
                   <div className="text-[13px] text-[#FF6B00] font-bold">预约有好礼</div>
               </div>
           </div>

           <div className="text-[15px] font-bold text-[#111] mb-4 ml-1">填写预约信息</div>
           
           {/* Radius-L (24px) for the main form section */}
           <div className="bg-white rounded-3xl overflow-hidden shadow-sm border border-white">
               <div className="flex items-center p-5 border-b border-gray-50">
                   <div className="flex items-center gap-3 w-[100px] text-[#666]"><User size={18} /><span className="text-[14px]">姓名</span></div>
                   <input type="text" value={formData.name} onChange={e => setFormData({...formData, name: e.target.value})} className="flex-1 text-[15px] text-[#111] font-medium outline-none" />
               </div>
               <div className="flex items-center p-5 border-b border-gray-50">
                   <div className="flex items-center gap-3 w-[100px] text-[#666]"><Phone size={18} /><span className="text-[14px]">手机号</span></div>
                   <input type="text" value={formData.phone} onChange={e => setFormData({...formData, phone: e.target.value})} className="flex-1 text-[15px] text-[#111] font-medium outline-none" />
                   <button className="text-[11px] font-bold text-[#111] border border-gray-200 px-2 py-1 rounded-lg">发送验证码</button>
               </div>
               <div className="flex items-center p-5 border-b border-gray-50 active:bg-gray-50 cursor-pointer">
                   <div className="flex items-center gap-3 w-[100px] text-[#666]"><MapPin size={18} /><span className="text-[14px]">城市</span></div>
                   <div className="flex-1 text-[15px] text-[#111] font-medium">{formData.city}</div>
                   <ChevronRight size={16} className="text-gray-300" />
               </div>
               <div className="flex items-center p-5 active:bg-gray-50 cursor-pointer">
                   <div className="flex items-center gap-3 w-[100px] text-[#666]"><Calendar size={18} /><span className="text-[14px]">时间</span></div>
                   <div className="flex-1 text-[15px] text-[#111] font-medium">{formData.date} (周三)</div>
                   <ChevronRight size={16} className="text-gray-300" />
               </div>
           </div>

           <div className="mt-6 flex items-start gap-2 px-2">
               <div className="w-4 h-4 rounded-full border border-[#111] mt-0.5 flex items-center justify-center shrink-0"><div className="w-2 h-2 rounded-full bg-[#111]" /></div>
               <div className="text-[11px] text-gray-400 leading-relaxed">我已阅读并同意 <span className="text-[#111] font-bold">《隐私政策》</span> 和 <span className="text-[#111] font-bold">《试驾服务条款》</span>。</div>
           </div>
       </div>

       <div className="p-5 bg-white border-t border-gray-100 pb-[34px]">
           <button onClick={handleSubmit} className="w-full h-12 rounded-full bg-[#111] text-white text-[16px] font-bold shadow-lg shadow-black/20 active:scale-95 transition-transform">立即预约</button>
       </div>
    </div>
  );
};

export default TestDriveView;