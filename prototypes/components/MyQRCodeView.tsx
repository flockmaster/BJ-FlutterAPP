
import React from 'react';
import { Share2, Download, ShieldCheck, MoreHorizontal, QrCode } from 'lucide-react';
import { IconButton } from './ui/Button';
import { NavBar } from './ui/NavBar';

interface MyQRCodeViewProps {
  onBack: () => void;
}

const MyQRCodeView: React.FC<MyQRCodeViewProps> = ({ onBack }) => {
  return (
    <div className="w-full h-full bg-[#F5F7FA] flex flex-col overflow-hidden">
      {/* 
        1. Transparent NavBar: 
        Sets transparent={true} so the header background blends perfectly with the page.
      */}
      <NavBar 
        title="我的二维码" 
        onBack={onBack} 
        transparent={true}
        rightAction={<IconButton icon={MoreHorizontal} variant="ghost" />}
      />

      {/* 
        2. Content Container:
        Adjusted padding and removed negative margins to ensure the QR card 
        is perfectly balanced in the immersive layout.
      */}
      <div className="flex-1 flex flex-col items-center justify-center p-6 pt-[100px]">
          {/* QR Card Container - Balanced radius to rounded-3xl for premium card look */}
          <div className="bg-white w-full max-w-sm rounded-[32px] p-8 shadow-[0_15px_45px_rgba(0,0,0,0.06)] border border-gray-50 flex flex-col items-center animate-in zoom-in-95 duration-500">
              
              {/* Profile Info */}
              <div className="flex items-center gap-4 w-full mb-10">
                  <div className="relative">
                    <img 
                        src="https://randomuser.me/api/portraits/men/75.jpg" 
                        className="w-16 h-16 rounded-full border-2 border-gray-50 shadow-sm"
                        alt="User Avatar"
                    />
                    <div className="absolute -bottom-1 -right-1 bg-[#111] text-[#E5C07B] rounded-full border-2 border-white p-0.5">
                        <ShieldCheck size={10} />
                    </div>
                  </div>
                  <div className="flex-1 text-left">
                      <div className="text-[20px] font-bold text-[#111] mb-0.5">张越野</div>
                      <div className="text-[12px] text-gray-400 font-medium">BJ40 城市猎人版 · 北京</div>
                  </div>
              </div>
              
              {/* QR Code Graphic - Balanced rounding */}
              <div className="w-full aspect-square bg-[#F9FAFB] rounded-2xl p-6 mb-10 flex items-center justify-center relative overflow-hidden">
                  {/* Decorative background for QR */}
                  <div className="absolute inset-0 opacity-[0.03] pointer-events-none">
                      <QrCode size={400} className="text-[#111] rotate-12 -translate-x-10" />
                  </div>
                  
                  <div className="bg-white p-4 rounded-xl shadow-xl relative z-10 border border-gray-50">
                      <QrCode size={180} className="text-[#111]" strokeWidth={1.5} />
                  </div>
              </div>

              <div className="text-[13px] text-gray-400 text-center leading-relaxed max-w-[200px]">
                  扫一扫上面的二维码图案，<br/>加我为车友
              </div>
          </div>

          {/* Action Buttons - Middle Ground Rounding (rounded-2xl) */}
          <div className="mt-12 flex gap-10">
              <button className="flex flex-col items-center gap-3 active:scale-95 transition-transform group">
                  <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center text-[#111] shadow-lg shadow-black/5 border border-gray-100 group-hover:bg-gray-50">
                      <Download size={24} />
                  </div>
                  <span className="text-[13px] font-bold text-gray-500">保存到相册</span>
              </button>
              <button className="flex flex-col items-center gap-3 active:scale-95 transition-transform group">
                  <div className="w-14 h-14 bg-[#111] rounded-2xl flex items-center justify-center text-white shadow-lg shadow-black/10 group-hover:bg-black/80">
                      <Share2 size={24} />
                  </div>
                  <span className="text-[13px] font-bold text-[#111]">分享给好友</span>
              </button>
          </div>
      </div>

      {/* Footer Branding */}
      <div className="pb-12 flex flex-col items-center opacity-20 grayscale">
          <img src="https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=100&auto=format&fit=crop" className="h-6 object-contain mb-2" />
          <span className="text-[10px] font-bold tracking-widest text-gray-400 uppercase">BAIC Official Social ID</span>
      </div>
    </div>
  );
};

export default MyQRCodeView;
