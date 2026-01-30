import React, { useState, useEffect, useRef } from 'react';
import { X, Send, Bot } from 'lucide-react';
import { generateChatResponse } from '../services/geminiService';
import { CarModel, ChatMessage } from '../types';

interface AIChatModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentCar: CarModel;
}

const AIChatModal: React.FC<AIChatModalProps> = ({ isOpen, onClose, currentCar }) => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isOpen && messages.length === 0) {
      setMessages([
        {
          role: 'model',
          text: `您好！我是您的专属AI顾问。我看到您对 ${currentCar.fullName} 感兴趣，有什么我可以帮您的吗？`,
          timestamp: Date.now()
        }
      ]);
    }
  }, [isOpen, currentCar, messages.length]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim() || isLoading) return;

    const userMsg: ChatMessage = { role: 'user', text: input, timestamp: Date.now() };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setIsLoading(true);

    // Format history for Gemini
    const history = messages.map(m => ({
      role: m.role,
      parts: [{ text: m.text }]
    }));

    const responseText = await generateChatResponse(input, currentCar, history);

    const modelMsg: ChatMessage = { role: 'model', text: responseText, timestamp: Date.now() };
    setMessages(prev => [...prev, modelMsg]);
    setIsLoading(false);
  };

  if (!isOpen) return null;

  return (
    <div className="absolute inset-0 z-[2000] flex items-end justify-center pointer-events-none">
      {/* 遮罩层 - z-index设置为10 */}
      <div 
        className="absolute inset-0 bg-black/60 backdrop-blur-[2px] pointer-events-auto z-10 transition-opacity duration-300" 
        onClick={onClose} 
      />
      
      {/* 聊天内容容器 - z-index设置为20，确保在遮罩之上 */}
      <div className="relative z-20 w-full h-[85%] bg-white rounded-t-2xl shadow-2xl flex flex-col pointer-events-auto animate-in slide-in-from-bottom duration-300">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-gray-100 bg-white rounded-t-2xl z-30">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-[#1A1A1A] to-[#333] flex items-center justify-center text-white shadow-md">
              <Bot size={20} />
            </div>
            <div>
              <h3 className="font-bold text-[#1A1A1A]">AI 产品顾问</h3>
              <p className="text-xs text-green-500 font-medium flex items-center gap-1">
                <span className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" /> 在线
              </p>
            </div>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-full transition-colors active:bg-gray-200">
            <X size={20} className="text-gray-500" />
          </button>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-[#F7F8FA]">
          {messages.map((msg, idx) => (
            <div key={idx} className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}>
              <div className={`max-w-[85%] rounded-2xl px-4 py-3 text-sm shadow-sm leading-relaxed ${
                msg.role === 'user' 
                  ? 'bg-[#1A1A1A] text-white rounded-br-none' 
                  : 'bg-white text-[#1A1A1A] border border-gray-100 rounded-bl-none'
              }`}>
                {msg.text}
              </div>
            </div>
          ))}
          {isLoading && (
            <div className="flex justify-start">
               <div className="bg-white border border-gray-100 rounded-2xl rounded-bl-none px-4 py-3 shadow-sm">
                 <div className="flex gap-1.5">
                   <span className="w-1.5 h-1.5 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                   <span className="w-1.5 h-1.5 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                   <span className="w-1.5 h-1.5 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
                 </div>
               </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        {/* Input */}
        <div className="p-4 border-t border-gray-100 bg-white pb-[30px] z-30">
          <div className="flex gap-2">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSend()}
              placeholder="询问关于车型的问题..."
              className="flex-1 bg-[#F5F5F5] border-0 rounded-full px-5 py-3 text-sm focus:ring-2 focus:ring-[#1A1A1A] focus:outline-none transition-all placeholder:text-gray-400"
            />
            <button 
              onClick={handleSend}
              disabled={isLoading || !input.trim()}
              className="w-11 h-11 bg-[#1A1A1A] text-white rounded-full flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#333] transition-colors shadow-sm active:scale-95"
            >
              <Send size={18} />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AIChatModal;