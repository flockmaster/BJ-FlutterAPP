
import React, { useState, useEffect, useRef } from 'react';
import { 
  X, 
  Smartphone, 
  MessageCircle, 
  Lock, 
  Eye, 
  EyeOff, 
  ArrowLeft,
  Loader2,
  CheckCircle2,
  AlertCircle
} from 'lucide-react';
import { ActionButton } from './ui/Button';

interface LoginViewProps {
  onLoginSuccess: (profile?: any) => void;
  onClose: () => void;
}

const LoginView: React.FC<LoginViewProps> = ({ onLoginSuccess, onClose }) => {
  // Modes: 'main' (One-Click), 'form' (SMS/Pass), 'wechat-bind' (Bind Phone), 'forgot-pass' (Reset)
  const [viewMode, setViewMode] = useState<'main' | 'form' | 'wechat-bind' | 'forgot-pass'>('main');
  
  // Form State
  const [loginMethod, setLoginMethod] = useState<'sms' | 'password'>('sms');
  const [phone, setPhone] = useState('');
  const [code, setCode] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [agreed, setAgreed] = useState(false);
  
  // Interaction State
  const [toastMsg, setToastMsg] = useState('');
  const [shakeAgreement, setShakeAgreement] = useState(false);
  
  // Countdown for SMS
  const [countdown, setCountdown] = useState(0);

  // Simulated User Data for WeChat
  const [wechatProfile, setWechatProfile] = useState<any>(null);

  // Helper: Show Toast
  const showToast = (msg: string) => {
      setToastMsg(msg);
      setTimeout(() => setToastMsg(''), 2000);
  };

  // Helper: Trigger Agreement Shake
  const triggerAgreementShake = () => {
      setShakeAgreement(true);
      setTimeout(() => setShakeAgreement(false), 500);
  };

  // Helper: Validate Phone
  const isValidPhone = (p: string) => /^1[3-9]\d{9}$/.test(p);

  useEffect(() => {
    let timer: any;
    if (countdown > 0) {
      timer = setInterval(() => setCountdown(prev => prev - 1), 1000);
    }
    return () => clearInterval(timer);
  }, [countdown]);

  const handleSendCode = () => {
      if (!phone) {
          showToast('请输入手机号');
          return;
      }
      if (!isValidPhone(phone)) {
          showToast('手机号格式不正确');
          return;
      }
      setCountdown(60);
      showToast('验证码已发送');
  };

  const handleLogin = (type: 'one-click' | 'sms' | 'password') => {
      // 1. Check Agreement First
      if (!agreed) {
          triggerAgreementShake();
          showToast('请先阅读并同意用户协议');
          return;
      }

      // 2. Validate Inputs based on type (Only for Form mode)
      if (viewMode === 'form') {
          if (!isValidPhone(phone)) {
              showToast('请输入正确的手机号');
              return;
          }
          if (loginMethod === 'sms' && code.length < 4) {
              showToast('请输入有效的验证码');
              return;
          }
          if (loginMethod === 'password' && password.length < 6) {
              showToast('密码长度至少6位');
              return;
          }
      }

      setIsLoading(true);
      setTimeout(() => {
          setIsLoading(false);
          // Mock Success: 
          // If 'one-click' or generic login, assume it's the owner (hasVehicle: true).
          // You can toggle this false to test non-owners.
          onLoginSuccess({
              name: '张越野',
              avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
              id: '88293011',
              vipLevel: 5,
              hasVehicle: true // IMPORTANT: This ensures the Service View shows the car card
          }); 
      }, 1500);
  };

  const handleWeChatLogin = () => {
      if (!agreed) {
          triggerAgreementShake();
          showToast('请先阅读并同意用户协议');
          return;
      }
      setIsLoading(true);
      // Simulate WeChat Auth
      setTimeout(() => {
          setIsLoading(false);
          // Mock: WeChat profile fetched, but need phone binding
          setWechatProfile({
              name: 'WeChat_User',
              avatar: 'https://randomuser.me/api/portraits/men/86.jpg',
              id: 'wx_123456',
              vipLevel: 1
          });
          setViewMode('wechat-bind');
      }, 1000);
  };

  const handleBindPhone = () => {
      if (!phone || !code) {
          showToast('请填写完整信息');
          return;
      }
      setIsLoading(true);
      setTimeout(() => {
          setIsLoading(false);
          // Merge WeChat profile with phone logic
          // Mock Success: WeChat Login -> Bind Phone = No Vehicle yet (New User)
          onLoginSuccess({
              ...wechatProfile,
              phone: phone,
              isUpdated: true,
              hasVehicle: false // New users typically don't have a vehicle bound yet
          });
      }, 1200);
  };

  // --- Sub-Views ---

  const renderMain = () => (
      <div className="flex-1 flex flex-col justify-end p-8 pb-12 animate-in fade-in slide-in-from-bottom-4 duration-500">
          <div className="mb-auto pt-20">
              <h1 className="text-white text-[36px] font-bold mb-3 drop-shadow-md tracking-tight leading-none">
                  悦享越野<br/>探索无界
              </h1>
              <p className="text-white/80 text-[15px] font-medium tracking-wide">北京汽车 · 官方车主服务平台</p>
          </div>

          <div className="w-full space-y-4">
              <button 
                onClick={() => handleLogin('one-click')}
                className="w-full h-14 bg-[#FF6B00] text-white rounded-full font-bold text-[16px] shadow-xl shadow-orange-900/40 active:scale-[0.98] transition-all flex items-center justify-center gap-2 relative overflow-hidden group"
              >
                  {isLoading ? <Loader2 className="animate-spin" /> : (
                      <>
                        <Smartphone size={20} />
                        本机号码一键登录
                      </>
                  )}
                  <div className="absolute inset-0 bg-white/20 translate-y-full group-hover:translate-y-0 transition-transform duration-300 rounded-full" />
              </button>

              <button 
                onClick={() => setViewMode('form')}
                className="w-full h-14 bg-white/10 backdrop-blur-md border border-white/30 text-white rounded-full font-bold text-[16px] active:scale-[0.98] transition-all hover:bg-white/20"
              >
                  其他手机号登录
              </button>
          </div>

          <div className="mt-12 flex flex-col items-center gap-6">
              <div className="flex items-center gap-4 w-full">
                  <div className="h-px bg-white/20 flex-1" />
                  <span className="text-[12px] text-white/60 font-medium">社交账号快速登录</span>
                  <div className="h-px bg-white/20 flex-1" />
              </div>
              
              <button 
                onClick={handleWeChatLogin}
                className="w-12 h-12 bg-[#07C160] rounded-full flex items-center justify-center text-white shadow-lg active:scale-90 transition-transform border border-white/10"
              >
                  <MessageCircle size={24} fill="white" />
              </button>
          </div>

          {renderAgreement()}
      </div>
  );

  const renderForm = () => {
      // Logic: Allow clicking if inputs are filled, even if not agreed (to show hint)
      const isInputsFilled = phone.length > 0 && (loginMethod === 'sms' ? code.length > 0 : password.length > 0);

      return (
        <div className="flex-1 flex flex-col bg-white animate-in slide-in-from-right duration-300">
            <div className="pt-[54px] px-5 pb-4">
                <button onClick={() => setViewMode('main')} className="p-2 -ml-2 text-[#111]">
                    <ArrowLeft size={24} />
                </button>
            </div>
            
            <div className="px-8 pt-4">
                <h2 className="text-[28px] font-bold text-[#111] mb-2">
                    {loginMethod === 'sms' ? '验证码登录' : '密码登录'}
                </h2>
                <div className="text-[13px] text-gray-400 mb-10">
                    未注册手机号验证后自动创建账号
                </div>

                <div className="space-y-6">
                    {/* Phone Input */}
                    <div className="border-b border-gray-100 py-3 flex items-center relative">
                        <span className="text-[16px] font-bold text-[#111] mr-4">+86</span>
                        <input 
                            type="tel" 
                            value={phone}
                            onChange={(e) => setPhone(e.target.value)}
                            placeholder="请输入手机号"
                            className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium font-oswald"
                            maxLength={11}
                        />
                        {phone && (
                            <button onClick={() => setPhone('')} className="p-1">
                                <X size={16} className="text-gray-300" />
                            </button>
                        )}
                    </div>

                    {loginMethod === 'sms' ? (
                        <div className="border-b border-gray-100 py-3 flex items-center">
                            <input 
                                type="number" 
                                value={code}
                                onChange={(e) => setCode(e.target.value)}
                                placeholder="请输入验证码"
                                className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium font-oswald"
                                maxLength={6}
                            />
                            <button 
                                onClick={handleSendCode}
                                disabled={countdown > 0 || !phone}
                                className={`text-[13px] font-bold transition-colors ${
                                    countdown > 0 || !phone ? 'text-gray-300' : 'text-[#FF6B00]'
                                }`}
                            >
                                {countdown > 0 ? `${countdown}s后重发` : '获取验证码'}
                            </button>
                        </div>
                    ) : (
                        <div className="border-b border-gray-100 py-3 flex items-center">
                            <input 
                                type={showPassword ? "text" : "password"} 
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                placeholder="请输入密码"
                                className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium"
                            />
                            <button onClick={() => setShowPassword(!showPassword)} className="text-gray-400">
                                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                            </button>
                        </div>
                    )}
                </div>

                <div className="flex justify-between items-center mt-6 mb-8">
                    <button 
                        onClick={() => setLoginMethod(loginMethod === 'sms' ? 'password' : 'sms')}
                        className="text-[13px] text-[#111] font-bold"
                    >
                        {loginMethod === 'sms' ? '账号密码登录' : '验证码登录'}
                    </button>
                    {loginMethod === 'password' && (
                        <button onClick={() => setViewMode('forgot-pass')} className="text-[13px] text-gray-400">
                            忘记密码?
                        </button>
                    )}
                </div>

                <ActionButton 
                    label="登录" 
                    loading={isLoading}
                    disabled={!isInputsFilled} // Button enabled if inputs filled (even if not agreed) to show toast
                    className="w-full rounded-full"
                    onClick={() => handleLogin(loginMethod)}
                />

                <div className="mt-6">
                    {renderAgreement(true)}
                </div>
            </div>
        </div>
      );
  };

  const renderWechatBind = () => (
      <div className="flex-1 flex flex-col bg-white animate-in slide-in-from-right duration-300">
          <div className="pt-[54px] px-5 pb-4">
              <button onClick={() => setViewMode('main')} className="p-2 -ml-2 text-[#111]">
                  <ArrowLeft size={24} />
              </button>
          </div>
          
          <div className="px-8 pt-2 flex-1">
              <div className="flex flex-col items-center mb-10">
                  <img src={wechatProfile?.avatar} className="w-20 h-20 rounded-full border-4 border-gray-50 mb-3" />
                  <div className="text-[16px] font-bold text-[#111]">{wechatProfile?.name}</div>
                  <div className="text-[12px] text-gray-400 mt-1">为了您的账号安全，请绑定手机号</div>
              </div>

              <div className="space-y-6">
                  <div className="border-b border-gray-100 py-3 flex items-center">
                      <span className="text-[16px] font-bold text-[#111] mr-4">+86</span>
                      <input 
                        type="tel" 
                        value={phone}
                        onChange={(e) => setPhone(e.target.value)}
                        placeholder="请输入手机号"
                        className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium font-oswald"
                      />
                  </div>
                  <div className="border-b border-gray-100 py-3 flex items-center">
                      <input 
                        type="number" 
                        value={code}
                        onChange={(e) => setCode(e.target.value)}
                        placeholder="请输入验证码"
                        className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium font-oswald"
                      />
                      <button 
                        onClick={handleSendCode}
                        disabled={countdown > 0}
                        className={`text-[13px] font-bold ${countdown > 0 ? 'text-gray-300' : 'text-[#FF6B00]'}`}
                      >
                          {countdown > 0 ? `${countdown}s后重发` : '获取验证码'}
                      </button>
                  </div>
              </div>

              <div className="mt-10">
                  <ActionButton 
                    label="绑定并登录" 
                    loading={isLoading}
                    disabled={!phone || !code}
                    className="w-full rounded-full"
                    onClick={handleBindPhone}
                  />
              </div>
          </div>
      </div>
  );

  const renderForgotPass = () => (
      <div className="flex-1 flex flex-col bg-white animate-in slide-in-from-right duration-300">
          <div className="pt-[54px] px-5 pb-4">
              <button onClick={() => setViewMode('form')} className="p-2 -ml-2 text-[#111]">
                  <ArrowLeft size={24} />
              </button>
          </div>
          <div className="px-8 pt-4">
              <h2 className="text-[24px] font-bold text-[#111] mb-2">重置密码</h2>
              <div className="text-[13px] text-gray-400 mb-8">验证手机号以设置新密码</div>
              
              <div className="space-y-6">
                  <div className="border-b border-gray-100 py-3 flex items-center">
                      <input 
                        type="tel" 
                        value={phone}
                        onChange={(e) => setPhone(e.target.value)}
                        placeholder="请输入注册手机号"
                        className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium font-oswald"
                      />
                  </div>
                  <div className="border-b border-gray-100 py-3 flex items-center">
                      <input 
                        type="number" 
                        value={code}
                        onChange={(e) => setCode(e.target.value)}
                        placeholder="请输入验证码"
                        className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium font-oswald"
                      />
                      <button onClick={handleSendCode} className="text-[13px] font-bold text-[#FF6B00]">获取验证码</button>
                  </div>
                  <div className="border-b border-gray-100 py-3 flex items-center">
                      <input 
                        type="password" 
                        placeholder="请输入新密码 (8-16位)"
                        className="flex-1 text-[16px] outline-none placeholder:text-gray-300 font-medium"
                      />
                  </div>
              </div>

              <div className="mt-10">
                  <ActionButton 
                    label="确认重置" 
                    onClick={() => {
                        showToast('密码重置成功');
                        setTimeout(() => setViewMode('form'), 1500);
                    }}
                    className="w-full rounded-full"
                  />
              </div>
          </div>
      </div>
  );

  const renderAgreement = (darkText = false) => (
      <div 
        className={`mt-auto pt-6 pb-2 flex items-start gap-2 justify-center transition-all duration-300 ${
            shakeAgreement ? 'animate-shake' : ''
        }`}
      >
          <button 
            onClick={() => setAgreed(!agreed)}
            className={`w-4 h-4 mt-0.5 rounded-full border flex items-center justify-center transition-all ${
                agreed 
                ? (darkText ? 'bg-[#111] border-[#111]' : 'bg-[#FF6B00] border-[#FF6B00]') 
                : (shakeAgreement ? 'border-red-500 bg-red-50/20' : (darkText ? 'border-gray-300' : 'border-white/50'))
            }`}
          >
              {agreed && <CheckCircle2 size={12} className="text-white" />}
          </button>
          <div className={`text-[11px] leading-tight ${
              shakeAgreement ? 'text-red-500' : (darkText ? 'text-gray-500' : 'text-white/60')
          }`}>
              我已阅读并同意
              <span className={`font-bold mx-1 ${darkText ? 'text-[#111]' : 'text-white'}`}>《用户协议》</span>
              和
              <span className={`font-bold mx-1 ${darkText ? 'text-[#111]' : 'text-white'}`}>《隐私政策》</span>
              <br/>未注册手机号验证后将自动创建账号
          </div>
      </div>
  );

  return (
    <div className="absolute inset-0 z-[2000] bg-black flex flex-col overflow-hidden animate-in fade-in duration-300">
        {/* Updated Background: More rugged, dark, starry off-road theme */}
        <div className="absolute inset-0 z-0">
            <div className="absolute inset-0 bg-black/30 z-10" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-black/40 z-10" />
            <img 
                src="https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1920&auto=format&fit=crop" 
                className="w-full h-full object-cover" 
                alt="Login Background"
            />
        </div>

        {/* Close Button (Only on Main View) */}
        {viewMode === 'main' && (
            <button 
                onClick={onClose}
                className="absolute top-[54px] right-5 z-20 w-8 h-8 bg-white/10 backdrop-blur-md rounded-full flex items-center justify-center text-white active:bg-white/20 border border-white/10"
            >
                <X size={18} />
            </button>
        )}

        <div className="relative z-10 w-full h-full flex flex-col">
            {viewMode === 'main' && renderMain()}
            {viewMode === 'form' && renderForm()}
            {viewMode === 'wechat-bind' && renderWechatBind()}
            {viewMode === 'forgot-pass' && renderForgotPass()}
        </div>

        {/* Custom Toast Notification */}
        {toastMsg && (
            <div className="absolute top-[10%] left-1/2 -translate-x-1/2 z-[3000] animate-in fade-in slide-in-from-top-4 duration-300">
                <div className="bg-[#111]/90 backdrop-blur-xl text-white px-5 py-3 rounded-full shadow-2xl flex items-center gap-2 border border-white/10">
                    <AlertCircle size={18} className="text-[#FF6B00]" />
                    <span className="text-[13px] font-bold">{toastMsg}</span>
                </div>
            </div>
        )}

        <style>{`
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                20% { transform: translateX(-6px); }
                40% { transform: translateX(6px); }
                60% { transform: translateX(-3px); }
                80% { transform: translateX(3px); }
            }
            .animate-shake {
                animation: shake 0.4s ease-in-out;
            }
        `}</style>
    </div>
  );
};

export default LoginView;
