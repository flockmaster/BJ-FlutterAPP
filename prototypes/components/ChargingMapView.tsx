
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Filter, 
  Zap, 
  Navigation,
  List,
  Map as MapIcon,
  BatteryCharging
} from 'lucide-react';

interface ChargingMapViewProps {
  onBack: () => void;
}

const STATIONS = [
    { id: 1, name: '北京汽车超级充电站(朝阳)', distance: '0.8', price: '1.2', fast: 12, slow: 4, lat: 40, left: '50%', top: '45%', brand: 'BAIC' },
    { id: 2, name: '国家电网公共充电站', distance: '1.5', price: '1.5', fast: 8, slow: 8, lat: 30, left: '20%', top: '30%', brand: 'STATE' },
    { id: 3, name: '特来电充电站(SOHO)', distance: '2.1', price: '1.8', fast: 20, slow: 0, lat: 60, left: '75%', top: '65%', brand: 'TELD' },
];

const ChargingMapView: React.FC<ChargingMapViewProps> = ({ onBack }) => {
  const [selectedStation, setSelectedStation] = useState(STATIONS[0]);

  return (
    <div className="absolute inset-0 z-[100] bg-white flex flex-col animate-in slide-in-from-right duration-300">
        {/* Floating Header */}
        <div className="absolute top-0 left-0 right-0 z-20 pt-[54px] px-5 pb-3 flex gap-3 pointer-events-none">
            <button onClick={onBack} className="w-10 h-10 rounded-full bg-white/90 backdrop-blur-md shadow-[0_4px_15px_rgba(0,0,0,0.08)] flex items-center justify-center pointer-events-auto text-[#111] active:scale-90 transition-transform border border-white/20">
                <ArrowLeft size={22} />
            </button>
            <div className="flex-1 h-10 bg-white/90 backdrop-blur-md rounded-full shadow-[0_4px_15px_rgba(0,0,0,0.08)] flex items-center px-4 gap-2 pointer-events-auto border border-white/20">
                <Search size={18} className="text-gray-400" />
                <input type="text" placeholder="搜索充电站" className="bg-transparent outline-none text-[14px] flex-1 font-medium" />
            </div>
            <button className="w-10 h-10 rounded-full bg-white/90 backdrop-blur-md shadow-[0_4px_15px_rgba(0,0,0,0.08)] flex items-center justify-center pointer-events-auto text-[#111] active:scale-90 transition-transform border border-white/20">
                <Filter size={20} />
            </button>
        </div>

        {/* Map Area */}
        <div className="flex-1 relative bg-gray-100">
            <div className="absolute inset-0 bg-cover bg-center" style={{backgroundImage: 'url(https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200&auto=format&fit=crop)', filter: 'grayscale(0.3) contrast(1.1)'}}>
                {STATIONS.map(station => (
                    <div 
                        key={station.id}
                        className={`absolute -ml-6 -mt-12 flex flex-col items-center cursor-pointer transition-all duration-300 ${selectedStation.id === station.id ? 'z-20 scale-110' : 'z-10 scale-100'}`}
                        style={{ left: station.left, top: station.top }}
                        onClick={() => setSelectedStation(station)}
                    >
                        <div className={`px-3 py-1.5 rounded-2xl shadow-xl flex flex-col items-center mb-1.5 border-[3px] transition-colors ${
                            selectedStation.id === station.id ? 'bg-[#111] text-white border-white' : 'bg-white text-[#111] border-white'
                        }`}>
                            <div className="flex items-center gap-1">
                                <Zap size={13} className={selectedStation.id === station.id ? 'fill-[#FFD700] text-[#FFD700]' : 'fill-[#FF6B00] text-[#FF6B00]'} />
                                <span className="text-[13px] font-bold font-oswald">¥{station.price}</span>
                            </div>
                        </div>
                        <div className="w-2.5 h-2.5 bg-black/30 rounded-full blur-[1px]"></div>
                    </div>
                ))}
            </div>

            {/* Bottom Card - Radius-L (24px) */}
            <div className="absolute bottom-0 left-0 right-0 p-5 pb-[40px]">
                <div className="bg-white rounded-[28px] p-6 shadow-[0_10px_50px_rgba(0,0,0,0.12)] animate-in slide-in-from-bottom duration-300 border border-gray-50">
                    <div className="w-10 h-1 bg-gray-100 rounded-full mx-auto mb-6" />
                    <div className="flex justify-between items-start mb-6">
                        <div>
                            <h3 className="text-[19px] font-bold text-[#111] mb-1.5">{selectedStation.name}</h3>
                            <div className="text-[13px] text-[#6B7280] mb-4 flex items-center gap-2 font-medium">
                                <span>距离 <span className="font-oswald">{selectedStation.distance}</span>km</span>
                                <span className="w-px h-3 bg-gray-200"></span>
                                <span className="text-[#FF6B00]">官方认证 · 对外开放</span>
                            </div>
                            <div className="flex gap-3">
                                <div className="bg-[#F0FDF4] px-3 py-1.5 rounded-xl border border-[#DCFCE7] shadow-sm">
                                    <div className="text-[10px] text-[#166534] mb-0.5 font-bold uppercase tracking-wider">Fast Charge</div>
                                    <div className="text-[15px] font-bold text-[#15803D] font-oswald">{selectedStation.fast}<span className="text-[10px] font-bold ml-1 text-[#166534]/60">空闲</span></div>
                                </div>
                                <div className="bg-[#EFF6FF] px-3 py-1.5 rounded-xl border border-[#DBEAFE] shadow-sm">
                                    <div className="text-[10px] text-[#1E40AF] mb-0.5 font-bold uppercase tracking-wider">Slow Charge</div>
                                    <div className="text-[15px] font-bold text-[#1D4ED8] font-oswald">{selectedStation.slow}<span className="text-[10px] font-bold ml-1 text-[#1E40AF]/60">空闲</span></div>
                                </div>
                            </div>
                        </div>
                        <div className="text-right">
                            <div className="text-[26px] font-bold font-oswald text-[#FF6B00] leading-none mb-1">{selectedStation.price}</div>
                            <div className="text-[10px] text-[#9CA3AF] font-bold uppercase tracking-tighter">RMB / KWH</div>
                        </div>
                    </div>

                    <div className="flex gap-3">
                        <button className="flex-1 h-12 rounded-2xl border border-gray-200 bg-white text-[#111] font-bold text-[15px] flex items-center justify-center gap-2 active:bg-gray-50 transition-all">
                            <BatteryCharging size={18} /> 降地锁
                        </button>
                        <button className="flex-1 h-12 rounded-2xl bg-[#111827] text-white font-bold text-[15px] flex items-center justify-center gap-2 shadow-lg shadow-black/10 active:scale-[0.98] transition-all">
                            <Navigation size={18} /> 导航前往
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
  );
};

export default ChargingMapView;
