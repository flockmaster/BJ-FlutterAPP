import React, { useState } from 'react';
import { ArrowLeft, Smartphone, MessageCircle, ChevronRight, AlertTriangle, Apple } from 'lucide-react';

interface AccountBindingViewProps {
  onBack: () => void;
}

const AccountBindingView: React.FC<AccountBindingViewProps> = ({ onBack }) => {
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  return (
    <div className="absolute inset-0 z-[200] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
        <div className="pt-[54px] px-5 pb-3 flex items-center gap-3 bg-white border-b border-gray-100">
            <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                <ArrowLeft size={24} className="text-[#111]" />
            </button>
            <div className="text-[17px] font-bold text-[#111]">账号绑定</div>
        </div>

        <div className="p-5 space-y-4 flex-1">
            <div className="bg-white rounded-[20px] overflow-hidden shadow-sm border border-gray-50">
                <BindingItem 
                    icon={Smartphone} 
                    title="手机号" 
                    value="138****8888" 
                    isBound 
                />
                <BindingItem 
                    icon={MessageCircle} 
                    title="微信" 
                    value="未绑定" 
                    isBound={false} 
                />
                <BindingItem 
                    icon={Apple} 
                    title="Apple ID" 
                    value="未绑定" 
                    isBound={false} 
                    isLast
                />
            </div>
            
            <div className="text-[12px] text-gray-400 px-2 leading-relaxed">
                * 绑定第三方账号后，可直接使用第三方账号登录，账号更安全，登录更便捷。<br/>
                * 若手机号已停用，请及时更换绑定手机。
            </div>
        </div>

        <div className="pb-10 px-5 flex justify-center">
            <button 
                onClick={() => setShowDeleteModal(true)}
                className="text-[12px] text-gray-400 hover:text-red-500 transition-colors underline decoration-gray-300 underline-offset-4 active:opacity-60"
            >
                注销账号
            </button>
        </div>

        {/* Refined Delete Account Modal */}
        {showDeleteModal && (
            <div className="absolute inset-0 z-[300] flex items-center justify-center p-6">
              <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200" onClick={() => setShowDeleteModal(false)} />
              <div className="bg-white w-full max-w-[310px] rounded-[28px] p-6 relative z-10 animate-in zoom-in-95 duration-200 shadow-2xl border border-white">
                  <div className="w-11 h-11 bg-red-50 rounded-2xl flex items-center justify-center mx-auto mb-4 text-red-500">
                      <AlertTriangle size={24} />
                  </div>
                  <h3 className="text-[18px] font-bold text-[#111] mb-2 text-center">注销北京汽车账号</h3>
                  <div className="text-[12px] text-gray-500 mb-6 bg-gray-50 p-4 rounded-xl leading-relaxed border border-gray-100">
                      <p className="mb-1.5 font-bold text-red-500/80">注销后不可恢复：</p>
                      <ul className="list-disc pl-4 space-y-0.5">
                          <li>车辆绑定关系、积分、权益</li>
                          <li>交易记录及所有历史订单</li>
                      </ul>
                  </div>
                  <div className="flex flex-col gap-2.5">
                      <button 
                        onClick={() => setShowDeleteModal(false)}
                        className="w-full h-12 bg-[#111] rounded-2xl text-white font-bold text-[14px] active:scale-[0.98] transition-all shadow-md shadow-black/10"
                      >
                          暂不注销
                      </button>
                      <button 
                        onClick={() => {
                            setShowDeleteModal(false);
                            alert('已提交注销申请，账号将在7天后自动解绑。');
                            onBack();
                        }}
                        className="w-full h-12 bg-gray-50 border border-gray-100 text-gray-400 rounded-2xl font-bold text-[14px] active:bg-red-50 active:text-red-500 active:border-red-100 transition-colors"
                      >
                          确认注销
                      </button>
                  </div>
              </div>
          </div>
        )}
    </div>
  );
};

const BindingItem = ({ icon: Icon, title, value, isBound, isLast }: any) => (
    <div className={`flex items-center justify-between p-5 active:bg-gray-50 transition-colors cursor-pointer ${!isLast ? 'border-b border-gray-50' : ''}`}>
        <div className="flex items-center gap-4">
            <div className="text-[#333] shrink-0">
                <Icon size={20} strokeWidth={2} />
            </div>
            <span className="text-[15px] font-bold text-[#111]">{title}</span>
        </div>
        <div className="flex items-center gap-2">
            <span className={`text-[13px] ${isBound ? 'text-gray-400' : 'text-[#FF6B00] font-bold'}`}>
                {value}
            </span>
            <ChevronRight size={16} className="text-gray-300" />
        </div>
    </div>
);

export default AccountBindingView;