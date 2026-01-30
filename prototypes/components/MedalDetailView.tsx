
import React from 'react';
import { ArrowLeft, Share2, ShieldCheck, Calendar, Lock, Trophy, ExternalLink } from 'lucide-react';
import { IconButton } from './ui/Button';
import MedalVector from './ui/MedalVector';

interface MedalDetailViewProps {
  medal: any;
  isWorn: boolean;
  onBack: () => void;
  onWear: (id: number) => void;
}

const MedalDetailView: React.FC<MedalDetailViewProps> = ({ medal, isWorn, onBack, onWear }) => {
  const isEarned = medal.earned || medal.date;

  return (
    <div className="absolute inset-0 z-[200] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center z-10">
        <IconButton icon={ArrowLeft} onClick={onBack} variant="ghost" className="-ml-2" />
        <div className="text-[17px] font-bold text-[#111]">勋章详情</div>
        <IconButton icon={Share2} variant="ghost" className="-mr-2" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar flex flex-col items-center px-6 pt-8">
        {/* Large Medal Display */}
        <div className={`w-64 h-64 relative mb-10 transition-all duration-700 ${!isEarned ? 'grayscale opacity-40' : 'animate-in zoom-in-95'}`}>
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-orange-100/50 to-transparent blur-3xl opacity-60" />
            <MedalVector id={medal.id} className="w-full h-full drop-shadow-[0_20px_50px_rgba(0,0,0,0.15)]" />
        </div>

        {/* Title & Info */}
        <div className="text-center mb-10">
            <h1 className="text-[28px] font-bold text-[#111] mb-2">{medal.name}</h1>
            <div className="text-[14px] text-gray-500 leading-relaxed max-w-[280px] mx-auto">
                {medal.desc || medal.task}
            </div>
        </div>

        {/* Achievement Status */}
        <div className="w-full bg-[#F9FAFB] rounded-[24px] p-6 mb-8">
            {isEarned ? (
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-green-50 rounded-full flex items-center justify-center text-green-600">
                            <Calendar size={20} />
                        </div>
                        <div>
                            <div className="text-[12px] text-gray-400">获得时间</div>
                            <div className="text-[15px] font-bold text-[#111] font-oswald">{medal.date}</div>
                        </div>
                    </div>
                    <div className="bg-green-50 text-green-600 text-[11px] font-bold px-3 py-1 rounded-full border border-green-100">
                        已达成
                    </div>
                </div>
            ) : (
                <div className="space-y-4">
                    <div className="flex justify-between items-center">
                        <div className="flex items-center gap-2 text-[14px] font-bold text-[#111]">
                            <Lock size={16} className="text-gray-400" /> 解锁进度
                        </div>
                        <span className="text-[13px] font-oswald font-bold text-[#FF6B00]">{medal.progress}</span>
                    </div>
                    {/* Progress Bar */}
                    <div className="w-full h-2 bg-gray-100 rounded-full overflow-hidden">
                        <div 
                            className="h-full bg-gradient-to-r from-orange-400 to-orange-600 transition-all duration-1000"
                            style={{ width: `${(parseInt(medal.progress?.split('/')[0] || '0') / parseInt(medal.progress?.split('/')[1] || '1')) * 100}%` }}
                        />
                    </div>
                    <p className="text-[12px] text-gray-400 text-center">继续努力，即将点亮这份荣誉！</p>
                </div>
            )}
        </div>

        {/* Action Buttons */}
        <div className="w-full space-y-4 pb-12 mt-auto">
            {isEarned ? (
                <div className="flex gap-4">
                    <button className="flex-1 h-14 rounded-full bg-[#F5F7FA] text-[#111] font-bold text-[15px] active:scale-95 transition-transform flex items-center justify-center gap-2">
                        炫耀一下
                    </button>
                    <button 
                        onClick={() => onWear(medal.id)}
                        className={`flex-1 h-14 rounded-full font-bold text-[15px] active:scale-95 transition-transform shadow-lg ${
                            isWorn 
                                ? 'bg-gray-100 text-gray-400 shadow-none' 
                                : 'bg-[#111] text-white shadow-black/20'
                        }`}
                    >
                        {isWorn ? '取消佩戴' : '佩戴勋章'}
                    </button>
                </div>
            ) : (
                <button className="w-full h-14 rounded-full bg-[#111] text-white font-bold text-[15px] active:scale-95 transition-transform flex items-center justify-center gap-2 shadow-lg shadow-black/20">
                    立即去完成 <ExternalLink size={18} />
                </button>
            )}
        </div>
      </div>

      {/* Footer Decoration */}
      <div className="py-6 flex flex-col items-center gap-2 opacity-20 grayscale pointer-events-none">
          <img src="https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=100&auto=format&fit=crop" className="h-6 object-contain" />
          <span className="text-[10px] font-bold tracking-widest text-gray-400 uppercase">BAIC Official Honor</span>
      </div>
    </div>
  );
};

export default MedalDetailView;
