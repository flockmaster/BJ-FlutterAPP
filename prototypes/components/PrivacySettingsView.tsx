
import React, { useState } from 'react';
import { ArrowLeft, ChevronRight, Users, Shield, FileText, Share2, Lock, Eye, List } from 'lucide-react';

interface PrivacySettingsViewProps {
  onBack: () => void;
}

const PrivacySettingsView: React.FC<PrivacySettingsViewProps> = ({ onBack }) => {
  const [blockedUsers, setBlockedUsers] = useState([
      { id: 1, name: '广告推销号001', time: '2023-12-01' },
      { id: 2, name: '不文明用户', time: '2023-11-15' }
  ]);
  const [showBlockList, setShowBlockList] = useState(false);

  const handleUnblock = (id: number) => {
      setBlockedUsers(blockedUsers.filter(u => u.id !== id));
  };

  if (showBlockList) {
      return (
          <div className="absolute inset-0 z-[350] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
              <div className="pt-[54px] px-5 pb-3 flex items-center gap-3 bg-white border-b border-gray-100">
                  <button onClick={() => setShowBlockList(false)} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                      <ArrowLeft size={24} className="text-[#111]" />
                  </button>
                  <div className="text-[17px] font-bold text-[#111]">黑名单管理</div>
              </div>
              <div className="p-5 space-y-3">
                  {blockedUsers.length > 0 ? blockedUsers.map(user => (
                      <div key={user.id} className="bg-white p-5 rounded-2xl flex justify-between items-center shadow-sm border border-gray-50">
                          <div>
                              <div className="text-[15px] font-bold text-[#111]">{user.name}</div>
                              <div className="text-[11px] text-gray-400">拉黑时间: {user.time}</div>
                          </div>
                          <button 
                            onClick={() => handleUnblock(user.id)}
                            className="px-5 py-2 border border-gray-200 rounded-xl text-[13px] font-bold text-[#333] active:bg-gray-50 transition-colors"
                          >
                              移除
                          </button>
                      </div>
                  )) : (
                      <div className="text-center text-gray-400 py-20 text-[13px]">暂无拉黑用户</div>
                  )}
              </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-[300] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex items-center gap-3 bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">隐私设置</div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-8">
          
          {/* 用户互动 */}
          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">用户互动</div>
              <div className="bg-white rounded-[20px] overflow-hidden shadow-sm border border-gray-50">
                  <SettingItem 
                    icon={Users} 
                    label="黑名单管理" 
                    value={`${blockedUsers.length}人`} 
                    onClick={() => setShowBlockList(true)} 
                  />
                  <SettingItem 
                    icon={Eye} 
                    label="谁可以看我的动态" 
                    value="所有人" 
                    isLast 
                  />
              </div>
          </div>

          {/* 权限与数据 */}
          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">权限与数据</div>
              <div className="bg-white rounded-[20px] overflow-hidden shadow-sm border border-gray-50">
                  <SettingItem 
                    icon={Lock} 
                    label="系统权限管理" 
                    subLabel="相机、定位、麦克风等权限状态"
                  />
                  <SettingItem 
                    icon={Share2} 
                    label="第三方共享信息清单" 
                    subLabel="SDK技术使用详情"
                  />
                  <SettingItem 
                    icon={List} 
                    label="个人信息收集清单" 
                  />
                  <SettingItem 
                    icon={FileText} 
                    label="隐私政策条款" 
                    isLast 
                  />
              </div>
          </div>

          <div className="text-[11px] text-gray-400 px-3 leading-relaxed flex items-start gap-2">
              <span className="mt-0.5">•</span>
              <p>北京汽车严格遵守法律法规，保护您的个人隐私安全。如需撤回隐私授权，可能影响部分功能的使用。</p>
          </div>
      </div>
    </div>
  );
};

const SettingItem: React.FC<{ icon: any, label: string, subLabel?: string, value?: string, isLast?: boolean, onClick?: () => void }> = ({ icon: Icon, label, subLabel, value, isLast, onClick }) => (
    <div 
        onClick={onClick}
        className={`flex items-center justify-between py-5 px-5 cursor-pointer active:bg-gray-50 transition-colors ${!isLast ? 'border-b border-gray-50' : ''}`}
    >
        <div className="flex items-center gap-4">
            <div className="text-[#333] shrink-0">
                <Icon size={20} strokeWidth={2} />
            </div>
            <div>
                <div className="text-[15px] text-[#111] font-bold leading-none mb-1.5">{label}</div>
                {subLabel && <div className="text-[11px] text-gray-400 font-medium leading-tight">{subLabel}</div>}
            </div>
        </div>
        <div className="flex items-center gap-2">
            {value && <span className="text-[13px] text-gray-400 font-medium">{value}</span>}
            <ChevronRight size={18} className="text-gray-300" />
        </div>
    </div>
);

export default PrivacySettingsView;
