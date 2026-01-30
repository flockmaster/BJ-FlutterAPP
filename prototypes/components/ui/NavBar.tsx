
import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { IconButton } from './Button';

interface NavBarProps {
  title: string;
  onBack?: () => void;
  rightAction?: React.ReactNode;
  bgOpacity?: number; // 0 to 1 for scroll effects
  transparent?: boolean;
}

export const NavBar: React.FC<NavBarProps> = ({ 
  title, 
  onBack, 
  rightAction, 
  bgOpacity = 1,
  transparent = false
}) => {
  return (
    <div 
      className={`pt-[54px] px-5 pb-3 flex justify-between items-center z-50 transition-all duration-300 ${
        transparent 
            ? 'absolute top-0 left-0 right-0' 
            : 'relative bg-white border-b border-gray-100'
      }`}
      style={transparent && bgOpacity < 1 ? { backgroundColor: `rgba(255,255,255,${bgOpacity})` } : undefined}
    >
      <div className="flex items-center gap-3">
        {onBack && (
          <IconButton 
            icon={ArrowLeft} 
            onClick={onBack} 
            variant={transparent && bgOpacity < 0.5 ? 'blur' : 'ghost'} 
            className="-ml-2"
          />
        )}
      </div>
      
      <div 
        className={`text-[17px] font-bold text-[#111] transition-opacity duration-300 ${
            transparent ? (bgOpacity > 0.8 ? 'opacity-100' : 'opacity-0') : 'opacity-100'
        }`}
      >
        {title}
      </div>

      <div className="flex items-center gap-2 -mr-2">
        {rightAction || <div className="w-9" />}
      </div>
    </div>
  );
};
