
import React, { useState, useEffect } from 'react';
import {
  Headset,
  Ambulance,
  ChevronRight,
  Map,
  Zap,
  Clock,
  Phone,
  Navigation,
  Sparkles,
  User,
  CircleParking,
  Calculator,
  ShieldCheck,
  ChevronDown,
  FileText,
  AlertTriangle,
  BookOpen,
  Activity,
  History,
  Settings,
  Car,
  QrCode,
  Smartphone,
  Gauge,
  ScanLine,
  Fuel,
  MapPin,
  Star
} from 'lucide-react';
import NearbyStoresView from './NearbyStoresView';
import RoadsideAssistanceView from './RoadsideAssistanceView'; 
import MaintenanceScheduleView from './MaintenanceScheduleView'; 
import ChargingMapView from './ChargingMapView'; 
import ScanChargingView from './ScanChargingView'; 
import PrivatePileView from './PrivatePileView'; 
import ChargingOrdersView from './ChargingOrdersView'; 
import DesignatedDriverView from './DesignatedDriverView'; 
import LocalServicesView from './LocalServicesView'; 
import UsedCarValuationView from './UsedCarValuationView'; 
import CustomerServiceView from './CustomerServiceView'; 
import FaultReportingView from './FaultReportingView';
import TireTrackBackground from './ui/TireTrackBackground';

// --- Design System Constants ---
const COLOR_BG = 'bg-[#F5F7FA]'; // L0 Canvas
const COLOR_SURFACE = 'bg-white'; // L1 Surface
const COLOR_TEXT_MAIN = 'text-[#111827]'; // Brand Dark
const SHADOW_CARD = 'shadow-[0_4px_20px_rgba(0,0,0,0.05)]'; // Ambient Light Shadow
const FONT_NUM = 'font-oswald'; // For data/numbers

interface ServiceViewProps {
  hasVehicle?: boolean;
}

const ServiceView: React.FC<ServiceViewProps> = ({ hasVehicle }) => {
  const [isLoading, setIsLoading] = useState(true);
  
  // State for Card Expansion
  const [isVehicleExpanded, setIsVehicleExpanded] = useState(false);
  
  // Navigation State
  const [activeSubView, setActiveSubView] = useState<
    'none' | 'nearby' | 'rescue' | 'maintenance' | 'charging_map' | 
    'scan' | 'private_pile' | 'charging_orders' | 'driver' | 
    'wash' | 'fuel' | 'parking' | 'valuation' | 'customer_service' | 'fault_report'
  >('none');

  useEffect(() => {
    // Simulate Data Loading
    const timer = setTimeout(() => setIsLoading(false), 1200);
    return () => clearTimeout(timer);
  }, []);

  // --- Skeleton Screen ---
  if (isLoading) {
      return (
          <div className={`h-full w-full ${COLOR_BG} flex flex-col`}>
              {/* Header Skeleton */}
              <div className="pt-[54px] px-5 pb-3 flex justify-between items-center">
                  <div className="w-16 h-8 bg-gray-200 rounded animate-shimmer" />
                  <div className="w-8 h-8 rounded-full bg-gray-200 animate-shimmer" />
              </div>
              
              {/* Grid Skeleton */}
              <div className="px-5 pt-4 pb-2 grid grid-cols-2 gap-3">
                  <div className="row-span-2 h-[280px] bg-gray-200 rounded-[24px] animate-shimmer" />
                  <div className="h-[134px] bg-gray-200 rounded-[24px] animate-shimmer" />
                  <div className="h-[134px] bg-gray-200 rounded-[24px] animate-shimmer" />
              </div>

              {/* Vehicle Card Skeleton (Conditional) */}
              {hasVehicle && <div className="mx-5 my-4 h-[180px] bg-gray-200 rounded-2xl animate-shimmer" />}
              
              {/* Other Services Skeleton */}
              <div className={`mx-5 h-[120px] bg-gray-200 rounded-2xl animate-shimmer mb-4 ${!hasVehicle ? 'mt-4' : ''}`} />
          </div>
      );
  }

  return (
    <div className={`h-full w-full relative ${COLOR_BG} flex flex-col animate-in fade-in duration-500`}>
       {/* Secondary Views Overlay */}
       {activeSubView === 'nearby' && <NearbyStoresView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'rescue' && <RoadsideAssistanceView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'maintenance' && <MaintenanceScheduleView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'charging_map' && <ChargingMapView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'scan' && <ScanChargingView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'private_pile' && <PrivatePileView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'charging_orders' && <ChargingOrdersView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'driver' && <DesignatedDriverView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'wash' && <LocalServicesView type="wash" onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'fuel' && <LocalServicesView type="fuel" onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'parking' && <LocalServicesView type="parking" onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'valuation' && <UsedCarValuationView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'customer_service' && <CustomerServiceView onBack={() => setActiveSubView('none')} />}
       {activeSubView === 'fault_report' && (
           <FaultReportingView 
             onBack={() => setActiveSubView('none')} 
             onNavigateToRescue={() => setActiveSubView('rescue')}
             onNavigateToBooking={() => setActiveSubView('maintenance')}
           />
       )}

       {/* Scrollable Content Container */}
       <div className="flex-1 overflow-y-auto pb-[100px] no-scrollbar">
           {/* Sticky Header - Immersive L0 Style */}
           <div className={`sticky top-0 z-30 ${COLOR_BG}/95 backdrop-blur-md pt-[54px]`}>
              <div className="flex justify-between items-center px-5 py-3">
                 <div className={`text-[20px] font-bold ${COLOR_TEXT_MAIN}`}>
                    服务
                 </div>
                 <button 
                    onClick={() => setActiveSubView('customer_service')}
                    className={`${COLOR_TEXT_MAIN} active:opacity-60 transition-opacity`}
                 >
                    <Headset size={24} />
                 </button>
              </div>
           </div>

           {/* Core Services Grid - Radius-L (24px) for Hero Cards (Top Section) */}
           <div className="px-5 pt-4 pb-2">
              <div className="grid grid-cols-2 gap-3">
                  <div 
                    onClick={() => setActiveSubView('rescue')}
                    className={`row-span-2 h-[280px] rounded-3xl overflow-hidden relative ${SHADOW_CARD} group cursor-pointer active:scale-[0.98] transition-transform`}
                  >
                      {/* Roadside Assistance Image */}
                      <div className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-105" style={{backgroundImage: "url('https://p.sda1.dev/29/ccf10533e046e59cb78877c9c14144a6/c696f5542502642a9e01aec18f8eeca4.jpg')"}} />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent" />
                      <div className="relative z-10 p-5 h-full flex flex-col justify-end text-white">
                          <div className="w-10 h-10 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center mb-3 border border-white/10">
                              <Ambulance size={20} className="text-white" />
                          </div>
                          <div className="text-[18px] font-bold mb-0.5">道路救援</div>
                          <div className="text-[12px] opacity-80 font-medium">24小时极速响应</div>
                      </div>
                  </div>

                  <div 
                    onClick={() => setActiveSubView('maintenance')}
                    className={`h-[134px] rounded-3xl overflow-hidden relative ${SHADOW_CARD} group cursor-pointer active:scale-[0.98] transition-transform`}
                  >
                       {/* Updated Maintenance Image */}
                       <div className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-105" style={{backgroundImage: "url('https://p.sda1.dev/29/ae3ed8bbc50175c27a2798406f77be37/d54f2febf1d2139c8791c1a472ceed79.jpg')"}} />
                       <div className="absolute inset-0 bg-black/50" />
                       <div className="relative z-10 p-5 h-full flex flex-col justify-between">
                            <div className="flex justify-end">
                                <ArrowIcon />
                            </div>
                            <div>
                                <div className="text-[16px] font-bold text-white">预约保养</div>
                                <div className="text-[11px] text-white/80">省时省心</div>
                            </div>
                       </div>
                  </div>

                  <div 
                    onClick={() => setActiveSubView('fault_report')}
                    className={`h-[134px] rounded-3xl overflow-hidden relative ${SHADOW_CARD} group cursor-pointer active:scale-[0.98] transition-transform`}
                  >
                       {/* Updated Fault Reporting Image */}
                       <div className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-105" style={{backgroundImage: "url('https://p.sda1.dev/29/f5cbce1cb2aae7be70f8cd26d1e422f1/7bf05d8c5794b1a908c1bd70e1de7b26.jpg')"}} />
                       <div className="absolute inset-0 bg-black/50" />
                       <div className="relative z-10 p-5 h-full flex flex-col justify-between">
                            <div className="flex justify-end">
                                <ArrowIcon />
                            </div>
                            <div>
                                <div className="text-[16px] font-bold text-white">故障报修</div>
                                <div className="text-[11px] text-white/80">AI 智能诊断</div>
                            </div>
                       </div>
                  </div>
              </div>
           </div>

           {/* EXPANDABLE Vehicle Card - UNIFIED to rounded-2xl (16px) */}
           {/* Only show if hasVehicle is true */}
           {hasVehicle && (
               <div 
                 onClick={() => setIsVehicleExpanded(!isVehicleExpanded)}
                 className={`mx-5 mt-4 mb-5 ${COLOR_SURFACE} rounded-2xl ${SHADOW_CARD} relative overflow-hidden cursor-pointer transition-all duration-500 ease-in-out border border-white`}
               >
                  {/* Off-Road Tire Track Background (Modified for fixed position) - Radius matched */}
                  <TireTrackBackground />

                  {/* Main Content Area (Always Visible) */}
                  <div className="relative z-10 p-6 pb-2">
                      <div className="flex justify-between">
                         <div className="flex-1 max-w-[65%]">
                            {/* Header */}
                            <div className="mb-6">
                               <h2 className={`text-[22px] font-bold ${COLOR_TEXT_MAIN} mb-1.5 leading-none`}>北京BJ40 PLUS</h2>
                               <div className="flex items-center gap-2">
                                  <span className="bg-[#F5F7FA] text-gray-500 text-[10px] px-2 py-0.5 rounded font-oswald border border-gray-100">京A·12345</span>
                                  <span className="flex items-center text-[10px] text-[#00B894] bg-[#E6FFFA] px-2 py-0.5 rounded font-bold">
                                      <ShieldCheck size={10} className="mr-1" /> 健康
                                  </span>
                               </div>
                            </div>

                            {/* Maintenance Monitor */}
                            <div>
                                <div className="text-[11px] text-gray-400 font-bold mb-1 flex items-center gap-1 uppercase tracking-tight">
                                   距离下次保养
                                </div>
                                
                                <div className="flex items-baseline gap-1 mb-3">
                                    <span className={`text-[36px] font-bold ${COLOR_TEXT_MAIN} ${FONT_NUM} leading-none tracking-tight`}>2,000</span>
                                    <span className="text-[14px] text-gray-400 font-medium">km</span>
                                </div>

                                {/* Progress Bar */}
                                <div className="w-[140px] h-1.5 bg-gray-100 rounded-full mb-4 overflow-hidden relative">
                                    <div className="absolute inset-0 bg-gray-100" />
                                    <div className="relative h-full bg-gradient-to-r from-[#00B894] to-[#00A884] w-[20%] rounded-full shadow-[0_0_10px_rgba(0,184,148,0.3)]" />
                                </div>

                                <div className="inline-flex items-center gap-1.5 bg-[#F9FAFB]/80 backdrop-blur-sm px-2.5 py-1.5 rounded-lg border border-gray-50">
                                    <Clock size={10} className="text-gray-400" />
                                    <span className="text-[10px] text-gray-400 font-medium">上次维保: <span className={FONT_NUM}>2024.06.15</span></span>
                                </div>
                            </div>
                         </div>

                         {/* Car Image - Animated on Expansion */}
                         <div className={`absolute -right-8 bottom-4 w-[210px] pointer-events-none transition-all duration-500 ${isVehicleExpanded ? 'translate-y-[-20px] scale-90 opacity-40 blur-[2px]' : 'translate-y-0 scale-100 opacity-100'}`}>
                             <img 
                               src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" 
                               className="w-full object-contain drop-shadow-xl" 
                               alt="My Car"
                             />
                         </div>
                      </div>
                  </div>

                  {/* Expansion Trigger Indicator - Updated with Animation */}
                  <div className="flex justify-center pb-2 relative z-10">
                      <div 
                        className={`transition-all duration-500 flex items-center justify-center w-7 h-7 rounded-full shadow-sm border border-gray-100/50 ${isVehicleExpanded ? 'rotate-180 bg-gray-100 text-gray-600' : 'bg-white text-gray-400 animate-bounce'}`}
                      >
                          <ChevronDown size={16} />
                      </div>
                  </div>

                  {/* Collapsible Content Area */}
                  <div 
                    className={`relative z-10 overflow-hidden transition-all duration-500 ease-in-out ${isVehicleExpanded ? 'max-h-[500px] opacity-100' : 'max-h-0 opacity-0'}`}
                  >
                      <div className="px-6 pb-6 pt-2 border-t border-gray-50 mt-2">
                          {/* Basic Info Row */}
                          <div className="flex justify-between mb-6 bg-[#F9FAFB] p-3 rounded-xl border border-gray-100">
                              <div className="flex flex-col items-center flex-1 border-r border-gray-200 last:border-0">
                                  <span className="text-[10px] text-gray-400 mb-1">总里程</span>
                                  <span className={`text-[14px] font-bold text-[#111] ${FONT_NUM}`}>8,521 km</span>
                              </div>
                              <div className="flex flex-col items-center flex-1 border-r border-gray-200 last:border-0">
                                  <span className="text-[10px] text-gray-400 mb-1">剩余流量</span>
                                  <span className={`text-[14px] font-bold text-[#111] ${FONT_NUM}`}>8.5 GB</span>
                              </div>
                              <div className="flex flex-col items-center flex-1">
                                  <span className="text-[10px] text-gray-400 mb-1">保险到期</span>
                                  <span className={`text-[14px] font-bold text-[#111] ${FONT_NUM}`}>25.06.15</span>
                              </div>
                          </div>

                          {/* Functional Grid - UPDATED to Monochrome (Gray/Black) */}
                          <div className="grid grid-cols-4 gap-y-6 gap-x-2">
                              <VehicleFuncIcon icon={Activity} label="用车报告" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              <VehicleFuncIcon icon={History} label="维保记录" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              <VehicleFuncIcon icon={BookOpen} label="用车手册" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              <VehicleFuncIcon icon={AlertTriangle} label="违章查询" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              
                              <VehicleFuncIcon icon={FileText} label="保险单据" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              <VehicleFuncIcon icon={Gauge} label="油耗统计" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              <VehicleFuncIcon icon={Smartphone} label="流量充值" color="text-[#111]" bg="bg-[#F5F7FA]" />
                              <VehicleFuncIcon icon={Settings} label="车辆设置" color="text-[#111]" bg="bg-[#F5F7FA]" />
                          </div>
                      </div>
                  </div>
               </div>
           )}

           {/* Charging Service - Rounded-2xl (Standard) - Spacing Adjusted to mb-5 (20px) */}
           {/* Add margin top if vehicle card is hidden to maintain spacing from grid */}
           <div className={`px-5 mb-5 ${!hasVehicle ? 'mt-4' : ''}`}>
                <div className={`${COLOR_SURFACE} rounded-2xl overflow-hidden ${SHADOW_CARD}`}>
                    {/* Top Image Section */}
                    <div 
                        className="h-[120px] bg-cover bg-center relative"
                        style={{ backgroundImage: "url('https://p.sda1.dev/29/d11d2775070be000a33612d78f3b187b/13.jpg')" }}
                    >
                        <div className="absolute inset-0 bg-black/10" />
                        <div className="absolute top-5 left-5 text-white text-[20px] font-bold tracking-wide">
                            充电服务
                        </div>
                    </div>

                    {/* Bottom Action Section */}
                    <div className="p-5 flex justify-between items-center bg-white">
                        <ChargingActionItem 
                            icon={Map} 
                            label="充电地图" 
                            onClick={() => setActiveSubView('charging_map')}
                        />
                        <ChargingActionItem 
                            icon={ScanLine} 
                            label="扫码充电" 
                            onClick={() => setActiveSubView('scan')} 
                        />
                        <ChargingActionItem 
                            icon={Zap} 
                            label="私桩管理" 
                            onClick={() => setActiveSubView('private_pile')} 
                        />
                        <ChargingActionItem 
                            icon={History} 
                            label="充电订单" 
                            onClick={() => setActiveSubView('charging_orders')} 
                        />
                    </div>
                </div>
            </div>

           {/* Nearby Stores - UNIFIED to rounded-2xl - Spacing Adjusted to mb-5 (20px) */}
           <div className="px-5 mb-5">
                <div className="flex justify-between items-center mb-3 ml-1">
                    <div className={`text-[17px] font-bold ${COLOR_TEXT_MAIN}`}>附近门店</div>
                    <div 
                      onClick={() => setActiveSubView('nearby')}
                      className="flex items-center text-xs text-gray-400 gap-0.5 cursor-pointer active:opacity-60 font-medium"
                    >
                        全部 <ChevronRight size={14} />
                    </div>
                </div>
                
                {/* Map Widget Container */}
                <div 
                    onClick={() => setActiveSubView('nearby')}
                    className={`relative h-[200px] rounded-2xl overflow-hidden ${SHADOW_CARD} cursor-pointer group border border-white`}
                >
                    {/* Map Background (Simulated) */}
                    <div 
                        className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-105"
                        style={{backgroundImage: "url('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800&auto=format&fit=crop')", filter: 'grayscale(0.1)'}}
                    />
                    
                    {/* Map Pin */}
                    <div className="absolute top-[30%] left-[50%] -translate-x-1/2 -translate-y-1/2 flex flex-col items-center">
                        <div className="w-8 h-8 bg-[#FF6B00] rounded-full border-2 border-white shadow-lg flex items-center justify-center text-white animate-bounce">
                            <Car size={16} />
                        </div>
                        <div className="w-2 h-2 bg-black/20 rounded-full blur-[2px] mt-1" />
                    </div>

                    {/* Store Info Overlay */}
                    <div className="absolute bottom-3 left-3 right-3 bg-white/95 backdrop-blur-md p-4 rounded-2xl shadow-lg border border-white/50 flex justify-between items-center">
                        <div className="flex-1 overflow-hidden">
                            <div className="text-[15px] font-bold text-[#111] truncate mb-1">北京汽车越野4S店（朝阳）</div>
                            <div className="flex items-center gap-2 text-[11px] text-gray-500">
                                <span className="flex items-center gap-0.5 text-orange-500 font-bold bg-orange-50 px-1.5 py-0.5 rounded"><Star size={10} fill="currentColor"/> 4.9</span>
                                <span>|</span>
                                <span className="truncate">朝阳区建国路88号</span>
                            </div>
                        </div>
                        <div className="flex flex-col items-end pl-3 border-l border-gray-100 ml-3">
                            <div className="w-8 h-8 bg-[#111] rounded-full flex items-center justify-center text-white mb-1 shadow-md active:scale-90 transition-transform">
                                <Navigation size={14} />
                            </div>
                            <span className="text-[10px] font-bold text-[#111] font-oswald">2.3km</span>
                        </div>
                    </div>
                </div>
            </div>

           {/* Travel Services - Rounded-2xl (Standard) - Spacing Adjusted to mb-5 (20px) */}
           <div className="px-5 mb-5">
               <div className={`text-[17px] font-bold ${COLOR_TEXT_MAIN} mb-3 ml-1`}>出行服务</div>
               <div className="grid grid-cols-4 gap-3">
                   <CleanServiceItem 
                       icon={Sparkles} 
                       label="洗车" 
                       color="text-[#111]" 
                       bg="bg-[#F5F7FA]" 
                       onClick={() => setActiveSubView('wash')}
                   />
                   <CleanServiceItem 
                       icon={User} 
                       label="代驾" 
                       color="text-[#111]" 
                       bg="bg-[#F5F7FA]" 
                       onClick={() => setActiveSubView('driver')}
                   />
                   <CleanServiceItem 
                       icon={Fuel} 
                       label="加油" 
                       color="text-[#111]" 
                       bg="bg-[#F5F7FA]" 
                       onClick={() => setActiveSubView('fuel')}
                   />
                   <CleanServiceItem 
                       icon={CircleParking} 
                       label="停车" 
                       color="text-[#111]" 
                       bg="bg-[#F5F7FA]" 
                       onClick={() => setActiveSubView('parking')}
                   />
               </div>
           </div>

           {/* Used Car - UNIFIED to rounded-2xl */}
           <div className="px-5 mb-8">
                <div 
                    onClick={() => setActiveSubView('valuation')}
                    className="w-full h-[120px] rounded-2xl relative overflow-hidden group cursor-pointer shadow-lg"
                >
                    {/* UPDATED: Background Image */}
                    <div 
                        className="absolute inset-0 bg-cover bg-center transition-transform duration-700 group-hover:scale-105"
                        style={{backgroundImage: "url('https://youke3.picui.cn/s1/2026/01/07/695e21468733f.jpg')"}}
                    />
                    {/* Updated Gradient: Left black -> Right transparent */}
                    <div className="absolute inset-0 bg-gradient-to-r from-black/90 via-black/30 to-transparent" />
                    
                    {/* Content */}
                    <div className="absolute inset-0 p-5 flex items-center justify-between">
                        <div className="relative z-10 pl-2">
                            <div className="flex items-center gap-2 mb-1.5">
                                <span className="text-[20px] font-bold text-white tracking-wide">二手车评估</span>
                                <span className="bg-[#FFD700] text-[#111] text-[10px] font-bold px-2 py-0.5 rounded">官方认证</span>
                            </div>
                            <div className="text-[13px] text-white/90 font-medium">
                                极速报价 · 高价回收 · 置换补贴
                            </div>
                        </div>
                        
                        {/* Icon Removed */}
                    </div>
                </div>
            </div>
       </div>

       {/* Floating Support Button */}
       <div 
           onClick={() => setActiveSubView('customer_service')}
           className="absolute bottom-[100px] right-5 w-14 h-14 bg-[#111] text-white rounded-full flex items-center justify-center shadow-[0_8px_20px_rgba(0,0,0,0.3)] z-40 active:scale-90 transition-transform cursor-pointer border-2 border-white/10 animate-in fade-in zoom-in duration-500 delay-500"
       >
           <Headset size={24} />
       </div>
    </div>
  );
};

// Sub-components

const VehicleFuncIcon: React.FC<{ icon: any, label: string, color: string, bg: string }> = ({ icon: Icon, label, color, bg }) => (
    <div className="flex flex-col items-center gap-2 cursor-pointer active:scale-95 transition-transform">
        <div className={`w-11 h-11 rounded-full flex items-center justify-center ${bg} ${color}`}>
            <Icon size={20} strokeWidth={1.5} />
        </div>
        <span className="text-[11px] text-gray-500 font-medium">{label}</span>
    </div>
);

// New Clean Service Item Style - Standardized to Monochrome
const CleanServiceItem: React.FC<{ icon: any, label: string, color: string, bg: string, onClick?: () => void }> = ({ icon: Icon, label, color, bg, onClick }) => (
    <div 
        onClick={onClick}
        className="bg-white rounded-2xl p-4 flex flex-col items-center justify-center gap-2 shadow-sm border border-gray-50 cursor-pointer active:scale-95 transition-transform h-[90px]"
    >
        <div className={`w-10 h-10 rounded-full flex items-center justify-center ${bg} ${color}`}>
            <Icon size={20} strokeWidth={2} />
        </div>
        <span className="text-[12px] font-bold text-[#111]">{label}</span>
    </div>
);

const ChargingActionItem: React.FC<{ icon: any, label: string, onClick?: () => void }> = ({ icon: Icon, label, onClick }) => (
    <div 
        onClick={onClick}
        className="flex flex-col items-center gap-4 cursor-pointer active:scale-95 transition-transform"
    >
        <div className="text-[#111]">
            <Icon size={28} strokeWidth={1.5} />
        </div>
        <span className="text-[13px] text-[#333] font-medium">{label}</span>
    </div>
);

const ArrowIcon = () => (
    <div className="w-7 h-7 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center">
        <ChevronRight size={16} className="text-white" />
    </div>
)

export default ServiceView;
