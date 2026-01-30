
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Headset, 
  User, 
  Building2, 
  Users, 
  ChevronRight, 
  ClipboardList, 
  Circle, 
  Info,
  PartyPopper
} from 'lucide-react';

interface BindVehicleViewProps {
  onBack: () => void;
}

const BindVehicleView: React.FC<BindVehicleViewProps> = ({ onBack }) => {
  const [isScrolled, setIsScrolled] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        setIsScrolled(scrollRef.current.scrollTop > 100);
      }
    };
    const el = scrollRef.current;
    if (el) {
        el.addEventListener('scroll', handleScroll);
        return () => el.removeEventListener('scroll', handleScroll);
    }
  }, []);

  return (
    <div className="absolute inset-0 z-[60] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* 沉浸式顶部导航 */}
      <div className={`absolute top-0 left-0 right-0 z-50 pt-[54px] transition-all duration-300 ${
        isScrolled ? 'bg-white/95 backdrop-blur-md shadow-sm' : 'bg-transparent'
      }`}>
        <div className="flex items-center justify-between px-5 pb-3">
            <button onClick={onBack} className={`transition-colors ${isScrolled ? 'text-[#333]' : 'text-white'}`}>
                <ArrowLeft size={24} className="drop-shadow-sm" />
            </button>
            <div className={`text-[17px] font-bold transition-colors ${isScrolled ? 'text-[#333]' : 'text-white'}`}>
                绑定车辆
            </div>
            <button className={`transition-colors ${isScrolled ? 'text-[#333]' : 'text-white'}`}>
                <Headset size={24} className="drop-shadow-sm" />
            </button>
        </div>
      </div>

      {/* 滚动内容区域 */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto no-scrollbar bg-white">
          {/* Hero Header */}
          <div className="relative h-[420px] w-full">
              <img 
                 src="https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop" 
                 className="w-full h-full object-cover"
                 alt="Hero"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-white via-white/80 to-transparent" style={{background: 'linear-gradient(to top, #ffffff 0%, rgba(255, 255, 255, 0.9) 20%, transparent 100%)'}} />
              
              <div className="absolute top-[140px] left-0 right-0 flex flex-col items-center justify-center p-6 text-center">
                  <div className="w-20 h-20 bg-white/90 backdrop-blur-xl rounded-full flex items-center justify-center shadow-lg mb-6 animate-bounce" style={{ animationDuration: '3s' }}>
                      <span className="text-4xl">🎉</span>
                  </div>
                  <h1 className="text-[26px] font-bold text-white mb-4 drop-shadow-md leading-tight">
                    恭喜您成为<br/>北汽越野车主
                  </h1>
                  <p className="text-[15px] text-white/95 leading-relaxed max-w-[280px] drop-shadow">
                    征服山川湖海，探索诗和远方<br/>让每一次出发，都成为难忘的旅程
                  </p>
              </div>
          </div>

          {/* Bind Options */}
          <div className="px-5 pb-10 -mt-10 relative z-10">
              <h2 className="text-[18px] font-bold text-[#1a1a1a] mb-5 px-1">请选择绑车方式</h2>

              <BindTypeCard 
                icon={User} 
                title="个人绑车" 
                desc="车辆登记在个人名下" 
                materials={['身份证正反面照片', '行驶证照片（含车辆信息页）', '车辆VIN码（车架号）']}
              />

              <BindTypeCard 
                icon={Building2} 
                title="企业绑车" 
                desc="车辆登记在企业名下" 
                materials={['营业执照照片', '行驶证照片（含车辆信息页）', '车辆VIN码（车架号）', '经办人身份证明']}
              />

              <BindTypeCard 
                icon={Users} 
                title="家人绑车" 
                desc="车辆登记在家人名下" 
                materials={['车主身份证照片', '本人身份证照片', '行驶证照片（含车辆信息页）', '关系证明（户口本/结婚证等）']}
              />

              {/* Tips */}
              <div className="mt-8 bg-[#FFF9F0] rounded-xl p-4 flex items-start gap-3">
                  <div className="w-5 h-5 bg-[#FFA940] rounded-full flex items-center justify-center shrink-0 mt-0.5">
                      <Info size={12} className="text-white" />
                  </div>
                  <div>
                      <div className="text-[14px] font-bold text-[#D46B08] mb-1">温馨提示</div>
                      <div className="text-[13px] text-[#AD6800] leading-relaxed">
                        请提前准备好相关材料的清晰照片，确保信息完整可见。审核通过后即可享受专属车主服务。
                      </div>
                  </div>
              </div>
          </div>
          <div className="h-10"></div>
      </div>
    </div>
  );
};

const BindTypeCard: React.FC<{ 
    icon: any, 
    title: string, 
    desc: string, 
    materials: string[] 
}> = ({ icon: Icon, title, desc, materials }) => {
    return (
        <div className="bg-white rounded-2xl p-6 mb-4 shadow-[0_2px_12px_rgba(0,0,0,0.06)] border border-transparent hover:border-gray-100 active:scale-[0.99] transition-all cursor-pointer">
            <div className="flex items-center mb-5">
                <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-[#F5F5F5] to-[#E8E8E8] flex items-center justify-center text-[#666] mr-4">
                    <Icon size={24} />
                </div>
                <div className="flex-1">
                    <div className="text-[17px] font-bold text-[#1a1a1a] mb-1">{title}</div>
                    <div className="text-[13px] text-[#999]">{desc}</div>
                </div>
                <ChevronRight size={20} className="text-gray-300" />
            </div>

            <div className="bg-[#F8F9FA] rounded-xl p-4">
                <div className="flex items-center gap-2 text-[14px] font-bold text-[#666] mb-3">
                    <ClipboardList size={16} className="text-[#999]" />
                    需要准备的材料
                </div>
                <div className="space-y-2">
                    {materials.map((m, i) => (
                        <div key={i} className="flex items-center gap-2 text-[13px] text-[#666]">
                            <Circle size={6} fill="#999" className="text-transparent shrink-0" />
                            {m}
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default BindVehicleView;
