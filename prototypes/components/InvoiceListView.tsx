
import React, { useState } from 'react';
import { ArrowLeft, Plus, Trash2, Check, FileText, Briefcase, User } from 'lucide-react';

// Mock Data
const MOCK_INVOICES = [
    { id: 1, type: 'personal', title: '张越野', taxId: '', isDefault: true },
    { id: 2, type: 'company', title: '北京汽车集团有限公司', taxId: '911100001011234567', isDefault: false },
    { id: 3, type: 'company', title: '某某科技发展(北京)有限公司', taxId: '91110105MA01234567', isDefault: false },
];

interface InvoiceListViewProps {
  onBack: () => void;
}

const InvoiceListView: React.FC<InvoiceListViewProps> = ({ onBack }) => {
  const [invoices, setInvoices] = useState(MOCK_INVOICES);

  const handleDelete = (e: React.MouseEvent, id: number) => {
      e.stopPropagation();
      if(window.confirm('确定删除该发票抬头吗？')) {
          setInvoices(invoices.filter(i => i.id !== id));
      }
  };

  const handleSetDefault = (id: number) => {
      setInvoices(invoices.map(i => ({
          ...i,
          isDefault: i.id === id
      })));
  };

  return (
    <div className="absolute inset-0 z-[300] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">发票抬头</div>
        <div className="w-9" />
      </div>

      {/* List */}
      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-4">
          {invoices.map(invoice => (
              <div 
                key={invoice.id}
                onClick={() => handleSetDefault(invoice.id)}
                className={`bg-white rounded-[20px] p-5 shadow-sm border-2 transition-all cursor-pointer relative overflow-hidden group ${
                    invoice.isDefault ? 'border-[#111]' : 'border-transparent'
                }`}
              >
                  <div className="flex justify-between items-start mb-2">
                      <div className="flex items-center gap-2">
                          <div className={`w-6 h-6 rounded-full flex items-center justify-center ${invoice.type === 'company' ? 'bg-blue-50 text-blue-600' : 'bg-gray-100 text-gray-500'}`}>
                              {invoice.type === 'company' ? <Briefcase size={12} /> : <User size={12} />}
                          </div>
                          <span className="text-[12px] font-bold text-gray-500">
                              {invoice.type === 'company' ? '企业' : '个人'}
                          </span>
                          {invoice.isDefault && (
                              <span className="bg-[#111] text-white text-[10px] px-1.5 py-0.5 rounded ml-1">默认</span>
                          )}
                      </div>
                      <button 
                        onClick={(e) => handleDelete(e, invoice.id)}
                        className="text-gray-300 hover:text-red-500 transition-colors p-1"
                      >
                          <Trash2 size={16} />
                      </button>
                  </div>
                  
                  <div className="text-[15px] font-bold text-[#111] mb-1 line-clamp-1">
                      {invoice.title}
                  </div>
                  
                  {invoice.type === 'company' && (
                      <div className="text-[13px] text-gray-500 font-mono bg-gray-50 px-2 py-1 rounded w-fit mt-2">
                          税号: {invoice.taxId}
                      </div>
                  )}

                  {/* Selection Indicator */}
                  {invoice.isDefault && (
                      <div className="absolute top-0 right-0 bg-[#111] text-white w-8 h-8 rounded-bl-[20px] flex items-center justify-center pl-1 pb-1">
                          <Check size={14} />
                      </div>
                  )}
              </div>
          ))}
      </div>

      {/* Footer */}
      <div className="p-5 bg-white border-t border-gray-100 pb-[34px]">
          <button className="w-full h-12 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-lg flex items-center justify-center gap-2 active:scale-95 transition-transform">
              <Plus size={18} /> 添加新抬头
          </button>
      </div>
    </div>
  );
};

export default InvoiceListView;
