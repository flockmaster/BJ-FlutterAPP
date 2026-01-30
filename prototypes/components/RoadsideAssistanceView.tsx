
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Phone, 
  MapPin, 
  AlertTriangle, 
  Car, 
  BatteryCharging, 
  Wrench,
  Clock,
  CheckCircle2,
  Navigation,
  Headset
} from 'lucide-react';

interface RoadsideAssistanceViewProps {
  onBack: () => void;
}

const RoadsideAssistanceView: React.FC<RoadsideAssistanceViewProps> = ({ onBack }) => {
  const [status, setStatus] = useState<'idle' | 'requesting' | 'en_route'>('idle');

  const handleRequest = () => {
    setStatus('requesting');
    setTimeout(() => {
        setStatus('en_route');
    }, 2000);
  };

  return (
    <div className="absolute inset-0 z-[100] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* Background Map Simulation */}
      <div className="absolute inset-0 bg-gray-200 z-0">
          <div 
            className="absolute inset-0 bg-cover bg-center grayscale-[0.2]" 
            style={{backgroundImage: 'url(https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=1000&auto=format&fit=crop)'}}
          />
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 flex flex-col items-center">
              <div className="w-16 h-16 bg-blue-500/20 rounded-full flex items-center justify-center animate-pulse">
                  <div className="w-4 h-4 bg-blue-500 border-2 border-white rounded-full shadow-lg"></div>
              </div>
          </div>
      </div>

      {/* Header - V3.1 Adaptive */}
      <div className="absolute top-0 left-0 right-0 z-10 pt-[54px] px-5 pb-3 flex justify-between items-center pointer-events-none">
          <button 
            onClick={onBack} 
            className="w-10 h-10 -ml-2 rounded-full bg-white/90 backdrop-blur-md shadow-sm flex items-center justify-center pointer-events-auto active:scale-90 transition-transform text-[#111] border border-white/20"
          >
              <ArrowLeft size={22} />
          </button>
          <div className="bg-white/90 backdrop-blur-md px-5 py-2 rounded-full text-[14px] font-bold shadow-sm border border-white/20">
              道路救援
          </div>
          <button className="w-10 h-10 -mr-2 rounded-full bg-white/90 backdrop-blur-md shadow-sm flex items-center justify-center pointer-events-auto active:scale-90 transition-transform text-[#111] border border-white/20">
              <Headset size={20} />
          </button>
      </div>

      {/* Bottom Panel - Radius-L+ (32px) */}
      <div className="absolute bottom-0 left-0 right-0 z-20 p-4 pb-[40px]">
          {status === 'idle' && (
              <div className="bg-white rounded-[32px] p-7 shadow-[0_10px_50px_rgba(0,0,0,0.15)] animate-in slide-in-from-bottom duration-500">
                  <div className="w-12 h-1.5 bg-gray-100 rounded-full mx-auto mb-6" />
                  <h2 className="text-[22px] font-bold text-[#111] mb-6">您需要什么帮助？</h2>
                  
                  <div className="grid grid-cols-3 gap-3 mb-8">
                      <RescueOption icon={AlertTriangle} label="故障拖车" />
                      <RescueOption icon={BatteryCharging} label="电瓶搭电" />
                      <RescueOption icon={Car} label="更换备胎" />
                  </div>

                  <div className="bg-[#F9FAFB] rounded-2xl p-4 mb-8 flex items-start gap-3 border border-gray-50">
                      <MapPin size={18} className="text-[#9CA3AF] mt-0.5 shrink-0" />
                      <div>
                          <div className="text-[14px] font-bold text-[#111] mb-1">当前位置</div>
                          <div className="text-[13px] text-[#6B7280] leading-snug">北京市朝阳区建国路88号 SOHO现代城附近</div>
                      </div>
                  </div>

                  <button 
                    onClick={handleRequest}
                    className="w-full h-14 rounded-2xl bg-[#111] text-white text-[16px] font-bold shadow-xl shadow-black/10 active:scale-[0.97] transition-all flex items-center justify-center gap-3"
                  >
                      <AlertTriangle size={20} /> 立即呼叫救援
                  </button>
              </div>
          )}

          {status === 'requesting' && (
              <div className="bg-white rounded-[32px] p-12 shadow-2xl text-center animate-in zoom-in duration-300">
                  <div className="w-16 h-16 border-[5px] border-orange-50 border-t-[#FF6B00] rounded-full animate-spin mx-auto mb-6" />
                  <h3 className="text-[19px] font-bold text-[#111] mb-2">正在匹配救援力量...</h3>
                  <p className="text-[#6B7280] text-[14px]">系统正在调度距离您最近的服务网点</p>
              </div>
          )}

          {status === 'en_route' && (
              <div className="bg-white rounded-[32px] p-7 shadow-2xl animate-in slide-in-from-bottom duration-500">
                  <div className="flex justify-between items-center mb-6 pb-6 border-b border-gray-50">
                      <div>
                          <div className="text-[19px] font-bold text-[#111] flex items-center gap-2">
                              救援车已出发
                          </div>
                          <div className="text-[13px] text-gray-400 mt-1.5 flex items-center gap-1.5">
                              预计 <span className="text-[#FF6B00] font-bold font-oswald text-[24px] leading-none mx-0.5">15</span> 分钟内到达
                          </div>
                      </div>
                      <div className="w-12 h-12 bg-green-50 rounded-2xl flex items-center justify-center text-green-600">
                          <Navigation size={26} />
                      </div>
                  </div>

                  <div className="flex items-center gap-4 mb-8">
                      <img src="https://randomuser.me/api/portraits/men/32.jpg" className="w-14 h-14 rounded-2xl object-cover shadow-sm" />
                      <div className="flex-1">
                          <div className="text-[16px] font-bold text-[#111]">王师傅</div>
                          <div className="text-[12px] text-gray-400 mt-0.5">京A·9527 救援专车 · 4.9分</div>
                      </div>
                      <button className="w-11 h-11 rounded-full bg-[#111] flex items-center justify-center text-white active:scale-90 transition-transform">
                          <Phone size={20} />
                      </button>
                  </div>

                  <div className="flex gap-3">
                      <button onClick={() => setStatus('idle')} className="flex-1 py-3.5 rounded-2xl bg-gray-50 text-gray-500 text-[14px] font-bold active:bg-gray-100">取消订单</button>
                      <button className="flex-1 py-3.5 rounded-2xl bg-orange-50 text-[#FF6B00] text-[14px] font-bold active:bg-orange-100">联系专员</button>
                  </div>
              </div>
          )}
      </div>
    </div>
  );
};

const RescueOption: React.FC<{ icon: any, label: string }> = ({ icon: Icon, label }) => (
    <div className="flex flex-col items-center gap-3 p-4 rounded-2xl border border-gray-100 bg-[#F9FAFB] cursor-pointer active:border-[#111] active:bg-white active:shadow-md transition-all group">
        <Icon size={26} className="text-[#111] group-active:scale-110 transition-transform" strokeWidth={1.5} />
        <span className="text-[12px] font-bold text-[#4B5563]">{label}</span>
    </div>
);

export default RoadsideAssistanceView;
