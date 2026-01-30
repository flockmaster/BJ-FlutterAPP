
import React, { useState } from 'react';
import { ArrowLeft, Send, Headphones, HelpCircle, Phone, Smartphone, User, MessageCircle } from 'lucide-react';

interface CustomerServiceViewProps {
  onBack: () => void;
}

const CustomerServiceView: React.FC<CustomerServiceViewProps> = ({ onBack }) => {
  const [messages, setMessages] = useState([
      { type: 'system', text: '您好，欢迎联系北京汽车专属客服。' },
      { type: 'agent', text: '我是金牌客服小北，很高兴为您服务。请问有什么可以帮您？' }
  ]);
  const [input, setInput] = useState('');

  const handleSend = () => {
      if (!input.trim()) return;
      setMessages([...messages, { type: 'user', text: input }]);
      setInput('');
      setTimeout(() => {
          setMessages(prev => [...prev, { type: 'agent', text: '好的，我已收到您的提问，正在为您联系相关部门查询，请稍等片刻...' }]);
      }, 1000);
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header - V3.1 Standard */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100 z-10">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 active:scale-90 transition-all">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="flex flex-col items-center">
            <div className="text-[17px] font-bold text-[#111]">专属客服</div>
            <div className="flex items-center gap-1">
                <span className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" />
                <span className="text-[10px] text-gray-400 font-medium">官方产品专家在线</span>
            </div>
        </div>
        <button className="w-10 h-10 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50 active:scale-90 transition-all">
            <Phone size={20} className="text-[#111]" />
        </button>
      </div>

      {/* Chat Area - Air Layout */}
      <div className="flex-1 overflow-y-auto p-5 space-y-6 no-scrollbar">
          {messages.map((msg, i) => (
              <div key={i} className={`flex ${msg.type === 'user' ? 'justify-end' : 'justify-start'}`}>
                  {msg.type !== 'user' && (
                      <div className="w-9 h-9 rounded-2xl bg-[#111] flex items-center justify-center mr-3 text-white shadow-sm shrink-0">
                          <Headphones size={18} />
                      </div>
                  )}
                  <div className={`max-w-[78%] px-4 py-3 text-[14px] leading-relaxed shadow-[0_2px_12px_rgba(0,0,0,0.03)] ${
                      msg.type === 'user' 
                        ? 'bg-[#111] text-white rounded-2xl rounded-tr-none' 
                        : 'bg-white text-[#333] rounded-2xl rounded-tl-none border border-gray-50'
                  }`}>
                      {msg.text}
                  </div>
              </div>
          ))}
      </div>

      {/* Input Area - Radius-L (24px) for visual comfort */}
      <div className="bg-white p-5 border-t border-gray-100 pb-[38px] z-20">
          <div className="flex gap-2.5 mb-5 overflow-x-auto no-scrollbar">
              {['保养政策', '道路救援', '车机升级', '积分兑换'].map(tag => (
                  <button key={tag} className="px-4 py-2 bg-[#F5F7FA] text-[12px] text-gray-500 font-bold rounded-xl whitespace-nowrap border border-gray-100 active:bg-gray-100 transition-colors">
                      {tag}
                  </button>
              ))}
          </div>
          <div className="flex gap-3 items-center">
              <div className="flex-1 bg-[#F5F7FA] rounded-2xl px-5 py-3.5 border border-transparent focus-within:border-[#111] focus-within:bg-white transition-all flex items-center">
                  <input 
                    type="text" 
                    value={input}
                    onChange={e => setInput(e.target.value)}
                    onKeyDown={e => e.key === 'Enter' && handleSend()}
                    className="flex-1 bg-transparent text-[15px] outline-none text-[#111] placeholder:text-gray-400"
                    placeholder="请输入您的问题..."
                  />
                  <div className="w-8 h-8 rounded-full flex items-center justify-center text-gray-300">
                    <MessageCircle size={18} />
                  </div>
              </div>
              <button 
                onClick={handleSend}
                disabled={!input.trim()}
                className={`w-12 h-12 rounded-full flex items-center justify-center transition-all active:scale-90 shadow-lg ${
                    input.trim() ? 'bg-[#111] text-white shadow-black/10' : 'bg-gray-100 text-gray-300'
                }`}
              >
                  <Send size={20} className={input.trim() ? 'translate-x-0.5 -translate-y-0.5' : ''} />
              </button>
          </div>
      </div>
    </div>
  );
};

export default CustomerServiceView;
