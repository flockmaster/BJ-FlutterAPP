
import React from 'react';
import { ChevronRight } from 'lucide-react';

interface ListCellProps {
  icon?: React.ElementType;
  label: string;
  subLabel?: string;
  value?: string;
  onClick?: () => void;
  isLast?: boolean;
  destructive?: boolean;
}

export const ListCell: React.FC<ListCellProps> = ({ 
  icon: Icon, 
  label, 
  subLabel, 
  value, 
  onClick, 
  isLast = false,
  destructive = false
}) => {
  return (
    <div 
        onClick={onClick}
        className={`flex items-center justify-between py-[22px] px-5 cursor-pointer active:bg-gray-50 transition-colors bg-white ${
            !isLast ? 'border-b border-gray-50' : ''
        }`}
    >
        <div className="flex items-center gap-4">
            {Icon && (
                <div className="text-[#333] shrink-0">
                    <Icon size={20} strokeWidth={2} />
                </div>
            )}
            <div>
                <div className={`text-[15px] font-bold leading-none mb-1.5 ${destructive ? 'text-red-500' : 'text-[#111]'}`}>
                    {label}
                </div>
                {subLabel && <div className="text-[11px] text-gray-400 font-medium">{subLabel}</div>}
            </div>
        </div>
        <div className="flex items-center gap-2">
            {value && <span className="text-[13px] text-gray-400 font-medium">{value}</span>}
            <ChevronRight size={18} className="text-gray-300" />
        </div>
    </div>
  );
};
