
import React, { useState } from 'react';
import { ArrowLeft, Flashlight, Image, ScanLine, Zap, Keyboard } from 'lucide-react';

interface UnifiedScannerViewProps {
  onBack: () => void;
}

const UnifiedScannerView: React.FC<UnifiedScannerViewProps> = ({ onBack }) => {
  const [scanMode, setScanMode] = useState<'general' | 'charging'>('general');

  return (
    <div className="w-full h-full bg-black flex flex-col overflow-hidden relative">
      
      {/* Camera Feed Simulation */}
      <div 
        className="absolute inset-0 bg-cover bg-center opacity-70 transition-all duration-700"
        style={{
            backgroundImage: scanMode === 'general' 
                ? 'url(https://images.unsplash.com/photo-1550989460-0adf9ea622e2?q=80&w=800&auto=format&fit=crop)'
                : 'url(https://images.unsplash.com/photo-1597423244039-992b67f69d31?q=80&w=1200&auto=format&fit=crop)'
        }} 
      />
      
      {/* Scan UI Overlay */}
      <div className="absolute inset-0 z-10 flex flex-col">
          {/* Header */}
          <div className="pt-[54px] px-5 pb-4 flex justify-between items-center text-white">
              <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center bg-black/20 backdrop-blur-md active:bg-white/20 transition-colors">
                  <ArrowLeft size={24} />
              </button>
              <div className="text-[17px] font-bold drop-shadow-md">
                  {scanMode === 'general' ? '扫码' : '扫码充电'}
              </div>
              <div className="w-10" />
          </div>

          {/* Scanner Box */}
          <div className="flex-1 flex flex-col items-center justify-center -mt-20">
              <div className="w-[260px] h-[260px] relative">
                  <div className={`absolute inset-0 border-2 rounded-[32px] transition-colors duration-500 ${scanMode === 'general' ? 'border-white/30' : 'border-[#FF6B00]/40'}`} />
                  
                  {/* Corners */}
                  <Corner side="tl" color={scanMode === 'general' ? '#FFF' : '#FF6B00'} />
                  <Corner side="tr" color={scanMode === 'general' ? '#FFF' : '#FF6B00'} />
                  <Corner side="bl" color={scanMode === 'general' ? '#FFF' : '#FF6B00'} />
                  <Corner side="br" color={scanMode === 'general' ? '#FFF' : '#FF6B00'} />
                  
                  {/* Laser Line */}
                  <div className={`absolute top-0 left-2 right-2 h-0.5 shadow-[0_0_10px_rgba(255,107,0,0.8)] animate-[scan_2s_linear_infinite] transition-colors duration-500 ${scanMode === 'general' ? 'bg-white' : 'bg-[#FF6B00]'}`} />
                  
                  {/* Mode Specific Icon Center */}
                  {scanMode === 'charging' && (
                      <div className="absolute inset-0 flex items-center justify-center opacity-20">
                          <Zap size={80} className="text-[#FF6B00]" />
                      </div>
                  )}
              </div>
              <div className="mt-8 text-white/90 text-[13px] font-medium bg-black/40 px-5 py-2 rounded-full backdrop-blur-md border border-white/10 shadow-lg">
                  {scanMode === 'general' ? '对准二维码，即可自动扫描' : '请对准充电桩上的二维码'}
              </div>
          </div>

          {/* Side Tools */}
          <div className="absolute right-6 top-[150px] flex flex-col gap-6 text-white">
              <ToolCircle icon={Flashlight} label="手电" />
              <ToolCircle icon={Image} label="相册" />
              {scanMode === 'charging' && <ToolCircle icon={Keyboard} label="输码" />}
          </div>

          {/* Bottom Mode Switcher */}
          <div className="pb-[60px] flex justify-center">
              <div className="bg-black/60 backdrop-blur-xl rounded-full p-1.5 flex items-center gap-1 border border-white/10 shadow-2xl">
                  <button 
                    onClick={() => setScanMode('general')}
                    className={`flex items-center gap-2 px-6 py-2.5 rounded-full text-[14px] font-bold transition-all duration-300 ${
                        scanMode === 'general' ? 'bg-white text-black shadow-lg' : 'text-white/60'
                    }`}
                  >
                      <ScanLine size={16} /> 扫一扫
                  </button>
                  <button 
                    onClick={() => setScanMode('charging')}
                    className={`flex items-center gap-2 px-6 py-2.5 rounded-full text-[14px] font-bold transition-all duration-300 ${
                        scanMode === 'charging' ? 'bg-[#FF6B00] text-white shadow-lg shadow-orange-500/20' : 'text-white/60'
                    }`}
                  >
                      <Zap size={16} className={scanMode === 'charging' ? 'fill-white' : ''} /> 充电
                  </button>
              </div>
          </div>
      </div>

      <style>{`
        @keyframes scan {
            0% { top: 4%; opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { top: 96%; opacity: 0; }
        }
      `}</style>
    </div>
  );
};

const Corner = ({ side, color }: { side: 'tl' | 'tr' | 'bl' | 'br', color: string }) => {
    const positions = {
        tl: 'top-0 left-0 border-t-4 border-l-4 rounded-tl-xl',
        tr: 'top-0 right-0 border-t-4 border-r-4 rounded-tr-xl',
        bl: 'bottom-0 left-0 border-b-4 border-l-4 rounded-bl-xl',
        br: 'bottom-0 right-0 border-b-4 border-r-4 rounded-br-xl'
    };
    return <div className={`absolute w-8 h-8 ${positions[side]} transition-colors duration-500`} style={{ borderColor: color }} />;
};

const ToolCircle = ({ icon: Icon, label }: any) => (
    <button className="flex flex-col items-center gap-1.5 group">
        <div className="w-12 h-12 rounded-full bg-black/40 backdrop-blur-md border border-white/20 flex items-center justify-center active:scale-90 transition-transform group-hover:bg-white/10">
            <Icon size={20} />
        </div>
        <span className="text-[10px] font-bold opacity-80">{label}</span>
    </button>
);

export default UnifiedScannerView;
