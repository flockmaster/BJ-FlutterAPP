
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Search, 
  MapPin, 
  Navigation, 
  Phone, 
  Clock, 
  Star, 
  Compass, 
  List,
  LocateFixed,
  Car,
  ChevronRight
} from 'lucide-react';

// Mock Data
const STORES = [
  {
    id: 1,
    name: '北京汽车越野4S店（朝阳）',
    address: '北京市朝阳区建国路88号',
    distance: '2.3',
    rating: 4.9,
    hours: '09:00 - 18:00',
    tags: ['官方认证', '维修保养', '新车销售'],
    lat: 40, left: '50%', top: '45%'
  },
  {
    id: 2,
    name: '北京汽车特约维修中心（海淀）',
    address: '北京市海淀区中关村大街1号',
    distance: '5.6',
    rating: 4.7,
    hours: '08:30 - 19:00',
    tags: ['维修保养', '配件中心'],
    lat: 30, left: '20%', top: '30%'
  },
  {
    id: 3,
    name: '北京汽车体验中心（亦庄）',
    address: '北京市大兴区经济技术开发区',
    distance: '12.8',
    rating: 4.8,
    hours: '09:00 - 20:00',
    tags: ['试驾体验', '新车销售'],
    lat: 60, left: '75%', top: '65%'
  },
  {
    id: 4,
    name: '北京汽车城市展厅（三里屯）',
    address: '北京市朝阳区三里屯路19号',
    distance: '3.1',
    rating: 4.6,
    hours: '10:00 - 22:00',
    tags: ['品牌展示', '生活方式'],
    lat: 45, left: '40%', top: '35%'
  }
];

interface NearbyStoresViewProps {
  onBack: () => void;
}

const NearbyStoresView: React.FC<NearbyStoresViewProps> = ({ onBack }) => {
  const [selectedStore, setSelectedStore] = useState(STORES[0]);
  const [viewMode, setViewMode] = useState<'map' | 'list'>('map');
  const [showRoute, setShowRoute] = useState(false);

  const handleNavigate = () => {
    setShowRoute(true);
    setTimeout(() => {
        alert(`已开始导航前往：${selectedStore.name}`);
    }, 1000);
  };

  return (
    <div className="absolute inset-0 z-[100] bg-white flex flex-col animate-in slide-in-from-right duration-300">
       {/* Floating Header */}
       <div className="absolute top-0 left-0 right-0 z-20 pt-[54px] px-5 pb-3 flex justify-between items-center pointer-events-none">
          <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full bg-white/90 backdrop-blur-md shadow-[0_4px_12px_rgba(0,0,0,0.06)] flex items-center justify-center pointer-events-auto active:scale-90 transition-transform text-[#111] border border-white/20">
              <ArrowLeft size={22} />
          </button>
          
          <div className="flex gap-3 pointer-events-auto">
             <button onClick={() => setViewMode(viewMode === 'map' ? 'list' : 'map')} className="w-10 h-10 rounded-full bg-white/90 backdrop-blur-md shadow-[0_4px_12px_rgba(0,0,0,0.06)] flex items-center justify-center active:scale-90 transition-transform text-[#111] border border-white/20">
                {viewMode === 'map' ? <List size={20} /> : <Compass size={20} />}
             </button>
             <button className="w-10 h-10 rounded-full bg-white/90 backdrop-blur-md shadow-[0_4px_12px_rgba(0,0,0,0.06)] flex items-center justify-center active:scale-90 transition-transform text-[#111] border border-white/20">
                 <Search size={20} />
             </button>
          </div>
       </div>

       {/* Map View */}
       <div className={`flex-1 relative bg-gray-100 overflow-hidden transition-opacity duration-300 ${viewMode === 'map' ? 'opacity-100' : 'opacity-0 absolute inset-0'}`}>
           <div className="absolute inset-0 bg-cover bg-center" style={{backgroundImage: 'url(https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200&auto=format&fit=crop)', filter: 'grayscale(0.1) contrast(0.9) brightness(1.1)'}}>
               <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-0">
                   <div className="w-16 h-16 bg-blue-500/20 rounded-full flex items-center justify-center animate-pulse">
                        <div className="w-4 h-4 bg-blue-500 border-2 border-white rounded-full shadow-lg"></div>
                   </div>
               </div>

               {STORES.map(store => (
                   <div 
                     key={store.id}
                     className={`absolute w-12 h-12 -ml-6 -mt-12 flex flex-col items-center justify-center cursor-pointer transition-all duration-500 ease-out ${selectedStore.id === store.id ? 'z-20 scale-110 -translate-y-2' : 'z-10 scale-100'}`}
                     style={{ left: store.left, top: store.top }}
                     onClick={() => {
                         setSelectedStore(store);
                         setShowRoute(false);
                     }}
                   >
                       <div className={`w-10 h-10 rounded-full flex items-center justify-center border-[3px] border-white shadow-xl transition-colors duration-300 ${selectedStore.id === store.id ? 'bg-[#111] text-white' : 'bg-white text-[#111]'}`}>
                           {selectedStore.id === store.id ? <Car size={18} /> : <MapPin size={18} />}
                       </div>
                   </div>
               ))}
           </div>
           
           <div className="absolute right-5 top-[120px] flex flex-col gap-3">
               <button className="w-10 h-10 rounded-2xl bg-white shadow-lg flex items-center justify-center text-[#111] active:scale-95 transition-transform border border-gray-100">
                   <LocateFixed size={20} />
               </button>
           </div>
           
           {/* Bottom Sheet - Radius-L+ (32px) */}
           <div className="absolute bottom-0 left-0 right-0 z-30">
               <div className="bg-white rounded-t-[32px] p-6 pb-[40px] shadow-[0_-10px_40px_rgba(0,0,0,0.1)] animate-in slide-in-from-bottom-10 duration-500">
                   <div className="w-10 h-1.5 bg-gray-100 rounded-full mx-auto mb-6" />
                   <div className="flex justify-between items-start mb-5">
                       <div>
                           <h3 className="text-[19px] font-bold text-[#111] mb-1.5">{selectedStore.name}</h3>
                           <div className="text-[13px] text-gray-500 flex items-center gap-1.5 mb-3">
                               <Clock size={12} className="text-gray-400" /> {selectedStore.hours}
                               <span className="w-px h-2.5 bg-gray-200 mx-0.5" />
                               <Star size={12} className="fill-[#FFB800] text-[#FFB800]" /> 
                               <span className="font-bold text-[#111]">{selectedStore.rating}</span>
                           </div>
                           <div className="flex gap-2">
                               {selectedStore.tags.map(tag => (
                                   <span key={tag} className="px-2.5 py-0.5 rounded-lg bg-[#F5F7FA] text-[#6B7280] text-[11px] font-medium border border-gray-100">
                                       {tag}
                                   </span>
                               ))}
                           </div>
                       </div>
                       <div className="flex flex-col items-end">
                            <div className="text-[24px] font-bold text-[#111] font-oswald leading-none mb-0.5">{selectedStore.distance}</div>
                            <div className="text-[10px] text-[#9CA3AF] uppercase font-bold tracking-wider">KM</div>
                       </div>
                   </div>

                   <div className="flex items-center gap-3 text-[13px] text-[#4B5563] bg-[#F9FAFB] p-3.5 rounded-2xl mb-6 border border-gray-50">
                       <MapPin size={16} className="shrink-0 text-[#9CA3AF]" />
                       <div className="truncate font-medium">{selectedStore.address}</div>
                   </div>

                   <div className="flex gap-3">
                       <button className="flex-1 h-12 rounded-2xl border border-gray-200 bg-white text-[#111] font-bold text-[15px] flex items-center justify-center gap-2 active:bg-gray-50 transition-all">
                           <Phone size={18} /> 致电
                       </button>
                       <button 
                         onClick={handleNavigate}
                         className="flex-1 h-12 rounded-2xl bg-[#111827] text-white font-bold text-[15px] flex items-center justify-center gap-2 shadow-lg shadow-black/10 active:scale-[0.98] transition-all"
                       >
                           <Navigation size={18} /> 导航前往
                       </button>
                   </div>
               </div>
           </div>
       </div>

       {/* List View - Radius-M (16px) */}
       <div className={`flex-1 bg-[#F5F7FA] overflow-y-auto pt-[100px] px-5 pb-10 transition-opacity duration-300 ${viewMode === 'list' ? 'opacity-100 z-10' : 'opacity-0 absolute inset-0 pointer-events-none'}`}>
           <h2 className="text-[22px] font-bold text-[#111] mb-6">全部门店 <span className="text-gray-400 font-normal text-sm ml-1">({STORES.length})</span></h2>
           <div className="flex flex-col gap-4">
               {STORES.map(store => (
                   <div 
                     key={store.id}
                     onClick={() => {
                         setSelectedStore(store);
                         setViewMode('map');
                     }}
                     className="bg-white rounded-2xl p-5 shadow-[0_2px_14px_rgba(0,0,0,0.04)] active:scale-[0.99] transition-transform border border-transparent hover:border-gray-100 group"
                   >
                       <div className="flex justify-between items-start mb-2.5">
                           <h3 className="text-[16px] font-bold text-[#111] line-clamp-1 flex-1 group-active:text-[#FF6B00] transition-colors">{store.name}</h3>
                           <div className="flex items-center gap-1 text-[#FF6B00] bg-orange-50 px-2.5 py-0.5 rounded-lg font-oswald text-[12px] font-bold whitespace-nowrap ml-3">
                               <Navigation size={10} /> {store.distance} km
                           </div>
                       </div>
                       <div className="text-[13px] text-[#6B7280] mb-4">{store.address}</div>
                       <div className="flex items-center justify-between border-t border-gray-50 pt-3.5">
                           <div className="flex gap-2">
                               {store.tags.slice(0, 2).map(tag => (
                                   <span key={tag} className="text-[10px] text-[#9CA3AF] border border-gray-100 px-2 py-0.5 rounded-lg font-medium">
                                       {tag}
                                   </span>
                               ))}
                           </div>
                           <div className="flex items-center gap-1 text-[12px] font-bold text-[#111]">
                               详情 <ChevronRight size={14} className="text-gray-300" />
                           </div>
                       </div>
                   </div>
               ))}
           </div>
       </div>
    </div>
  );
};

export default NearbyStoresView;
