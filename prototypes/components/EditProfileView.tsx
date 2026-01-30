
import React, { useState, useRef } from 'react';
import { ArrowLeft, Camera, User, CheckCircle2, MessageCircle, Loader2 } from 'lucide-react';

interface EditProfileViewProps {
  initialName: string;
  initialAvatar: string;
  onBack: () => void;
  onSave: (name: string, avatar: string) => void;
}

const EditProfileView: React.FC<EditProfileViewProps> = ({ initialName, initialAvatar, onBack, onSave }) => {
  const [name, setName] = useState(initialName);
  const [avatar, setAvatar] = useState(initialAvatar);
  const [isSaving, setIsSaving] = useState(false);
  const [isSyncing, setIsSyncing] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setAvatar(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSave = () => {
    if (!name.trim()) return;
    setIsSaving(true);
    // Simulate API call
    setTimeout(() => {
        onSave(name, avatar);
        setIsSaving(false);
    }, 800);
  };

  const handleSyncWechat = () => {
      setIsSyncing(true);
      // Simulate WeChat Info Fetch
      setTimeout(() => {
          // This simulates a long name coming from WeChat to test the truncation in MineView
          setName('微信用户_张越野');
          setAvatar('https://randomuser.me/api/portraits/men/86.jpg');
          setIsSyncing(false);
      }, 1000);
  };

  return (
    <div className="absolute inset-0 z-[200] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">完善资料</div>
        <button 
            onClick={handleSave}
            disabled={isSaving || !name.trim()}
            className={`px-4 py-1.5 rounded-full text-[13px] font-bold transition-all ${
                name.trim() && !isSaving 
                ? 'bg-[#111] text-white active:scale-95' 
                : 'bg-gray-100 text-gray-400'
            }`}
        >
            {isSaving ? '保存中...' : '保存'}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto p-8">
          <div className="flex flex-col items-center mb-10">
              <div 
                onClick={() => fileInputRef.current?.click()}
                className="relative group cursor-pointer active:scale-95 transition-transform"
              >
                  <div className="w-24 h-24 rounded-full overflow-hidden border-[4px] border-gray-50 shadow-lg bg-gray-100">
                      <img src={avatar} className="w-full h-full object-cover" />
                  </div>
                  <div className="absolute bottom-0 right-0 w-8 h-8 bg-[#111] rounded-full flex items-center justify-center text-white border-2 border-white shadow-sm">
                      <Camera size={14} />
                  </div>
                  <input 
                    type="file" 
                    ref={fileInputRef} 
                    className="hidden" 
                    accept="image/*"
                    onChange={handleFileChange}
                  />
              </div>
              <p className="mt-4 text-[12px] text-gray-400">点击修改头像</p>
          </div>

          <div className="space-y-6">
              <div>
                  <div className="flex justify-between items-baseline mb-2 ml-1">
                      <label className="text-[14px] font-bold text-[#111]">昵称</label>
                      <span className={`text-[11px] ${name.length > 12 ? 'text-red-500' : 'text-gray-400'}`}>
                          {name.length}/12
                      </span>
                  </div>
                  <div className="flex items-center bg-[#F5F7FA] rounded-2xl px-4 py-3.5 focus-within:ring-1 focus-within:ring-[#111] transition-all">
                      <User size={18} className="text-gray-400 mr-3" />
                      <input 
                        type="text" 
                        value={name} 
                        onChange={(e) => setName(e.target.value)}
                        className="flex-1 bg-transparent outline-none text-[15px] font-medium text-[#111] placeholder:text-gray-400"
                        placeholder="请输入您的昵称"
                        maxLength={12}
                      />
                      {name.length > 0 && (
                          <button onClick={() => setName('')} className="bg-gray-200 rounded-full p-0.5 ml-2 text-white flex items-center justify-center w-4 h-4">
                              <span className="text-[10px] font-bold">×</span>
                          </button>
                      )}
                  </div>
                  <p className="text-[11px] text-gray-400 mt-2 ml-1">昵称支持中英文、数字，限12个字符</p>
              </div>

              {/* Sync WeChat Button */}
              <button
                  onClick={handleSyncWechat}
                  disabled={isSyncing}
                  className="w-full h-12 rounded-2xl bg-[#07C160]/10 text-[#07C160] font-bold text-[14px] flex items-center justify-center gap-2 active:scale-95 transition-transform hover:bg-[#07C160]/20"
              >
                  {isSyncing ? (
                      <Loader2 size={18} className="animate-spin" />
                  ) : (
                      <MessageCircle size={18} />
                  )}
                  {isSyncing ? '同步中...' : '同步微信昵称头像'}
              </button>
          </div>
      </div>
    </div>
  );
};

export default EditProfileView;
