
import React from 'react';

export const TireTrackBackground = ({ className = "" }: { className?: string }) => (
  <div className={`absolute top-0 left-0 right-0 h-full pointer-events-none overflow-hidden z-0 ${className}`}>
    <div 
        className="w-full h-full opacity-[0.06]"
        style={{
            maskImage: 'linear-gradient(to right, transparent 0%, transparent 40%, black 100%)',
            WebkitMaskImage: 'linear-gradient(to right, transparent 0%, transparent 40%, black 100%)'
        }}
    >
        <svg 
            width="100%" 
            height="100%" 
            viewBox="0 0 350 200" 
            preserveAspectRatio="xMidYMid slice" 
            className="text-[#000]"
        >
            <g transform="translate(160, -50) rotate(15) scale(1.6)"> 
                <path d="M0,0 L40,0 L50,20 L30,20 L0,0 Z" fill="currentColor" />
                <path d="M60,0 L100,0 L90,20 L70,20 L60,0 Z" fill="currentColor" />
                
                <path d="M0,30 L40,30 L50,50 L30,50 L0,30 Z" fill="currentColor" />
                <path d="M60,30 L100,30 L90,50 L70,50 L60,30 Z" fill="currentColor" />

                <path d="M0,60 L40,60 L50,80 L30,80 L0,60 Z" fill="currentColor" />
                <path d="M60,60 L100,60 L90,80 L70,80 L60,60 Z" fill="currentColor" />

                <path d="M0,90 L40,90 L50,110 L30,110 L0,90 Z" fill="currentColor" />
                <path d="M60,90 L100,90 L90,110 L70,110 L60,90 Z" fill="currentColor" />

                <path d="M0,120 L40,120 L50,140 L30,140 L0,120 Z" fill="currentColor" />
                <path d="M60,120 L100,120 L90,140 L70,140 L60,120 Z" fill="currentColor" />
                
                <path d="M0,150 L40,150 L50,170 L30,170 L0,150 Z" fill="currentColor" />
                <path d="M60,150 L100,150 L90,170 L70,170 L60,150 Z" fill="currentColor" />

                <path d="M0,180 L40,180 L50,200 L30,200 L0,180 Z" fill="currentColor" />
                <path d="M60,180 L100,180 L90,200 L70,200 L60,180 Z" fill="currentColor" />
                
                <rect x="45" y="0" width="10" height="220" fill="currentColor" opacity="0.5" />
            </g>
        </svg>
    </div>
  </div>
);

export default TireTrackBackground;
