
import React, { useState } from 'react';
import { ArrowLeft, Check, Gift, Coins, CalendarDays, HelpCircle, X } from 'lucide-react';

interface DailyCheckInViewProps {
  onBack: () => void;
  onNavigateToPoints: () => void;
}

const DailyCheckInView: React.FC<DailyCheckInViewProps> = ({ onBack, onNavigateToPoints }) => {
  const [checkedIn, setCheckedIn] = useState(false);
  const [points, setPoints] = useState(2450);
  const [showRules, setShowRules] = useState(false);

  const handleCheckIn = () => {
      if (checkedIn) return;
      setCheckedIn(true);
      setPoints(p => p + 10);
  };

  const weekDays = [
      { day: '一', status: 'checked', val: '+5' },
      { day: '二', status: 'checked', val: '+5' },
      { day: '三', status: 'today', val: '+10' },
      { day: '四', status: 'pending', val: '+5' },
      { day: '五', status: 'pending', val: '+5' },
      { day: '六', status: 'pending', val: '+20' },
      { day: '日', status: 'pending', val: '+50' },
  ];

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="h-[300px] bg-[#111] relative overflow-hidden text-white">
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,_var(--tw-gradient-stops))] from-gray-800 to-transparent opacity-50" />
          
          <div className="relative z-10 pt-[54px] px-5 flex justify-between items-center">
              <button onClick={onBack} className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center active:bg-white/20 transition-colors">
                  <ArrowLeft size={22} />
              </button>
              <div className="text-[17px] font-bold">每日签到</div>
              <button 
                onClick={() => setShowRules(true)}
                className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center active:bg-white/20 transition-colors"
              >
                  <HelpCircle size={22} />
              </button>
          </div>

          <div className="relative z-10 text-center mt-6">
              <div className="text-[13px] text-white/60 mb-1">我的积分</div>
              <div className="text-[48px] font-bold font-oswald leading-none tracking-tight text-[#FFD700] drop-shadow-sm">
                  {points.toLocaleString()}
              </div>
              <button 
                onClick={onNavigateToPoints}
                className="mt-5 inline-flex items-center gap-1.5 bg-white/10 px-4 py-1.5 rounded-full text-[12px] backdrop-blur-md border border-white/10 cursor-pointer active:bg-white/20 transition-colors"
              >
                  积分明细 <ArrowLeft size={10} className="rotate-180" />
              </button>
          </div>
      </div>

      <div className="flex-1 -mt-16 px-5 relative z-20 pb-10 overflow-y-auto no-scrollbar">
          <div className="bg-white rounded-2xl p-6 shadow-xl mb-5 text-center relative overflow-hidden">
              <div className="flex justify-between items-center mb-8">
                  <div className="text-left">
                      <div className="text-[17px] font-bold text-[#111]">已连续签到 <span className="text-[#FF6B00] font-oswald text-[22px]">3</span> 天</div>
                      <div className="text-[12px] text-gray-400">再签到 4 天可得大额积分礼包</div>
                  </div>
                  {/* Restored circular icon bg */}
                  <div className="w-12 h-12 bg-orange-50 rounded-full flex items-center justify-center">
                    <Gift size={28} className="text-[#FF6B00]" />
                  </div>
              </div>

              <div className="flex justify-between mb-8">
                  {weekDays.map((d, i) => {
                      const isChecked = d.status === 'checked';
                      const isToday = d.status === 'today';
                      
                      return (
                          <div key={i} className="flex flex-col items-center gap-2">
                              <div className={`w-10 h-10 rounded-full flex items-center justify-center text-[12px] font-bold border-2 transition-all ${
                                  isChecked ? 'bg-[#FF6B00] border-[#FF6B00] text-white' :
                                  isToday && checkedIn ? 'bg-[#FF6B00] border-[#FF6B00] text-white' :
                                  isToday ? 'bg-white border-[#FF6B00] text-[#FF6B00]' :
                                  'bg-gray-50 border-transparent text-gray-400'
                              }`}>
                                  {(isChecked || (isToday && checkedIn)) ? <Check size={16} /> : d.val}
                              </div>
                              <span className={`text-[11px] ${isToday ? 'text-[#111] font-bold' : 'text-gray-400'}`}>{d.day}</span>
                          </div>
                      )
                  })}
              </div>

              <button 
                onClick={handleCheckIn}
                disabled={checkedIn}
                className={`w-full h-13 rounded-xl font-bold text-[16px] shadow-lg transition-all active:scale-[0.98] flex items-center justify-center gap-2 ${
                    checkedIn 
                        ? 'bg-gray-100 text-gray-400 cursor-not-allowed shadow-none' 
                        : 'bg-[#111] text-white shadow-black/20'
                }`}
              >
                  {checkedIn ? '今日已签到' : '立即签到'}
                  {!checkedIn && <Coins size={18} className="text-[#FFD700]" />}
              </button>
          </div>

          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-50">
              <div className="text-[16px] font-bold text-[#111] mb-5 flex items-center gap-2">
                  <div className="w-8 h-8 bg-blue-50 rounded-full flex items-center justify-center text-blue-600 shrink-0">
                      <CalendarDays size={16} />
                  </div>
                  做任务 赚积分
              </div>
              
              <TaskItem title="完善个人资料" reward="+50" done />
              <TaskItem title="发布一条动态" reward="+20" done={false} />
              <TaskItem title="浏览商城 30秒" reward="+10" done={false} />
              <TaskItem title="分享活动给好友" reward="+50" done={false} />
          </div>
      </div>

      {showRules && (
          <div className="absolute inset-0 z-[200] flex items-center justify-center p-6">
              <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200" onClick={() => setShowRules(false)} />
              <div className="bg-white w-full max-w-sm rounded-2xl p-7 relative z-10 animate-in zoom-in-95 duration-200 shadow-2xl">
                  <div className="flex justify-between items-center mb-5">
                      <h3 className="text-[18px] font-bold text-[#111]">签到规则</h3>
                      <button onClick={() => setShowRules(false)} className="w-9 h-9 rounded-full bg-gray-50 flex items-center justify-center active:bg-gray-100">
                          <X size={18} className="text-[#333]" />
                      </button>
                  </div>
                  <div className="space-y-4 text-[14px] text-gray-600 leading-relaxed">
                      <p>1. 每日签到可获得基础积分奖励，连续签到天数越多，奖励越丰厚。</p>
                      <p>2. 连续签到7天为一个周期，第3天、第7天可获得额外积分宝箱。</p>
                      <p>3. 获得的积分可在积分商城兑换实物礼品、卡券或服务权益。</p>
                  </div>
                  <button 
                    onClick={() => setShowRules(false)}
                    className="w-full h-12 bg-[#111] text-white rounded-xl mt-8 font-bold text-[15px] active:scale-95 transition-transform shadow-md"
                  >
                      我知道了
                  </button>
              </div>
          </div>
      )}
    </div>
  );
};

const TaskItem = ({ title, reward, done }: any) => (
    <div className="flex justify-between items-center py-4 border-b border-gray-50 last:border-0">
        <div>
            <div className="text-[15px] font-bold text-[#111] mb-1">{title}</div>
            <div className="flex items-center gap-1.5 text-[11px] text-[#FF6B00] font-bold bg-orange-50 w-fit px-2 py-0.5 rounded-lg border border-orange-100">
                <Coins size={12} /> {reward}
            </div>
        </div>
        <button 
            className={`px-5 py-2 rounded-xl text-[13px] font-bold border transition-all active:scale-95 ${
                done 
                    ? 'bg-gray-50 text-gray-400 border-transparent' 
                    : 'bg-white text-[#111] border-[#111] shadow-sm'
            }`}
        >
            {done ? '已完成' : '去完成'}
        </button>
    </div>
);

export default DailyCheckInView;
