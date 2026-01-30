
import React, { useState } from 'react';
import { ArrowLeft, HelpCircle, ShoppingBag, Trophy, Gift, Car, Calendar, TrendingUp } from 'lucide-react';

interface PointsHistoryViewProps {
  onBack: () => void;
}

// Enriched Mock Data
const TRANSACTIONS = [
    { id: 1, title: '每日签到', time: '今天 08:30', amount: 10, type: 'earn', category: 'checkin' },
    { id: 2, title: '商城兑换-车载吸尘器', time: '昨天 14:20', amount: -1200, type: 'spend', category: 'shop' },
    { id: 3, title: '完成完善资料任务', time: '1月12日 10:00', amount: 50, type: 'earn', category: 'task' },
    { id: 4, title: '发布精选动态奖励', time: '1月10日 18:45', amount: 200, type: 'earn', category: 'community' },
    { id: 5, title: '参与车主活动报名', time: '1月05日 09:15', amount: -500, type: 'spend', category: 'activity' },
    { id: 6, title: '邀请好友注册', time: '2023-12-28', amount: 500, type: 'earn', category: 'invite' },
    { id: 7, title: '预约保养完成', time: '2023-12-20', amount: 300, type: 'earn', category: 'service' },
];

const TABS = [
    { id: 'all', label: '全部' },
    { id: 'earn', label: '获取' },
    { id: 'spend', label: '消耗' },
];

const PointsHistoryView: React.FC<PointsHistoryViewProps> = ({ onBack }) => {
  const [activeTab, setActiveTab] = useState('all');

  const filteredTransactions = TRANSACTIONS.filter(t => {
      if (activeTab === 'all') return true;
      return t.type === activeTab;
  });

  const getIcon = (category: string) => {
      switch(category) {
          case 'checkin': return <Calendar size={18} />;
          case 'shop': return <ShoppingBag size={18} />;
          case 'task': return <Trophy size={18} />;
          case 'invite': return <Gift size={18} />;
          case 'service': return <Car size={18} />;
          default: return <TrendingUp size={18} />;
      }
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="bg-[#111] text-white pt-[54px] pb-6 px-5 relative overflow-hidden shrink-0">
          {/* Background Decor */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-gradient-to-br from-[#FF6B00] to-transparent opacity-10 rounded-full -mr-20 -mt-20 blur-3xl pointer-events-none" />
          
          {/* Nav */}
          <div className="flex justify-between items-center mb-6 relative z-10">
              <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-white/20 transition-colors">
                  <ArrowLeft size={24} />
              </button>
              <div className="text-[17px] font-bold">我的积分</div>
              <button className="w-9 h-9 -mr-2 rounded-full flex items-center justify-center active:bg-white/20 transition-colors">
                  <HelpCircle size={22} />
              </button>
          </div>

          {/* Balance Card */}
          <div className="relative z-10 flex flex-col items-center">
              <div className="text-[13px] text-white/60 mb-2 flex items-center gap-2">
                  当前可用积分
                  <span className="bg-[#FFD700] text-[#111] text-[9px] font-bold px-1.5 py-0.5 rounded">Lv.5 钻石会员</span>
              </div>
              <div className="text-[56px] font-bold font-oswald tracking-tight text-white drop-shadow-sm leading-none mb-6">
                  2,450
              </div>
              
              <div className="flex gap-4 w-full px-4">
                  <button className="flex-1 h-11 bg-white text-[#111] rounded-full text-[14px] font-bold shadow-lg active:scale-95 transition-transform flex items-center justify-center gap-2">
                      <ShoppingBag size={16} /> 积分商城
                  </button>
                  <button className="flex-1 h-11 bg-white/10 backdrop-blur-md border border-white/10 text-white rounded-full text-[14px] font-bold active:scale-95 transition-transform flex items-center justify-center gap-2">
                      <Trophy size={16} /> 做任务赚分
                  </button>
              </div>
          </div>
      </div>

      {/* Content Layer (Rounded Top) */}
      <div className="flex-1 bg-[#F5F7FA] -mt-4 rounded-t-[24px] overflow-hidden flex flex-col relative z-20">
          
          {/* Tabs */}
          <div className="flex items-center justify-around border-b border-gray-100 bg-white px-2">
              {TABS.map(tab => (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`flex-1 py-4 text-[14px] font-medium relative transition-colors ${
                        activeTab === tab.id ? 'text-[#111] font-bold' : 'text-gray-400'
                    }`}
                  >
                      {tab.label}
                      {activeTab === tab.id && (
                          <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-6 h-0.5 bg-[#111] rounded-full" />
                      )}
                  </button>
              ))}
          </div>

          {/* List */}
          <div className="flex-1 overflow-y-auto no-scrollbar p-4">
              <div className="space-y-3">
                  {filteredTransactions.map((item, index) => (
                      <div key={item.id} className="bg-white p-4 rounded-[16px] flex justify-between items-center shadow-[0_2px_8px_rgba(0,0,0,0.02)] border border-transparent hover:border-gray-50 active:scale-[0.99] transition-all">
                          <div className="flex items-center gap-4">
                              <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${
                                  item.type === 'earn' ? 'bg-orange-50 text-[#FF6B00]' : 'bg-gray-100 text-[#111]'
                              }`}>
                                  {getIcon(item.category)}
                              </div>
                              <div>
                                  <div className="text-[14px] font-bold text-[#111] mb-1 line-clamp-1">{item.title}</div>
                                  <div className="text-[11px] text-gray-400">{item.time}</div>
                              </div>
                          </div>
                          <div className={`text-[16px] font-bold font-oswald ${
                              item.type === 'earn' ? 'text-[#FF6B00]' : 'text-[#111]'
                          }`}>
                              {item.amount > 0 ? `+${item.amount}` : item.amount}
                          </div>
                      </div>
                  ))}
                  
                  <div className="text-center text-[11px] text-gray-300 py-6 font-oswald tracking-widest">
                      — 到底了 —
                  </div>
              </div>
          </div>
      </div>
    </div>
  );
};

export default PointsHistoryView;
