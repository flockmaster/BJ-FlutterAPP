
import React, { useState } from 'react';
import { ArrowLeft, Flashlight, Image, ScanLine, QrCode } from 'lucide-react';

interface ScanQRCodeViewProps {
  onBack: () => void;
  initialTab?: 'scan' | 'code';
}

const ScanQRCodeView: React.FC<ScanQRCodeViewProps> = ({ onBack, initialTab = 'scan' }) => {
  const [activeTab, setActiveTab] = useState<'scan' | 'code'>(initialTab);

  return (
    <div className="absolute inset-0 z-[150] bg-black flex flex-col animate-in fade-in duration-300">
      
      {/* Background & Content Wrapper */}
      <div className="flex-1 relative flex flex-col">
          
          {activeTab === 'scan' ? (
              // --- SCAN MODE ---
              <>
                  {/* Camera Simulation */}
                  <div 
                    className="absolute inset-0 bg-cover bg-center opacity-60"
                    style={{backgroundImage: 'url(https://images.unsplash.com/photo-1550989460-0adf9ea622e2?q=80&w=800&auto=format&fit=crop)'}} 
                  />
                  
                  {/* Scan UI Overlay */}
                  <div className="absolute inset-0 z-10 flex flex-col">
                      {/* Header */}
                      <div className="pt-[54px] px-5 pb-4 flex justify-between items-center text-white">
                          <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-white/20 transition-colors">
                              <ArrowLeft size={24} />
                          </button>
                      </div>

                      {/* Scanner Box */}
                      <div className="flex-1 flex flex-col items-center justify-center -mt-20">
                          <div className="w-[260px] h-[260px] relative">
                              <div className="absolute inset-0 border-2 border-white/30 rounded-[24px]" />
                              {/* Corners */}
                              <div className="absolute top-0 left-0 w-6 h-6 border-t-4 border-l-4 border-[#FF6B00] rounded-tl-[4px]" />
                              <div className="absolute top-0 right-0 w-6 h-6 border-t-4 border-r-4 border-[#FF6B00] rounded-tr-[4px]" />
                              <div className="absolute bottom-0 left-0 w-6 h-6 border-b-4 border-l-4 border-[#FF6B00] rounded-bl-[4px]" />
                              <div className="absolute bottom-0 right-0 w-6 h-6 border-b-4 border-r-4 border-[#FF6B00] rounded-br-[4px]" />
                              
                              {/* Laser Line */}
                              <div className="absolute top-0 left-2 right-2 h-0.5 bg-[#FF6B00] shadow-[0_0_10px_#FF6B00] animate-[scan_2s_linear_infinite]" />
                          </div>
                          <div className="mt-6 text-white/80 text-[13px] font-medium bg-black/40 px-4 py-1.5 rounded-full backdrop-blur-md">
                              将二维码放入框内，即可自动扫描
                          </div>
                      </div>

                      {/* Tools */}
                      <div className="pb-10 flex justify-center gap-12 text-white">
                          <button className="flex flex-col items-center gap-2 opacity-80 active:opacity-100">
                              <div className="w-12 h-12 rounded-full bg-white/10 backdrop-blur-md flex items-center justify-center">
                                  <Flashlight size={20} />
                              </div>
                              <span className="text-[12px]">手电筒</span>
                          </button>
                          <button className="flex flex-col items-center gap-2 opacity-80 active:opacity-100">
                              <div className="w-12 h-12 rounded-full bg-white/10 backdrop-blur-md flex items-center justify-center">
                                  <Image size={20} />
                              </div>
                              <span className="text-[12px]">相册</span>
                          </button>
                      </div>
                  </div>
              </>
          ) : (
              // --- MY CODE MODE ---
              <div className="absolute inset-0 bg-[#F5F7FA] flex flex-col">
                  {/* Header */}
                  <div className="pt-[54px] px-5 pb-4 flex justify-between items-center text-[#111]">
                      <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-black/5 transition-colors">
                          <ArrowLeft size={24} />
                      </button>
                      <div className="text-[17px] font-bold">我的二维码</div>
                      <div className="w-8" />
                  </div>

                  <div className="flex-1 flex flex-col items-center justify-center -mt-20 p-5">
                      <div className="bg-white w-full max-w-sm rounded-[24px] p-8 shadow-xl flex flex-col items-center">
                          <div className="flex items-center gap-4 w-full mb-8">
                              <img src="https://randomuser.me/api/portraits/men/75.jpg" className="w-14 h-14 rounded-full border border-gray-100" />
                              <div className="flex-1 text-left">
                                  <div className="text-[18px] font-bold text-[#111] mb-1">张越野</div>
                                  <div className="text-[12px] text-gray-400">北京汽车 · 越野世家</div>
                              </div>
                          </div>
                          
                          {/* QR Placeholder */}
                          <div className="w-64 h-64 bg-[#111] p-2 rounded-xl mb-4">
                              <div className="w-full h-full bg-white rounded-lg flex items-center justify-center">
                                  <QrCode size={180} className="text-[#111]" />
                              </div>
                          </div>

                          <div className="text-[12px] text-gray-400 text-center leading-relaxed">
                              扫一扫上面的二维码图案，加我为车友
                          </div>
                      </div>
                  </div>
              </div>
          )}
      </div>

      {/* Bottom Tabs */}
      <div className="h-[80px] bg-black/90 backdrop-blur-md flex items-center justify-center gap-16 relative z-20">
          <button 
            onClick={() => setActiveTab('scan')}
            className={`flex flex-col items-center gap-1 transition-all ${activeTab === 'scan' ? 'text-[#FF6B00]' : 'text-white/50'}`}
          >
              <ScanLine size={24} />
              <span className="text-[12px] font-medium">扫一扫</span>
          </button>
          <button 
            onClick={() => setActiveTab('code')}
            className={`flex flex-col items-center gap-1 transition-all ${activeTab === 'code' ? 'text-[#FF6B00]' : 'text-white/50'}`}
          >
              <QrCode size={24} />
              <span className="text-[12px] font-medium">我的码</span>
          </button>
      </div>

      <style>{`
        @keyframes scan {
            0% { top: 2%; opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { top: 98%; opacity: 0; }
        }
      `}</style>
    </div>
  );
};

export default ScanQRCodeView;
