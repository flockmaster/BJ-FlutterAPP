
import React from 'react';

interface SkeletonProps {
  className?: string;
  width?: string | number;
  height?: string | number;
  variant?: 'rect' | 'circle' | 'text';
}

const Skeleton: React.FC<SkeletonProps> = ({ 
  className = "", 
  width, 
  height, 
  variant = 'rect' 
}) => {
  const baseClasses = "bg-gray-200 animate-shimmer relative overflow-hidden";
  const radiusClass = variant === 'circle' ? 'rounded-full' : variant === 'text' ? 'rounded-md' : 'rounded-[20px]';
  
  return (
    <div 
      className={`${baseClasses} ${radiusClass} ${className}`}
      style={{ width, height }}
    />
  );
};

export default Skeleton;
