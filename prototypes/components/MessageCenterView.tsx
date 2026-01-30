
import React, { useState } from 'react';
import { ArrowLeft, Bell, MessageSquare, Wrench, CheckCircle2, ChevronRight } from 'lucide-react';

interface MessageCenterViewProps {
  onBack: () => void;
}

const TABS = ['全部', '系统', '服务', '互动'];

const MESSAGES = [
    { id: 1, type: 'service', title: '保养预约确认', desc: '您的BJ40预约保养已确认，请于1月20日 10:00前往北京汽车朝阳4S店。', time: '10:30', isRead: false },
    { id: 2, type: 'system', title: '双11特惠活动开启', desc: '越野配件低至5折，限时抢购！点击查看详情。', time: '昨天', isRead: false },
    { id: 3, type: 'social', title: '越野老炮 赞了你的动态', desc: '“周末去山里撒野...”', time: '昨天', isRead: true },
    { id: 4, type: 'service', title: '车辆体检报告生成', desc: '您的爱车体检已完成，各项指标正常。', time: '1月15日', isRead: true },
    { id: 5, type: 'system', title: '版本更新通知', desc: 'App v2.1.0 已发布，优化了部分体验。', time: '1月10日', isRead: true },
];

const MessageCenterView: React.FC<MessageCenterViewProps> = ({ onBack }) => {
  const [activeTab, setActiveTab] = useState('全部');

  const filteredMessages = activeTab === '全部' 
    ? MESSAGES 
    : MESSAGES.filter(m => {
        if (activeTab === '系统') return m.type === 'system';
        if (activeTab === '服务') return m.type === 'service';
        if (activeTab === '互动') return m.type === 'social';
        return true;
    });

  const getIcon = (type: string) => {
      switch(type) {
          case 'system': return <Bell size={18} />;
          case 'service': return <Wrench size={18} />;
          case 'social': return <MessageSquare size={18} />;
          default: return <Bell size={18} />;
      }
  };

  const getColor = (type: string) => {
      switch(type) {
          case 'system': return 'bg-blue-50 text-blue-600';
          case 'service': return 'bg-orange-50 text-[#FF6B00]';
          case 'social': return 'bg-pink-50 text-pink-500';
          default: return 'bg-gray-100 text-gray-600';
      }
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Unified Sticky Header */}
      <div className="bg-white z-20 sticky top-0 shadow-[0_4px_20px_rgba(0,0,0,0.02)]">
          {/* Top Title Bar */}
          <div className="pt-[54px] px-5 pb-2 flex justify-between items-center">
            <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                <ArrowLeft size={24} className="text-[#111]" />
            </button>
            <div className="text-[17px] font-bold text-[#111]">消息中心</div>
            <button className="text-[13px] text-[#111] font-medium active:opacity-60 px-2 py-1">
                全部已读
            </button>
          </div>

          {/* Tab Bar */}
          <div className="flex items-center px-6 gap-8 border-b border-gray-100/80">
              {TABS.map((tab) => (
                  <button 
                    key={tab}
                    onClick={() => setActiveTab(tab)}
                    className={`py-3 text-[15px] font-medium relative transition-all duration-300 flex flex-col items-center ${
                        activeTab === tab ? 'text-[#111] font-bold scale-105' : 'text-gray-400'
                    }`}
                  >
                      {tab}
                      {activeTab === tab && (
                          <div className="absolute bottom-0 w-5 h-1 bg-[#111] rounded-t-full animate-in fade-in zoom-in duration-200" />
                      )}
                  </button>
              ))}
          </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-4">
          {filteredMessages.map(msg => (
              <div 
                key={msg.id} 
                className={`bg-white rounded-2xl p-5 shadow-sm active:scale-[0.99] transition-transform flex gap-4 border border-transparent hover:border-gray-50 ${msg.isRead ? 'opacity-80' : 'opacity-100'}`}
              >
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${getColor(msg.type)}`}>
                      {getIcon(msg.type)}
                  </div>
                  <div className="flex-1 min-w-0">
                      <div className="flex justify-between items-start mb-1">
                          <h4 className="text-[15px] font-bold text-[#111] truncate pr-2">{msg.title}</h4>
                          <span className="text-[11px] text-gray-400 font-oswald whitespace-nowrap">{msg.time}</span>
                      </div>
                      <p className="text-[13px] text-gray-500 line-clamp-2 leading-relaxed">
                          {msg.desc}
                      </p>
                  </div>
                  {!msg.isRead && (
                      <div className="w-2 h-2 rounded-full bg-red-500 mt-2 shrink-0 shadow-sm" />
                  )}
              </div>
          ))}

          {filteredMessages.length === 0 && (
              <div className="py-20 text-center text-gray-400">
                  <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                      <Bell size={24} className="opacity-50" />
                  </div>
                  <p className="text-[13px]">暂无消息</p>
              </div>
          )}
          
          {filteredMessages.length > 0 && (
             <div className="text-center text-[10px] text-gray-300 py-6 font-oswald tracking-[0.2em] uppercase">
                 No More Messages
             </div>
          )}
      </div>
    </div>
  );
};

export default MessageCenterView;
