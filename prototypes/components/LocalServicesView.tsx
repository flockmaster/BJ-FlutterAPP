
import React, { useState } from 'react';
import { ArrowLeft, MapPin, Search, Star, Navigation, Filter, Droplets, Fuel, CircleParking, ChevronRight } from 'lucide-react';

interface LocalServicesViewProps {
  type: 'wash' | 'fuel' | 'parking';
  onBack: () => void;
}

const MOCK_DATA = {
    wash: [
        { id: 1, name: '爱车工坊极速精洗', address: '朝阳区百子湾路12号', distance: '1.2km', price: '35', rating: 4.8, tags: ['24H', '精洗'] },
        { id: 2, name: '车爵仕汽车美容中心', address: '朝阳区大望路88号', distance: '2.5km', price: '50', rating: 4.9, tags: ['镀晶', '内饰'] },
    ],
    fuel: [
        { id: 1, name: '中国石化(建国路站)', address: '建国路99号', distance: '0.8km', price: '7.85', rating: 4.7, tags: ['95#', '降0.3元'] },
        { id: 2, name: '中国石油(通惠河站)', address: '通惠河北路', distance: '3.1km', price: '7.82', rating: 4.6, tags: ['便利店', '自助'] },
    ],
    parking: [
        { id: 1, name: 'SOHO现代城停车场', address: '建国路88号', distance: '0.1km', price: '8', unit:'/时', rating: 4.5, tags: ['余位12', '室内'] },
        { id: 2, name: '万达广场地上停车场', address: '建国路93号', distance: '0.5km', price: '10', unit:'/时', rating: 4.8, tags: ['快充桩', '宽敞'] },
    ]
};

const TITLES = { wash: '洗车服务', fuel: '周边加油站', parking: '周边停车场' };
const ICONS = { wash: Droplets, fuel: Fuel, parking: CircleParking };

const LocalServicesView: React.FC<LocalServicesViewProps> = ({ type, onBack }) => {
  const data = MOCK_DATA[type];
  const Icon = ICONS[type];

  return (
    <div className="absolute inset-0 z-[150] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* Map Area */}
      <div className="h-[40%] bg-gray-100 relative shrink-0">
          <div 
            className="absolute inset-0 bg-cover bg-center grayscale-[0.2] opacity-70" 
            style={{backgroundImage: 'url(https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=1000&auto=format&fit=crop)'}}
          />
          {/* Floating Header */}
          <div className="absolute top-0 left-0 right-0 pt-[54px] px-5 pb-3 flex items-center gap-3 z-10 pointer-events-none">
              <button onClick={onBack} className="w-10 h-10 rounded-full bg-white shadow-md flex items-center justify-center active:scale-90 transition-transform pointer-events-auto">
                  <ArrowLeft size={22} className="text-[#111]" />
              </button>
              <div className="flex-1 bg-white shadow-md h-10 rounded-full flex items-center px-4 gap-2 pointer-events-auto">
                  <Search size={16} className="text-gray-400" />
                  <span className="text-[13px] text-gray-400">搜索附近的{TITLES[type].slice(2)}</span>
              </div>
          </div>
          
          {/* Markers */}
          {data.map((item, i) => (
              <div key={item.id} className="absolute w-10 h-10 bg-[#111] text-white rounded-full flex items-center justify-center border-2 border-white shadow-lg z-10" style={{ top: `${45 + i * 15}%`, left: `${30 + i * 35}%` }}>
                  <Icon size={18} />
              </div>
          ))}
      </div>

      {/* List Area - Radius-L+ (32px) top */}
      <div className="flex-1 bg-white rounded-t-[32px] -mt-8 relative z-20 p-5 shadow-[0_-8px_30px_rgba(0,0,0,0.08)] flex flex-col overflow-hidden">
          <div className="w-12 h-1.5 bg-gray-100 rounded-full mx-auto mb-6 shrink-0" />
          
          <div className="flex justify-between items-center mb-5 shrink-0">
              <h2 className="text-[18px] font-bold text-[#111]">{TITLES[type]}</h2>
              <button className="flex items-center gap-1.5 text-[12px] font-bold text-gray-500 bg-gray-50 px-3 py-1.5 rounded-full">
                  <Filter size={14} /> 智能筛选
              </button>
          </div>

          <div className="flex-1 overflow-y-auto no-scrollbar space-y-4 pb-10">
              {data.map(item => (
                  <div key={item.id} className="bg-white p-4 rounded-2xl flex gap-4 border border-gray-50 shadow-sm active:scale-[0.99] transition-all">
                      <div className="w-[84px] h-[84px] bg-gray-100 rounded-xl overflow-hidden shrink-0">
                          <img 
                            src={`https://images.unsplash.com/photo-${type === 'wash' ? '1601362840469-51e4d8d58785' : type === 'fuel' ? '1545262810-77515befe149' : '1506521781263-d8422e82f27a'}?q=80&w=200&auto=format&fit=crop`} 
                            className="w-full h-full object-cover" 
                          />
                      </div>
                      <div className="flex-1 flex flex-col justify-between py-0.5">
                          <div className="flex justify-between items-start">
                              <h3 className="text-[15px] font-bold text-[#111] line-clamp-1 flex-1 pr-2">{item.name}</h3>
                              <div className="text-[16px] font-oswald font-bold text-[#FF6B00]">
                                  ¥{item.price}<span className="text-[10px] text-gray-400 font-normal">{(item as any).unit || ''}</span>
                              </div>
                          </div>
                          
                          <div className="text-[12px] text-gray-400">{item.address} · {item.distance}</div>
                          
                          <div className="flex justify-between items-end">
                              <div className="flex gap-2">
                                  {item.tags.map(tag => (
                                      <span key={tag} className="text-[9px] font-bold text-gray-400 bg-gray-50 px-1.5 py-0.5 rounded border border-gray-100">{tag}</span>
                                  ))}
                              </div>
                              <button className="flex items-center gap-1 text-[12px] font-bold text-[#111]">
                                  查看路径 <ChevronRight size={14} className="text-gray-300" />
                              </button>
                          </div>
                      </div>
                  </div>
              ))}
          </div>
      </div>
    </div>
  );
};

export default LocalServicesView;
