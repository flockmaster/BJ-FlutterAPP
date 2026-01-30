
import React from 'react';

interface NavIconProps {
  icon: any;
  label: string;
  active?: boolean;
  onClick: () => void;
}

const NavIcon: React.FC<NavIconProps> = ({ icon: Icon, label, active = false, onClick }) => (
  <button 
    onClick={onClick}
    className={`flex flex-col items-center gap-1 w-[50px] transition-colors duration-200 ${active ? 'text-[#000] font-medium' : 'text-[#999]'}`}
  >
     <Icon size={20} strokeWidth={active ? 2.5 : 2} />
     <span className="text-[10px]">{label}</span>
  </button>
);

export default NavIcon;
