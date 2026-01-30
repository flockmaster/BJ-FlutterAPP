
import React from 'react';
import { ArrowLeft, Gift, Share2, Copy, Users, ChevronRight, MessageCircle } from 'lucide-react';

interface InviteFriendsViewProps {
  onBack: () => void;
}

const INVITE_LIST = [
    { id: 1, name: '微信好友_OldWang', avatar: 'https://randomuser.me/api/portraits/men/11.jpg', status: 'success', date: '2023-12-28', reward: 500 },
    { id: 2, name: 'Lisa', avatar: 'https://randomuser.me/api/portraits/women/23.jpg', status: 'success', date: '2023-12-25', reward: 500 },
    { id: 3, name: '大漠孤烟', avatar: 'https://randomuser.me/api/portraits/men/45.jpg', status: 'pending', date: '2023-12-20', reward: 0 },
];

const InviteFriendsView: React.FC<InviteFriendsViewProps> = ({ onBack }) => {
  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header Background */}
      <div className="h-[420px] bg-gradient-to-br from-[#FF6B00] via-[#FF8E53] to-[#F5F7FA] relative overflow-hidden shrink-0">
          {/* Decorative Circles */}
          <div className="absolute top-[-50px] right-[-50px] w-64 h-64 bg-white/10 rounded-full blur-3xl" />
          <div className="absolute bottom-[50px] left-[-50px] w-48 h-48 bg-white/10 rounded-full blur-2xl" />
          
          {/* Nav */}
          <div className="relative z-10 pt-[54px] px-5 flex items-center">
              <button onClick={onBack} className="w-9 h-9 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center active:bg-white/30 transition-colors text-white">
                  <ArrowLeft size={20} />
              </button>
              <div className="text-[17px] font-bold text-white ml-3">邀请有礼</div>
          </div>

          {/* Hero Content */}
          <div className="relative z-10 flex flex-col items-center mt-8 text-center px-6">
              <div className="bg-white/20 backdrop-blur-md border border-white/20 text-white text-[12px] font-bold px-3 py-1 rounded-full mb-4 shadow-sm animate-bounce">
                  🎉 限时活动：奖励翻倍
              </div>
              <h1 className="text-[36px] font-bold text-white leading-tight drop-shadow-md mb-2">
                  邀请好友加入<br/>赢取海量积分
              </h1>
              <p className="text-white/90 text-[14px] mb-8">
                  每成功邀请 1 位好友注册，双方各得 <span className="font-oswald text-[18px] font-bold text-yellow-300">500</span> 积分
              </p>
              
              {/* Main Action Card - Corrected: rounded-2xl (Radius-M) */}
              <div className="w-full bg-white rounded-2xl p-6 shadow-xl relative">
                  <div className="absolute -top-6 left-1/2 -translate-x-1/2 w-12 h-12 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full flex items-center justify-center border-4 border-white shadow-lg">
                      <Gift size={24} className="text-white" />
                  </div>
                  
                  <div className="mt-6 flex justify-between items-center bg-[#FFF7E6] rounded-xl p-4 mb-5 border border-orange-100">
                      <div className="text-left">
                          <div className="text-[12px] text-orange-800 mb-1">我的邀请码</div>
                          <div className="text-[24px] font-oswald font-bold text-[#FF6B00] tracking-widest">BJ8888</div>
                      </div>
                      <button 
                        onClick={() => alert('复制成功')}
                        className="bg-white text-[#FF6B00] text-[12px] font-bold px-4 py-2 rounded-full shadow-sm active:scale-95 transition-transform flex items-center gap-1"
                      >
                          <Copy size={12} /> 复制
                      </button>
                  </div>

                  <button className="w-full h-12 bg-[#111] text-white rounded-full font-bold text-[16px] shadow-lg shadow-black/20 active:scale-95 transition-transform flex items-center justify-center gap-2">
                      立即邀请好友
                  </button>
                  
                  <div className="mt-6 flex justify-around">
                      <ShareBtn icon={MessageCircle} label="微信" color="bg-green-50 text-green-600" />
                      <ShareBtn icon={Users} label="朋友圈" color="bg-blue-50 text-blue-600" />
                      <ShareBtn icon={Share2} label="更多" color="bg-gray-50 text-gray-600" />
                  </div>
              </div>
          </div>
      </div>

      {/* List Content */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-5 -mt-10 relative z-20">
          {/* Corrected: rounded-2xl (Radius-M) */}
          <div className="bg-white rounded-2xl p-5 shadow-sm min-h-[300px]">
              <div className="flex justify-between items-center mb-6">
                  <h3 className="text-[16px] font-bold text-[#111]">邀请记录</h3>
                  <div className="text-[12px] text-gray-400">
                      已邀请 <span className="text-[#FF6B00] font-bold">2</span> 人
                  </div>
              </div>

              <div className="space-y-6">
                  {INVITE_LIST.map((item) => (
                      <div key={item.id} className="flex items-center justify-between">
                          <div className="flex items-center gap-3">
                              <img src={item.avatar} className="w-10 h-10 rounded-full bg-gray-100" />
                              <div>
                                  <div className="text-[14px] font-bold text-[#111]">{item.name}</div>
                                  <div className="text-[11px] text-gray-400">{item.date}</div>
                              </div>
                          </div>
                          <div className="text-right">
                              <div className={`text-[14px] font-bold font-oswald ${
                                  item.status === 'success' ? 'text-[#FF6B00]' : 'text-gray-300'
                              }`}>
                                  {item.status === 'success' ? `+${item.reward}` : '审核中'}
                              </div>
                              <div className={`text-[10px] ${
                                  item.status === 'success' ? 'text-green-500' : 'text-gray-400'
                              }`}>
                                  {item.status === 'success' ? '邀请成功' : '等待注册'}
                              </div>
                          </div>
                      </div>
                  ))}
              </div>
              
              <div className="mt-8 pt-6 border-t border-gray-50">
                  <div className="flex items-center justify-between text-[12px] text-[#333] font-bold mb-3">
                      活动规则
                  </div>
                  <ul className="text-[11px] text-gray-500 space-y-2 list-disc pl-4">
                      <li>被邀请人需从未注册过北京汽车APP。</li>
                      <li>被邀请人完成车辆认证后，双方可获得额外奖励。</li>
                      <li>积分将于被邀请人注册成功后 24 小时内到账。</li>
                      <li>如发现违规刷分行为，平台有权取消奖励资格。</li>
                  </ul>
              </div>
          </div>
      </div>
    </div>
  );
};

const ShareBtn = ({ icon: Icon, label, color }: any) => (
    <button className="flex flex-col items-center gap-2 group">
        <div className={`w-12 h-12 rounded-full flex items-center justify-center ${color} group-active:scale-90 transition-transform`}>
            <Icon size={20} />
        </div>
        <span className="text-[11px] text-gray-500">{label}</span>
    </button>
);

export default InviteFriendsView;
