
import React, { useState } from 'react';
import { ArrowLeft, Plus, MapPin, Edit2, Check, Trash2 } from 'lucide-react';

// Shared Mock Data (Usually this would be in a global store)
export const MOCK_ADDRESSES = [
    { id: 1, name: '张越野', phone: '138****8888', address: '北京市朝阳区建国路88号 SOHO现代城', tag: '家', isDefault: true },
    { id: 2, name: '张先生', phone: '138****8888', address: '北京市大兴区北京汽车研发基地', tag: '公司', isDefault: false },
    { id: 3, name: '李女士', phone: '139****9999', address: '上海市浦东新区张江高科园区', tag: '父母', isDefault: false },
];

interface AddressListViewProps {
  onBack: () => void;
  onSelect?: (address: any) => void; // If provided, acts as selection mode
  selectedId?: number;
}

const AddressListView: React.FC<AddressListViewProps> = ({ onBack, onSelect, selectedId }) => {
  const [addresses, setAddresses] = useState(MOCK_ADDRESSES);

  const handleDelete = (e: React.MouseEvent, id: number) => {
      e.stopPropagation();
      if(window.confirm('确定删除该地址吗？')) {
          setAddresses(addresses.filter(a => a.id !== id));
      }
  };

  return (
    <div className="absolute inset-0 z-[300] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">
            {onSelect ? '选择收货地址' : '地址管理'}
        </div>
        <div className="w-9" />
      </div>

      {/* List */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-4">
          {addresses.map(addr => (
              <div 
                key={addr.id}
                onClick={() => onSelect && onSelect(addr)}
                className={`bg-white rounded-[20px] p-5 shadow-sm border-2 transition-all cursor-pointer relative overflow-hidden group ${
                    onSelect && selectedId === addr.id ? 'border-[#111]' : 'border-transparent'
                }`}
              >
                  <div className="flex justify-between items-start">
                      <div className="flex items-center gap-2 mb-2">
                          <span className="text-[16px] font-bold text-[#111]">{addr.name}</span>
                          <span className="text-[13px] text-gray-500 font-oswald">{addr.phone}</span>
                          {addr.isDefault && (
                              <span className="bg-[#111] text-white text-[10px] px-1.5 py-0.5 rounded">默认</span>
                          )}
                          {addr.tag && (
                              <span className="bg-gray-100 text-gray-500 text-[10px] px-1.5 py-0.5 rounded">{addr.tag}</span>
                          )}
                      </div>
                      {!onSelect && (
                          <button 
                            onClick={(e) => { e.stopPropagation(); /* Edit logic */ }}
                            className="text-gray-400 p-1 active:text-[#111]"
                          >
                              <Edit2 size={16} />
                          </button>
                      )}
                  </div>
                  
                  <div className="text-[13px] text-gray-600 leading-snug pr-8">
                      {addr.address}
                  </div>

                  {/* Selection Indicator */}
                  {onSelect && selectedId === addr.id && (
                      <div className="absolute top-0 right-0 bg-[#111] text-white w-8 h-8 rounded-bl-[20px] flex items-center justify-center pl-1 pb-1">
                          <Check size={14} />
                      </div>
                  )}

                  {/* Delete Button (Only in Manage Mode) */}
                  {!onSelect && (
                      <button 
                        onClick={(e) => handleDelete(e, addr.id)}
                        className="absolute bottom-4 right-4 text-gray-300 hover:text-red-500 transition-colors p-1"
                      >
                          <Trash2 size={16} />
                      </button>
                  )}
              </div>
          ))}
      </div>

      {/* Footer */}
      <div className="p-5 bg-white border-t border-gray-100 pb-[34px]">
          <button className="w-full h-12 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-lg flex items-center justify-center gap-2 active:scale-95 transition-transform">
              <Plus size={18} /> 新建收货地址
          </button>
      </div>
    </div>
  );
};

export default AddressListView;
