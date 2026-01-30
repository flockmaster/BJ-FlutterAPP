
import React, { useState } from 'react';
import { ArrowLeft, Search, Filter, ShoppingBag, Car, Zap, Wrench, MoreHorizontal, ChevronRight } from 'lucide-react';

interface OrderListViewProps {
  onBack: () => void;
  onSelectOrder?: (order: any) => void;
}

const TABS = ['全部', '整车', '商城', '充电', '服务'];

const ORDERS = [
    { 
        id: 'ord_car_1', 
        type: '整车', 
        status: '排产中', 
        title: '北京BJ40 城市猎人版', 
        spec: '极夜黑 · 酷黑内饰', 
        price: '159,800', 
        image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=200&auto=format&fit=crop',
        date: '2024-01-10'
    },
    { 
        id: 'ord_mall_1', 
        type: '商城', 
        status: '已发货', 
        title: '户外露营天幕帐篷', 
        spec: '象牙白 · 大号', 
        price: '899', 
        image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=200&auto=format&fit=crop',
        date: '2024-01-12'
    },
    { 
        id: 'ord_chg_1', 
        type: '充电', 
        status: '已完成', 
        title: '特来电充电站(SOHO)', 
        spec: '42.5 kWh · 快充', 
        price: '54.20', 
        image: '',
        date: '2024-01-08'
    }
];

const OrderListView: React.FC<OrderListViewProps> = ({ onBack, onSelectOrder }) => {
  const [activeTab, setActiveTab] = useState('全部');

  const filteredOrders = activeTab === '全部' 
    ? ORDERS 
    : ORDERS.filter(o => o.type === activeTab);

  const getIcon = (type: string) => {
      switch(type) {
          case '整车': return <Car size={16} />;
          case '商城': return <ShoppingBag size={16} />;
          case '充电': return <Zap size={16} />;
          case '服务': return <Wrench size={16} />;
          default: return <ShoppingBag size={16} />;
      }
  };

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-2 bg-white z-10">
          <div className="flex justify-between items-center mb-4">
            <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                <ArrowLeft size={24} className="text-[#111]" />
            </button>
            <div className="text-[18px] font-bold text-[#111]">我的订单</div>
            <button className="w-10 h-10 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                <Search size={22} className="text-[#111]" />
            </button>
          </div>

          <div className="flex gap-7 overflow-x-auto no-scrollbar border-b border-gray-50">
              {TABS.map(tab => (
                  <button
                    key={tab}
                    onClick={() => setActiveTab(tab)}
                    className={`pb-3 text-[15px] font-bold whitespace-nowrap relative transition-colors ${
                        activeTab === tab ? 'text-[#111]' : 'text-gray-400'
                    }`}
                  >
                      {tab}
                      {activeTab === tab && (
                          <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-5 h-1.5 bg-[#111] rounded-full" />
                      )}
                  </button>
              ))}
          </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5 space-y-4">
          {filteredOrders.map(order => (
              <div 
                key={order.id} 
                onClick={() => order.type === '商城' && onSelectOrder?.(order)}
                className="bg-white rounded-2xl p-5 shadow-sm active:scale-[0.99] transition-transform cursor-pointer border border-transparent hover:border-gray-100"
              >
                  <div className="flex justify-between items-center mb-4 pb-3 border-b border-gray-50">
                      <div className="flex items-center gap-2">
                          {/* Restored circular icon bg */}
                          <div className="w-7 h-7 bg-gray-50 rounded-full flex items-center justify-center text-gray-500">
                             {getIcon(order.type)}
                          </div>
                          <span className="text-[14px] font-bold text-[#111]">{order.type}订单</span>
                          <ChevronRight size={14} className="text-gray-300" />
                      </div>
                      <span className={`text-[12px] font-bold ${
                          order.status === '已完成' ? 'text-gray-400' : 'text-[#FF6B00]'
                      }`}>
                          {order.status}
                      </span>
                  </div>

                  <div className="flex gap-4 mb-5">
                      <div className="w-[85px] h-[85px] bg-gray-50 rounded-xl overflow-hidden shrink-0 border border-gray-100/50">
                          {order.image ? (
                              <img src={order.image} className="w-full h-full object-cover" />
                          ) : (
                              <div className="w-full h-full flex items-center justify-center text-gray-300">
                                  {getIcon(order.type)}
                              </div>
                          )}
                      </div>
                      
                      <div className="flex-1 flex flex-col justify-between py-0.5">
                          <div>
                              <div className="text-[15px] font-bold text-[#111] line-clamp-1 mb-1.5">{order.title}</div>
                              <div className="text-[12px] text-gray-400 line-clamp-1 bg-gray-50 px-2 py-0.5 rounded-md w-fit">{order.spec}</div>
                          </div>
                          <div className="text-[11px] text-gray-400 font-oswald tracking-wide">{order.date}</div>
                      </div>
                  </div>

                  <div className="flex justify-between items-center pt-2">
                      <div className="flex items-baseline gap-1 text-[#111] font-oswald">
                          <span className="text-[12px] font-bold">¥</span>
                          <span className="text-[20px] font-bold leading-none">{order.price}</span>
                      </div>
                      <div className="flex gap-3">
                          <button className="px-5 py-2 rounded-xl border border-gray-200 text-[13px] font-bold text-[#666] active:bg-gray-50 transition-colors" onClick={(e) => e.stopPropagation()}>
                              查看发票
                          </button>
                          <button className="px-5 py-2 rounded-xl bg-[#111] text-[13px] font-bold text-white active:scale-95 transition-transform shadow-md">
                              {order.status === '已完成' ? '再次购买' : '详情'}
                          </button>
                      </div>
                  </div>
              </div>
          ))}
          
          <div className="py-10 text-center text-[11px] text-gray-300 font-oswald tracking-[0.2em]">
              END OF LIST
          </div>
      </div>
    </div>
  );
};

export default OrderListView;
