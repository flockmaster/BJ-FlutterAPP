import React, { useState, useEffect } from 'react';
import { ArrowLeft, Trash2, Minus, Plus, ShoppingBag, CheckCircle2, Circle, Check } from 'lucide-react';
import { StoreProduct } from '../types';

export interface CartItem extends StoreProduct {
  cartId: string;
  selectedSpec: string;
  quantity: number;
  selected: boolean;
}

interface StoreCartViewProps {
  items: CartItem[];
  onBack: () => void;
  onUpdateItems: (items: CartItem[]) => void;
  onCheckout: (selectedItems: CartItem[]) => void;
}

const StoreCartView: React.FC<StoreCartViewProps> = ({ items, onBack, onUpdateItems, onCheckout }) => {
  const [isEditMode, setIsEditMode] = useState(false);

  const selectedItems = items.filter(i => i.selected);
  const totalCount = selectedItems.reduce((acc, item) => acc + item.quantity, 0);
  const totalPrice = selectedItems.reduce((acc, item) => {
      const price = parseFloat(item.price.replace(/,/g, ''));
      return acc + price * item.quantity;
  }, 0);
  const isAllSelected = items.length > 0 && items.every(i => i.selected);

  const toggleSelect = (id: string) => {
      const newItems = items.map(item => 
          item.cartId === id ? { ...item, selected: !item.selected } : item
      );
      onUpdateItems(newItems);
  };

  const toggleSelectAll = () => {
      const newItems = items.map(item => ({ ...item, selected: !isAllSelected }));
      onUpdateItems(newItems);
  };

  const updateQuantity = (id: string, delta: number) => {
      const newItems = items.map(item => {
          if (item.cartId === id) {
              const newQty = Math.max(1, item.quantity + delta);
              return { ...item, quantity: newQty };
          }
          return item;
      });
      onUpdateItems(newItems);
  };

  const deleteSelected = () => {
      if (confirm('确定要删除选中的商品吗？')) {
          const newItems = items.filter(item => !item.selected);
          onUpdateItems(newItems);
          setIsEditMode(false);
      }
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100 z-10">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">购物车 ({items.length})</div>
        <button 
            onClick={() => setIsEditMode(!isEditMode)}
            className="text-[14px] text-[#111] font-bold px-2 active:opacity-60"
        >
            {isEditMode ? '完成' : '编辑'}
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 pb-[120px]">
          {items.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-[60vh] text-gray-400">
                  <div className="w-24 h-24 bg-white rounded-[32px] flex items-center justify-center mb-6 shadow-sm border border-gray-50">
                      <ShoppingBag size={40} className="opacity-20" />
                  </div>
                  <p className="text-[15px] font-medium mb-8">您的购物车还是空的</p>
                  <button onClick={onBack} className="px-10 py-3 rounded-full border-2 border-[#111] text-[#111] text-[14px] font-bold active:scale-95 transition-all">
                      去挑选心仪商品
                  </button>
              </div>
          ) : (
              <div className="space-y-4">
                  {items.map(item => (
                      /* Radius-M (16px) for item cards */
                      <div key={item.cartId} className="bg-white rounded-2xl p-4 flex items-center gap-4 shadow-[0_2px_12px_rgba(0,0,0,0.02)] border border-transparent hover:border-gray-50 transition-all">
                          <button 
                            onClick={() => toggleSelect(item.cartId)}
                            className={`w-6 h-6 rounded-full flex items-center justify-center transition-all shrink-0 border-2 ${
                                item.selected ? 'bg-[#111] border-[#111] text-white shadow-md' : 'border-gray-200 bg-white'
                            }`}
                          >
                              {item.selected && <Check size={14} strokeWidth={4} />}
                          </button>

                          <div className="w-[85px] h-[85px] bg-gray-50 rounded-xl overflow-hidden shrink-0 border border-gray-100">
                              <img src={item.image} className="w-full h-full object-cover" />
                          </div>

                          <div className="flex-1 min-w-0 h-[85px] flex flex-col justify-between py-0.5">
                              <div>
                                  <div className="text-[14px] font-bold text-[#111] line-clamp-1 mb-1.5 leading-snug">
                                      {item.title}
                                  </div>
                                  <div className="text-[11px] text-gray-400 bg-gray-50 px-2 py-0.5 rounded-lg w-fit truncate max-w-full font-medium">
                                      {item.selectedSpec}
                                  </div>
                              </div>
                              
                              <div className="flex justify-between items-center">
                                  <div className="text-[17px] font-bold text-[#FF6B00] font-oswald">
                                      ¥{item.price}
                                  </div>
                                  <div className="flex items-center gap-3 bg-gray-50 rounded-full px-2 py-1 border border-gray-100">
                                      <button 
                                        onClick={() => updateQuantity(item.cartId, -1)}
                                        disabled={item.quantity <= 1}
                                        className="w-6 h-6 flex items-center justify-center active:bg-gray-200 rounded-full disabled:opacity-30 transition-colors"
                                      >
                                          <Minus size={12} strokeWidth={3} />
                                      </button>
                                      <span className="text-[13px] font-bold font-oswald w-5 text-center">{item.quantity}</span>
                                      <button 
                                        onClick={() => updateQuantity(item.cartId, 1)}
                                        className="w-6 h-6 flex items-center justify-center active:bg-gray-200 rounded-full transition-colors"
                                      >
                                          <Plus size={12} strokeWidth={3} />
                                      </button>
                                  </div>
                              </div>
                          </div>
                      </div>
                  ))}
              </div>
          )}
      </div>

      {items.length > 0 && (
          /* Radius-L (24px) top corner for bottom bar */
          <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-xl border-t border-gray-100 px-5 pt-3 pb-[34px] flex items-center justify-between shadow-[0_-4px_24px_rgba(0,0,0,0.06)] z-20 rounded-t-[24px]">
              <button 
                onClick={toggleSelectAll}
                className="flex items-center gap-2.5 text-[14px] font-bold text-[#111]"
              >
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center transition-all border-2 ${
                      isAllSelected ? 'bg-[#111] border-[#111] text-white' : 'border-gray-200'
                  }`}>
                      {isAllSelected && <Check size={14} strokeWidth={4} />}
                  </div>
                  全选
              </button>

              {isEditMode ? (
                  <button 
                    onClick={deleteSelected}
                    disabled={selectedItems.length === 0}
                    className="px-8 h-11 rounded-full border-2 border-red-500 text-red-500 text-[14px] font-bold active:bg-red-50 disabled:opacity-30 disabled:border-gray-100 disabled:text-gray-300 transition-all"
                  >
                      删除所选 ({totalCount})
                  </button>
              ) : (
                  <div className="flex items-center gap-5">
                      <div className="text-right">
                          <div className="text-[10px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">Subtotal</div>
                          <div className="flex items-baseline gap-0.5 text-[#FF6B00]">
                              <span className="text-[12px] font-bold">¥</span>
                              <span className="text-[22px] font-bold font-oswald leading-none">{totalPrice.toLocaleString()}</span>
                          </div>
                      </div>
                      <button 
                        onClick={() => onCheckout(selectedItems)}
                        disabled={selectedItems.length === 0}
                        className="h-11 px-10 rounded-full bg-[#111] text-white text-[15px] font-bold shadow-lg shadow-black/20 active:scale-95 transition-transform disabled:bg-gray-100 disabled:text-gray-400 disabled:shadow-none"
                      >
                          结算 ({totalCount})
                      </button>
                  </div>
              )}
          </div>
      )}
    </div>
  );
};

export default StoreCartView;