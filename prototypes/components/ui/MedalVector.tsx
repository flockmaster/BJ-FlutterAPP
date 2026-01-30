
import React from 'react';

interface MedalVectorProps {
  id: number;
  className?: string;
  grayscale?: boolean;
}

const MedalVector: React.FC<MedalVectorProps> = ({ id, className = "", grayscale = false }) => {
  // Simple Level Marker
  const LevelMarker = ({ level = "1" }) => (
    <g transform="translate(85, 135)">
        <rect width="30" height="30" rx="4" fill="#8B6B4F" fillOpacity="0.3" />
        <text x="15" y="22" textAnchor="middle" fill="#E5C07B" fontSize="20" fontWeight="bold" fontFamily="Oswald">{level}</text>
    </g>
  );

  const renderMedalContent = () => {
    switch(id) {
        case 1: // 进藏英雄 (Purple/Orange)
            return (
                <>
                    {/* Background Shape */}
                    <path d="M100 15 L180 74 L150 168 L50 168 L20 74 Z" fill="#6C5CE7" />
                    {/* Inner Sun Design */}
                    <circle cx="100" cy="80" r="45" fill="#FF7675" />
                    <path d="M60 85 Q100 40 140 85" stroke="white" strokeWidth="6" fill="none" strokeLinecap="round" />
                    {/* Level */}
                    <LevelMarker level="1" />
                    {/* Sparkles */}
                    <path d="M45 55 L50 60 M45 60 L50 55" stroke="white" strokeWidth="2" />
                    <path d="M150 90 L158 98 M150 98 L158 90" stroke="white" strokeWidth="2" />
                </>
            );
        case 2: // 越野新秀 (Blue)
            return (
                <>
                    <path d="M100 15 L180 74 L150 168 L50 168 L20 74 Z" fill="#0984E3" />
                    <path d="M100 40 L135 110 L100 95 L65 110 Z" fill="white" fillOpacity="0.8" />
                    <circle cx="100" cy="85" r="35" stroke="white" strokeWidth="2" fill="none" strokeDasharray="4 4" />
                    <LevelMarker level="1" />
                </>
            );
        case 3: // 活跃达人 (Yellow)
            return (
                <>
                    <path d="M100 15 L180 74 L150 168 L50 168 L20 74 Z" fill="#F1C40F" />
                    <path d="M100 40 L115 80 L140 80 L110 100 L125 140 L100 115 L75 140 L90 100 L60 80 L85 80 Z" fill="white" />
                    <LevelMarker level="1" />
                </>
            );
        default:
            return (
                <>
                    <path d="M100 15 L180 74 L150 168 L50 168 L20 74 Z" fill="#B2BEC3" />
                    <circle cx="100" cy="85" r="30" fill="white" fillOpacity="0.4" />
                    <LevelMarker level="?" />
                </>
            );
    }
  };

  return (
    <svg 
        viewBox="0 0 200 200" 
        className={`${className} ${grayscale ? 'grayscale opacity-40' : ''}`}
        xmlns="http://www.w3.org/2000/svg"
    >
      <defs>
        <linearGradient id={`goldGrad-${id}`} x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#FAD390" />
          <stop offset="50%" stopColor="#E58E26" />
          <stop offset="100%" stopColor="#B33939" />
        </linearGradient>
      </defs>
      
      {/* Outer Pentagonal Frame */}
      <path 
        d="M100 5 L190 70 L155 175 L45 175 L10 70 Z" 
        fill="#333" 
        stroke={`url(#goldGrad-${id})`}
        strokeWidth="10" 
      />
      
      {renderMedalContent()}

      {/* Gloss Effect Overlay */}
      <path d="M30 70 Q100 20 170 70" stroke="white" strokeWidth="2" fill="none" opacity="0.3" />
    </svg>
  );
};

export default MedalVector;
