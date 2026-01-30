
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  ChevronRight, 
  Smartphone, 
  Shield, 
  Trash2, 
  LogOut, 
  Info, 
  MapPin, 
  Receipt, 
  Bell, 
  Lock, 
  MessageSquareWarning,
  X,
  Eye,
  EyeOff
} from 'lucide-react';
import { ActionButton } from './ui/Button';

interface SettingsViewProps {
  onBack: () => void;
  onNavigateToAddress?: () => void;
  onNavigateToInvoice?: () => void;
  onNavigateToNotifications?: () => void;
  onNavigateToPrivacy?: () => void;
  onNavigateToFeedback?: () => void;
  onNavigateToAccountBinding?: () => void;
  onLogout?: () => void;
}

const SettingsView: React.FC<SettingsViewProps> = ({ 
    onBack, 
    onNavigateToAddress, 
    onNavigateToInvoice, 
    onNavigateToNotifications,
    onNavigateToPrivacy,
    onNavigateToFeedback,
    onNavigateToAccountBinding,
    onLogout
}) => {
  const [showLogoutModal, setShowLogoutModal] = useState(false);
  const [showChangePass, setShowChangePass] = useState(false);

  const handleClearCache = () => {
      alert('清理成功！释放 128MB 空间。');
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex items-center gap-3 bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">设置</div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-8 pb-24">
          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">基础服务</div>
              <div className="bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-50">
                  <SettingItem icon={Smartphone} label="账号绑定" value="138****8888" onClick={onNavigateToAccountBinding} />
                  <SettingItem icon={MapPin} label="地址管理" onClick={onNavigateToAddress} />
                  <SettingItem icon={Receipt} label="发票抬头" onClick={onNavigateToInvoice} isLast />
              </div>
          </div>

          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">隐私与安全</div>
              <div className="bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-50">
                  <SettingItem icon={Lock} label="修改登录密码" onClick={() => setShowChangePass(true)} />
                  <SettingItem 
                    icon={Shield} 
                    label="隐私设置" 
                    subLabel="黑名单、系统权限、隐私政策"
                    onClick={onNavigateToPrivacy} 
                    isLast 
                  />
              </div>
          </div>

          <div>
              <div className="text-[12px] font-bold text-gray-400 mb-4 ml-2 uppercase tracking-wider">通用与反馈</div>
              <div className="bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-50">
                  <SettingItem icon={Bell} label="消息推送" onClick={onNavigateToNotifications} />
                  <SettingItem icon={Trash2} label="清理缓存" value="128 MB" onClick={handleClearCache} />
                  <SettingItem icon={MessageSquareWarning} label="投诉建议" onClick={onNavigateToFeedback} />
                  <SettingItem icon={Info} label="关于我们" value="v2.1.0" isLast />
              </div>
          </div>

          <div className="pt-4 px-1">
              <button 
                onClick={() => setShowLogoutModal(true)}
                className="w-full h-[58px] bg-white rounded-2xl text-[#FF4D4F] text-[16px] font-bold flex items-center justify-center gap-2 shadow-sm active:bg-red-50 active:scale-[0.98] transition-all border border-red-50"
              >
                  <LogOut size={20} /> 退出当前登录
              </button>
          </div>
      </div>

      {/* Change Password Modal */}
      {showChangePass && (
          <ChangePasswordModal onClose={() => setShowChangePass(false)} />
      )}

      {/* Logout Modal */}
      {showLogoutModal && (
          <div className="absolute inset-0 z-[200] flex items-center justify-center p-6">
              <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200" onClick={() => setShowLogoutModal(false)} />
              <div className="bg-white w-full max-w-[300px] rounded-[28px] p-6 relative z-10 animate-in zoom-in-95 duration-200 shadow-[0_20px_60px_rgba(0,0,0,0.15)] text-center border border-white">
                  <div className="w-12 h-12 bg-gray-50 rounded-2xl flex items-center justify-center text-gray-400 mx-auto mb-4">
                      <LogOut size={24} />
                  </div>
                  <h3 className="text-[18px] font-bold text-[#111] mb-2">确认退出登录？</h3>
                  <p className="text-[13px] text-gray-400 mb-8 leading-relaxed">退出后将无法接收及时的服务提醒，建议保持登录状态。</p>
                  <div className="flex flex-col gap-2.5">
                      <button 
                        onClick={() => {
                            setShowLogoutModal(false);
                            onBack(); // Close settings view
                            onLogout && onLogout(); // Trigger app-level logout
                        }}
                        className="w-full h-12 bg-[#111] rounded-2xl text-white font-bold text-[14px] active:scale-[0.98] transition-all shadow-md shadow-black/10"
                      >
                          确认退出
                      </button>
                      <button 
                        onClick={() => setShowLogoutModal(false)}
                        className="w-full h-12 bg-gray-50 rounded-2xl text-[#666] font-bold text-[14px] active:bg-gray-100 transition-colors"
                      >
                          取消
                      </button>
                  </div>
              </div>
          </div>
      )}
    </div>
  );
};

const ChangePasswordModal: React.FC<{ onClose: () => void }> = ({ onClose }) => {
    const [step, setStep] = useState(1);
    const [oldPass, setOldPass] = useState('');
    const [newPass, setNewPass] = useState('');
    const [confirmPass, setConfirmPass] = useState('');
    const [showPass, setShowPass] = useState(false);

    const handleSubmit = () => {
        if (!oldPass || !newPass || !confirmPass) return alert('请填写完整');
        if (newPass !== confirmPass) return alert('两次密码不一致');
        alert('密码修改成功，请重新登录');
        onClose();
    };

    return (
        <div className="absolute inset-0 z-[250] bg-white flex flex-col animate-in slide-in-from-right duration-300">
            <div className="pt-[54px] px-5 pb-3 flex justify-between items-center border-b border-gray-100">
                <button onClick={onClose} className="p-2 -ml-2"><ArrowLeft size={24} /></button>
                <div className="text-[17px] font-bold">修改密码</div>
                <div className="w-9" />
            </div>
            <div className="p-8">
                <div className="space-y-6">
                    <div className="space-y-2">
                        <label className="text-[13px] font-bold text-[#111]">原密码</label>
                        <input 
                            type="password" 
                            className="w-full h-12 bg-gray-50 rounded-xl px-4 outline-none border border-transparent focus:border-[#111] transition-all"
                            placeholder="请输入当前密码"
                            value={oldPass}
                            onChange={e => setOldPass(e.target.value)}
                        />
                    </div>
                    <div className="space-y-2">
                        <label className="text-[13px] font-bold text-[#111]">新密码</label>
                        <div className="relative">
                            <input 
                                type={showPass ? "text" : "password"} 
                                className="w-full h-12 bg-gray-50 rounded-xl px-4 outline-none border border-transparent focus:border-[#111] transition-all"
                                placeholder="8-16位，包含字母和数字"
                                value={newPass}
                                onChange={e => setNewPass(e.target.value)}
                            />
                            <button 
                                onClick={() => setShowPass(!showPass)}
                                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                            >
                                {showPass ? <EyeOff size={18} /> : <Eye size={18} />}
                            </button>
                        </div>
                    </div>
                    <div className="space-y-2">
                        <label className="text-[13px] font-bold text-[#111]">确认新密码</label>
                        <input 
                            type="password" 
                            className="w-full h-12 bg-gray-50 rounded-xl px-4 outline-none border border-transparent focus:border-[#111] transition-all"
                            placeholder="请再次输入新密码"
                            value={confirmPass}
                            onChange={e => setConfirmPass(e.target.value)}
                        />
                    </div>
                </div>
                
                <div className="mt-10">
                    <ActionButton 
                        label="确认修改" 
                        onClick={handleSubmit} 
                        className="w-full rounded-full" 
                    />
                </div>
            </div>
        </div>
    );
};

const SettingItem: React.FC<{ icon: any, label: string, subLabel?: string, value?: string, isLast?: boolean, onClick?: () => void }> = ({ icon: Icon, label, subLabel, value, isLast, onClick }) => (
    <div 
        onClick={onClick}
        className={`flex items-center justify-between py-[22px] px-5 cursor-pointer active:bg-gray-50 transition-colors ${!isLast ? 'border-b border-gray-50' : ''}`}
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
            {value && <span className="text-[14px] text-gray-400 font-medium">{value}</span>}
            <ChevronRight size={18} className="text-gray-300" />
        </div>
    </div>
);

export default SettingsView;
