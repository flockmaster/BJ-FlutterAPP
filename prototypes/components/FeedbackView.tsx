
import React, { useState } from 'react';
import { ArrowLeft, Camera, Send, MessageSquareWarning, Lightbulb, ThumbsUp, AlertCircle } from 'lucide-react';

interface FeedbackViewProps {
  onBack: () => void;
}

const FeedbackView: React.FC<FeedbackViewProps> = ({ onBack }) => {
  const [type, setType] = useState<'complaint' | 'suggestion' | 'praise'>('complaint');
  const [content, setContent] = useState('');
  const [contact, setContact] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = () => {
      if (!content.trim()) return;
      setIsSubmitting(true);
      setTimeout(() => {
          setIsSubmitting(false);
          alert('提交成功！我们会尽快处理您的反馈。');
          onBack();
      }, 1500);
  };

  return (
    <div className="absolute inset-0 z-[300] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">投诉建议</div>
        <div className="w-9" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-6">
          
          {/* Type Selection */}
          <div className="bg-white rounded-[20px] p-4 shadow-sm">
              <div className="text-[14px] font-bold text-[#111] mb-3">反馈类型</div>
              <div className="flex gap-3">
                  <TypeButton 
                    active={type === 'complaint'} 
                    onClick={() => setType('complaint')} 
                    icon={MessageSquareWarning} 
                    label="功能异常" 
                  />
                  <TypeButton 
                    active={type === 'suggestion'} 
                    onClick={() => setType('suggestion')} 
                    icon={Lightbulb} 
                    label="产品建议" 
                  />
                  <TypeButton 
                    active={type === 'praise'} 
                    onClick={() => setType('praise')} 
                    icon={ThumbsUp} 
                    label="服务表扬" 
                  />
              </div>
          </div>

          {/* Content Input */}
          <div className="bg-white rounded-[20px] p-4 shadow-sm">
              <div className="text-[14px] font-bold text-[#111] mb-3">详细描述</div>
              <textarea 
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  className="w-full h-32 bg-[#F9FAFB] rounded-xl p-3 text-[14px] outline-none resize-none placeholder:text-gray-400"
                  placeholder="请详细描述您遇到的问题或建议，以便我们快速定位..."
              />
              
              {/* Image Upload Placeholder */}
              <div className="mt-4 flex gap-3">
                  <button className="w-20 h-20 bg-[#F9FAFB] rounded-xl border border-dashed border-gray-300 flex flex-col items-center justify-center text-gray-400 active:bg-gray-100">
                      <Camera size={20} className="mb-1" />
                      <span className="text-[10px]">添加图片</span>
                  </button>
              </div>
          </div>

          {/* Contact Info */}
          <div className="bg-white rounded-[20px] p-4 shadow-sm">
              <div className="text-[14px] font-bold text-[#111] mb-3">联系方式 (选填)</div>
              <input 
                  type="text" 
                  value={contact}
                  onChange={(e) => setContact(e.target.value)}
                  className="w-full bg-[#F9FAFB] rounded-xl px-4 py-3 text-[14px] outline-none"
                  placeholder="手机号/邮箱/微信号"
              />
          </div>

          <div className="flex items-start gap-2 px-2">
              <AlertCircle size={14} className="text-gray-400 mt-0.5 shrink-0" />
              <p className="text-[11px] text-gray-400 leading-relaxed">
                  您的反馈将直接发送至北京汽车客户体验中心，我们承诺保护您的隐私信息。
              </p>
          </div>
      </div>

      {/* Footer */}
      <div className="p-5 bg-white border-t border-gray-100 pb-[34px]">
          <button 
            onClick={handleSubmit}
            disabled={!content.trim() || isSubmitting}
            className="w-full h-12 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-lg flex items-center justify-center gap-2 active:scale-95 transition-transform disabled:bg-gray-200 disabled:text-gray-400 disabled:shadow-none"
          >
              {isSubmitting ? '提交中...' : '提交反馈'}
              {!isSubmitting && <Send size={16} />}
          </button>
      </div>
    </div>
  );
};

const TypeButton: React.FC<{ active: boolean, onClick: () => void, icon: any, label: string }> = ({ active, onClick, icon: Icon, label }) => (
    <button 
        onClick={onClick}
        className={`flex-1 py-3 rounded-xl flex flex-col items-center gap-1.5 border transition-all ${
            active 
                ? 'bg-[#111] text-white border-[#111] shadow-md' 
                : 'bg-white text-gray-500 border-gray-100 hover:bg-gray-50'
        }`}
    >
        <Icon size={18} />
        <span className="text-[12px] font-medium">{label}</span>
    </button>
);

export default FeedbackView;
