
import React, { useState } from 'react';
import { ArrowLeft, Bell, Truck, MessageSquare, Volume2, Vibrate, Megaphone } from 'lucide-react';

interface NotificationSettingsViewProps {
  onBack: () => void;
}

const NotificationSettingsView: React.FC<NotificationSettingsViewProps> = ({ onBack }) => {
  const [settings, setSettings] = useState({
      system: true,
      activity: true,
      logistics: true,
      social: false,
      sound: true,
      vibration: false
  });

  const toggle = (key: keyof typeof settings) => {
      setSettings(prev => ({ ...prev, [key]: !prev[key] }));
  };

  return (
    <div className="absolute inset-0 z-[300] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">消息推送</div>
        <div className="w-9" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-8">
          
          {/* 推送类别 */}
          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">推送类别</div>
              <div className="bg-white rounded-[20px] overflow-hidden shadow-sm border border-gray-50">
                  <ToggleItem 
                      icon={Bell} 
                      label="系统通知" 
                      subLabel="账户安全、版本更新等重要信息"
                      isOn={settings.system} 
                      onToggle={() => toggle('system')} 
                  />
                  <ToggleItem 
                      icon={Megaphone} 
                      label="活动优惠" 
                      subLabel="商城促销、车主福利活动"
                      isOn={settings.activity} 
                      onToggle={() => toggle('activity')} 
                  />
                  <ToggleItem 
                      icon={Truck} 
                      label="交易物流" 
                      subLabel="订单状态、物流进度更新"
                      isOn={settings.logistics} 
                      onToggle={() => toggle('logistics')} 
                  />
                  <ToggleItem 
                      icon={MessageSquare} 
                      label="互动消息" 
                      subLabel="评论、点赞、@我的"
                      isOn={settings.social} 
                      onToggle={() => toggle('social')} 
                      isLast
                  />
              </div>
          </div>

          {/* 提醒方式 */}
          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">提醒方式</div>
              <div className="bg-white rounded-[20px] overflow-hidden shadow-sm border border-gray-50">
                  <ToggleItem 
                      icon={Volume2} 
                      label="声音" 
                      isOn={settings.sound} 
                      onToggle={() => toggle('sound')} 
                  />
                  <ToggleItem 
                      icon={Vibrate} 
                      label="振动" 
                      isOn={settings.vibration} 
                      onToggle={() => toggle('vibration')} 
                      isLast
                  />
              </div>
          </div>

          <div className="text-[11px] text-gray-400 px-3 leading-relaxed flex items-start gap-2">
              <span className="mt-0.5">•</span>
              <p>若关闭系统通知，您可能会错过重要的账户安全提醒和维保预约确认，请谨慎操作。</p>
          </div>
      </div>
    </div>
  );
};

const ToggleItem: React.FC<{ 
    icon: any, 
    label: string, 
    subLabel?: string, 
    isOn: boolean, 
    onToggle: () => void, 
    isLast?: boolean 
}> = ({ icon: Icon, label, subLabel, isOn, onToggle, isLast }) => (
    <div className={`flex items-center justify-between py-5 px-5 ${!isLast ? 'border-b border-gray-50' : ''}`}>
        <div className="flex items-center gap-4">
            {/* 统一去背图标风格 */}
            <div className="text-[#333] shrink-0">
                <Icon size={20} strokeWidth={2} />
            </div>
            <div>
                <div className="text-[15px] text-[#111] font-bold leading-none mb-1.5">{label}</div>
                {subLabel && <div className="text-[11px] text-gray-400 font-medium leading-tight">{subLabel}</div>}
            </div>
        </div>
        
        {/* 优化后的开关：增加 padding 和 强化投影 */}
        <button 
            onClick={onToggle}
            className={`w-[48px] h-[28px] rounded-full transition-colors relative flex items-center px-1 ${
                isOn ? 'bg-[#111]' : 'bg-gray-200'
            }`}
        >
            <div className={`w-[20px] h-[20px] bg-white rounded-full shadow-[0_2px_4px_rgba(0,0,0,0.15)] transition-transform duration-300 transform ${
                isOn ? 'translate-x-[20px]' : 'translate-x-0'
            }`} />
        </button>
    </div>
);

export default NotificationSettingsView;
