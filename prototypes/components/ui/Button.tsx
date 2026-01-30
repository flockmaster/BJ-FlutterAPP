import React from 'react';
import { Loader2 } from 'lucide-react';

interface ActionButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  label: string;
  icon?: React.ElementType;
  loading?: boolean;
  variant?: 'primary' | 'secondary' | 'outline' | 'danger' | 'ghost';
}

/**
 * Standardized Action Button for BAIC Mobile App
 * Design: Radius-M (16px), Height: h-12 (48px)
 * Layout: Width is NOT fixed, should be controlled by parent (e.g., flex-1 or w-full)
 */
export const ActionButton: React.FC<ActionButtonProps> = ({ 
  label, 
  icon: Icon, 
  loading, 
  variant = 'primary',
  className = '',
  disabled,
  ...props 
}) => {
  // Enforces fixed height and standard rounding. Removed w-full.
  const baseStyles = "h-12 shrink-0 rounded-2xl font-bold text-[14px] flex items-center justify-center gap-2 active:scale-[0.98] transition-all disabled:opacity-40 disabled:cursor-not-allowed select-none px-6";
  
  const variants = {
    primary: "bg-[#111] text-white shadow-lg shadow-black/10",
    secondary: "bg-[#F5F7FA] text-[#111] hover:bg-gray-200",
    outline: "bg-white border border-gray-100 text-[#111] shadow-sm",
    danger: "bg-white border border-red-50 text-[#FF4D4F] hover:bg-red-50",
    ghost: "bg-transparent text-gray-500"
  };

  return (
    <button 
      className={`${baseStyles} ${variants[variant]} ${className}`}
      disabled={loading || disabled}
      {...props}
    >
      {loading ? (
        <Loader2 size={18} className="animate-spin" />
      ) : (
        <>
          {Icon && <Icon size={18} />}
          {label}
        </>
      )}
    </button>
  );
};

interface IconButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  icon: React.ElementType;
  variant?: 'solid' | 'blur' | 'ghost';
  size?: number;
}

export const IconButton: React.FC<IconButtonProps> = ({ 
  icon: Icon, 
  variant = 'blur', 
  size = 20, 
  className = '', 
  ...props 
}) => {
  const baseStyles = "w-10 h-10 rounded-full flex items-center justify-center transition-all active:scale-90 shrink-0";
  
  const variants = {
    solid: "bg-white shadow-sm border border-gray-100 text-[#111]",
    blur: "bg-white/90 backdrop-blur-md shadow-sm text-[#111]",
    ghost: "bg-transparent hover:bg-black/5 text-[#111]"
  };

  return (
    <button className={`${baseStyles} ${variants[variant]} ${className}`} {...props}>
      <Icon size={size} />
    </button>
  );
};