
import React, { useState } from 'react';
import { ArrowLeft, Flashlight, Keyboard, Image as ImageIcon } from 'lucide-react';

interface ScanChargingViewProps {
  onBack: () => void;
}

const ScanChargingView: React.FC<ScanChargingViewProps> = ({ onBack }) => {
  return (
    <div className="absolute inset-0 z-[150] bg-black flex flex-col animate-in fade-in duration-300">
        {/* Camera Feed Simulation */}
        <div 
            className="absolute inset-0 bg-cover bg-center opacity-60"
            style={{backgroundImage: 'url(https://images.unsplash.com/photo-1597423244039-992b67f69d31?q=80&w=1200&auto=format&fit=crop)'}} 
        />

        {/* Overlay UI */}
        <div className="absolute inset-0 z-10 flex flex-col">
            {/* Header - Fixed Back Button Click Area */}
            <div className="pt-[54px] px-5 pb-4 flex justify-between items-center text-white">
                <button 
                    onClick={(e) => {
                        e.stopPropagation();
                        onBack();
                    }} 
                    className="w-12 h-12 -ml-3 rounded-full flex items-center justify-center active:bg-white/20 transition-colors pointer-events-auto"
                >
                    <ArrowLeft size={26} />
                </button>
                <div className="text-[17px] font-bold">扫码充电</div>
                <div className="w-10" />
            </div>

            {/* Scan Frame - Radius-L (32px) */}
            <div className="flex-1 flex flex-col items-center justify-center -mt-20">
                <div className="w-[260px] h-[260px] border-2 border-white/30 rounded-[32px] relative overflow-hidden shadow-[0_0_0_9999px_rgba(0,0,0,0.6)]">
                    {/* Corners */}
                    <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-[#FF6B00] rounded-tl-[12px]" />
                    <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-[#FF6B00] rounded-tr-[12px]" />
                    <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-[#FF6B00] rounded-bl-[12px]" />
                    <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-[#FF6B00] rounded-br-[12px]" />
                    
                    {/* Scanning Line */}
                    <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-[#FF6B00] to-transparent animate-[scan_2s_linear_infinite]" />
                </div>
                <div className="mt-8 text-white/80 text-[13px] font-medium bg-black/40 px-5 py-2 rounded-full backdrop-blur-md">
                    对准充电桩屏幕上的二维码
                </div>
            </div>

            {/* Bottom Controls */}
            <div className="pb-[60px] px-10 flex justify-around items-center text-white">
                <button className="flex flex-col items-center gap-2 active:scale-90 transition-transform">
                    <div className="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center">
                        <Flashlight size={20} />
                    </div>
                    <span className="text-[12px]">手电筒</span>
                </button>
                
                <button className="flex flex-col items-center gap-2 active:scale-90 transition-transform">
                    <div className="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center">
                        <ImageIcon size={20} />
                    </div>
                    <span className="text-[12px]">相册</span>
                </button>

                <button className="flex flex-col items-center gap-2 active:scale-90 transition-transform">
                    <div className="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center">
                        <Keyboard size={20} />
                    </div>
                    <span className="text-[12px]">输码充电</span>
                </button>
            </div>
        </div>
        
        <style>{`
            @keyframes scan {
                0% { top: 0; opacity: 0; }
                20% { opacity: 1; }
                80% { opacity: 1; }
                100% { top: 100%; opacity: 0; }
            }
        `}</style>
    </div>
  );
};

export default ScanChargingView;
