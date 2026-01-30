
import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  Camera, 
  Image as ImageIcon, 
  X, 
  Zap, 
  AlertTriangle, 
  CheckCircle2, 
  Info, 
  Phone, 
  Wrench, 
  ChevronRight, 
  ScanLine,
  Activity,
  Cpu,
  Thermometer,
  FileText,
  ShieldCheck,
  Loader2,
  Database,
  Search
} from 'lucide-react';
import TireTrackBackground from './ui/TireTrackBackground';

interface FaultReportingViewProps {
  onBack: () => void;
  onNavigateToRescue?: () => void;
  onNavigateToBooking?: () => void;
}

// Mock Data with authoritative technical details
const MOCK_RESULT = {
    severity: 'warning', // 'danger' | 'warning' | 'info'
    code: 'P0420', // OBD-II Error Code
    system: '动力总成 / 排放控制',
    title: '三元催化器转化效率低',
    timestamp: '2024-01-24 14:32:05',
    confidence: '98.5%',
    technicalAnalysis: 'ECU 监测到 B1 组三元催化器下游氧传感器信号波形与上游趋同，表明催化器储氧能力下降，未达到排放标准阈值。',
    driverAdvice: '车辆目前未进入保护模式，仍可正常行驶，但油耗可能略有上升。建议近期前往服务中心进行进一步排查，长期忽视可能影响年检或导致排气系统损坏。',
};

const FaultReportingView: React.FC<FaultReportingViewProps> = ({ onBack, onNavigateToRescue, onNavigateToBooking }) => {
  const [step, setStep] = useState<'start' | 'camera' | 'analyzing' | 'result'>('start');
  const [capturedImage, setCapturedImage] = useState<string | null>(null);
  
  // Simulation for AI Analysis
  useEffect(() => {
      if (step === 'analyzing') {
          const timer = setTimeout(() => {
              setStep('result');
          }, 2500); 
          return () => clearTimeout(timer);
      }
  }, [step]);

  const handleCapture = () => {
      setCapturedImage('https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=800&auto=format&fit=crop'); 
      setStep('analyzing');
  };

  const getSeverityConfig = (severity: string) => {
      switch(severity) {
          case 'danger': return { 
              color: 'text-[#D93025]', 
              bg: 'bg-[#D93025]', 
              lightBg: 'bg-[#FEE2E2]',
              icon: AlertTriangle,
              label: '高风险 · 建议停车'
          };
          case 'warning': return { 
              color: 'text-[#F59E0B]', 
              bg: 'bg-[#F59E0B]', 
              lightBg: 'bg-[#FEF3C7]',
              icon: Info,
              label: '警告 · 建议检查'
          };
          default: return { 
              color: 'text-[#10B981]', 
              bg: 'bg-[#10B981]', 
              lightBg: 'bg-[#D1FAE5]',
              icon: CheckCircle2,
              label: '正常 · 系统良好'
          };
      }
  };

  const statusConfig = getSeverityConfig(MOCK_RESULT.severity);
  const StatusIcon = statusConfig.icon;

  // --- 1. Start Screen: Professional Diagnostic Tool Look ---
  const renderStartScreen = () => (
      <div className="flex-1 flex flex-col relative overflow-hidden bg-[#F9FAFB]">
          <TireTrackBackground className="opacity-[0.03]" />
          
          <div className="flex-1 flex flex-col items-center justify-center relative z-10 px-6 pt-8">
              
              {/* Illustration Area */}
              <div className="w-full max-w-[340px] mb-8 relative">
                  {/* The Image with mix-blend-darken to remove white background visually */}
                  <img 
                    src="https://p.sda1.dev/29/c5d0f19a3ce15bb494b6e2fbd583226d/2c96cb8ae1274cd8d951cd612bbb9cbf.jpg" 
                    className="w-full h-auto mix-blend-darken opacity-90 contrast-110"
                    alt="Diagnostic Guide"
                  />
                  
                  {/* Tech Animation Overlay: Simulating the phone scanning */}
                  {/* Positioning tuned to fit the phone screen in the illustration */}
                  <div className="absolute top-[38%] left-[29%] w-[22%] h-[1px] bg-red-500/80 shadow-[0_0_8px_rgba(239,68,68,0.8)] animate-[scan-short_2s_ease-in-out_infinite] rotate-[-5deg]" />
              </div>

              <div className="text-center mb-10">
                  <h2 className="text-[26px] font-bold text-[#111] mb-2 tracking-tight">智能故障诊断系统</h2>
                  <div className="flex items-center justify-center gap-2 text-[12px] text-gray-400 font-medium">
                      <span className="bg-[#111] text-white px-1.5 py-0.5 rounded text-[10px] font-bold">PRO</span>
                      <span className="uppercase tracking-widest">AI Diagnostics v3.0</span>
                  </div>
              </div>

              {/* Capability Indicators */}
              <div className="w-full max-w-[320px] grid grid-cols-2 gap-3 mb-6">
                  <div className="flex flex-col items-center bg-white p-4 rounded-xl border border-gray-100 shadow-sm relative overflow-hidden">
                      <div className="absolute top-0 right-0 w-8 h-8 bg-gray-50 rounded-bl-full -mr-2 -mt-2" />
                      <Database size={24} className="text-[#111] mb-2" strokeWidth={1.5} />
                      <div className="text-[13px] font-bold text-[#111]">千万级案例库</div>
                      <div className="text-[10px] text-gray-400 mt-0.5">覆盖全系车型数据</div>
                  </div>
                  <div className="flex flex-col items-center bg-white p-4 rounded-xl border border-gray-100 shadow-sm relative overflow-hidden">
                      <div className="absolute top-0 right-0 w-8 h-8 bg-gray-50 rounded-bl-full -mr-2 -mt-2" />
                      <Cpu size={24} className="text-[#111] mb-2" strokeWidth={1.5} />
                      <div className="text-[13px] font-bold text-[#111]">AI 视觉识别</div>
                      <div className="text-[10px] text-gray-400 mt-0.5">精准定位故障源</div>
                  </div>
              </div>
          </div>

          <div className="p-6 pb-12 bg-white border-t border-gray-100 z-20">
              <button 
                onClick={() => setStep('camera')}
                className="w-full h-14 bg-[#111] text-white rounded-xl font-bold text-[15px] flex items-center justify-center gap-3 shadow-lg active:scale-[0.98] transition-all"
              >
                  <ScanLine size={18} /> 启动诊断扫描
              </button>
          </div>
      </div>
  );

  // --- 2. Camera Screen: Clean HUD ---
  const renderCameraScreen = () => (
      <div className="flex-1 bg-black relative flex flex-col">
          <div 
            className="absolute inset-0 bg-cover bg-center opacity-90"
            style={{backgroundImage: 'url(https://images.unsplash.com/photo-1580273916550-e323be2eb5fa?q=80&w=1200&auto=format&fit=crop)'}}
          />
          
          {/* HUD UI */}
          <div className="absolute inset-0 pointer-events-none">
              {/* Top Info Bar */}
              <div className="absolute top-[60px] left-0 right-0 flex justify-center">
                  <div className="bg-black/60 backdrop-blur-md px-4 py-1.5 rounded-full border border-white/10 flex items-center gap-2">
                      <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
                      <span className="text-[12px] text-white/90 font-mono tracking-wide">SYSTEM READY</span>
                  </div>
              </div>

              {/* Viewfinder */}
              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[70%] aspect-square">
                  <div className="absolute top-0 left-0 w-6 h-6 border-t-2 border-l-2 border-white/80" />
                  <div className="absolute top-0 right-0 w-6 h-6 border-t-2 border-r-2 border-white/80" />
                  <div className="absolute bottom-0 left-0 w-6 h-6 border-b-2 border-l-2 border-white/80" />
                  <div className="absolute bottom-0 right-0 w-6 h-6 border-b-2 border-r-2 border-white/80" />
                  <div className="absolute inset-0 border border-white/10" />
                  
                  {/* Scanning Crosshair */}
                  <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
                      <PlusIcon className="text-white/50" size={24} />
                  </div>
              </div>

              <div className="absolute bottom-[180px] left-0 right-0 text-center">
                  <p className="text-white/80 text-[13px] font-medium drop-shadow-md">请将故障区域或仪表盘置于框内</p>
              </div>
          </div>

          {/* Controls */}
          <div className="absolute bottom-0 left-0 right-0 h-[160px] bg-gradient-to-t from-black via-black/80 to-transparent flex justify-around items-center px-10 pb-8 z-20">
              <button className="w-12 h-12 bg-white/10 backdrop-blur-md rounded-full flex items-center justify-center text-white active:bg-white/20 transition-colors">
                  <ImageIcon size={22} />
              </button>
              <button 
                onClick={handleCapture}
                className="w-20 h-20 bg-transparent border-[4px] border-white rounded-full flex items-center justify-center active:scale-95 transition-transform"
              >
                  <div className="w-16 h-16 bg-white rounded-full" />
              </button>
              <button onClick={onBack} className="w-12 h-12 bg-white/10 backdrop-blur-md rounded-full flex items-center justify-center text-white active:bg-white/20 transition-colors">
                  <X size={24} />
              </button>
          </div>
      </div>
  );

  // --- 3. Analysis Screen: Dark Tech (Simplified) ---
  const renderAnalyzingScreen = () => (
      <div className="flex-1 bg-[#0F1115] flex flex-col items-center justify-center relative overflow-hidden">
          <div className="relative z-10 flex flex-col items-center w-full px-10">
              <div className="w-16 h-16 mb-8 relative flex items-center justify-center">
                  <div className="absolute inset-0 border-2 border-blue-500/20 rounded-full animate-ping" style={{animationDuration: '3s'}} />
                  <Loader2 size={32} className="text-blue-500 animate-spin" strokeWidth={1.5} />
              </div>
              
              <h3 className="text-white/90 text-[16px] font-medium mb-6 tracking-widest">智能诊断中</h3>
              
              <div className="w-[160px] bg-white/5 rounded-full h-0.5 overflow-hidden">
                  <div className="h-full bg-blue-500/80 w-1/3 animate-[shimmer_1s_infinite]" />
              </div>
          </div>
      </div>
  );

  // --- 4. Result Screen: Trustworthy Report ---
  const renderResultScreen = () => (
      <div className="flex-1 bg-[#F5F7FA] flex flex-col relative overflow-hidden">
          <div className="flex-1 overflow-y-auto no-scrollbar pb-[100px]">
              {/* Evidence Section */}
              <div className="relative h-[260px] bg-black">
                  <img src={capturedImage || ''} className="w-full h-full object-cover opacity-70" />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent" />
                  
                  {/* Info Overlay on Image */}
                  <div className="absolute bottom-10 left-6 text-white z-10">
                      <div className="text-[12px] opacity-70 uppercase tracking-wider mb-1 font-bold">Error Code</div>
                      <div className="text-[42px] font-oswald font-bold leading-none mb-1 text-white">{MOCK_RESULT.code}</div>
                      <div className="text-[15px] font-medium opacity-90">{MOCK_RESULT.system}</div>
                  </div>

                  <div className="absolute top-[54px] right-5 bg-black/40 backdrop-blur-md px-3 py-1 rounded-full text-[10px] text-white/80 font-mono border border-white/10">
                      {MOCK_RESULT.timestamp}
                  </div>
              </div>

              {/* Main Content Sheet - Very small radius as requested */}
              <div className="-mt-6 relative z-10 bg-white rounded-t-[10px] shadow-[0_-4px_30px_rgba(0,0,0,0.1)] min-h-[500px]">
                  {/* Status Bar */}
                  <div className="flex items-center justify-between px-6 py-5 border-b border-gray-100">
                      <div className={`flex items-center gap-2 px-3 py-1 rounded-lg ${statusConfig.lightBg}`}>
                          <StatusIcon size={16} className={statusConfig.color} />
                          <span className={`text-[13px] font-bold ${statusConfig.color}`}>{statusConfig.label}</span>
                      </div>
                      <div className="flex items-center gap-2">
                          <span className="text-[11px] text-gray-400 font-medium">AI 诊断置信度</span>
                          <span className="text-[16px] font-oswald font-bold text-[#111]">{MOCK_RESULT.confidence}</span>
                      </div>
                  </div>
                  
                  {/* Analysis Text */}
                  <div className="px-6 py-8">
                      <div className="mb-8">
                          <h4 className="text-[15px] font-bold text-[#111] mb-4 flex items-center gap-2">
                              <div className="w-1 h-4 bg-[#111] rounded-full" />
                              技术分析
                          </h4>
                          <p className="text-[14px] text-[#333] leading-7 text-justify font-medium">
                              {MOCK_RESULT.technicalAnalysis}
                          </p>
                      </div>

                      <div className="mb-4">
                          <h4 className="text-[15px] font-bold text-[#111] mb-4 flex items-center gap-2">
                              <div className="w-1 h-4 bg-[#111] rounded-full" />
                              驾驶建议
                          </h4>
                          <div className="bg-[#F9FAFB] p-5 rounded-[4px] border-l-2 border-[#111]">
                              <p className="text-[13px] text-[#555] leading-relaxed text-justify">
                                  {MOCK_RESULT.driverAdvice}
                              </p>
                          </div>
                      </div>
                  </div>

                  {/* Actions List - Full width, no card corners */}
                  <div>
                      <div className="px-6 py-3 bg-[#FAFAFA] text-[11px] font-bold text-gray-400 uppercase tracking-widest border-y border-gray-100">
                          建议操作
                      </div>
                      
                      {onNavigateToBooking && (
                          <div 
                            onClick={onNavigateToBooking}
                            className="flex items-center justify-between px-6 py-5 border-b border-gray-50 active:bg-gray-50 transition-colors cursor-pointer group"
                          >
                              <div className="flex items-center gap-4">
                                  <div className="w-10 h-10 bg-[#111] text-white rounded-[8px] flex items-center justify-center shadow-md shadow-black/10 group-active:scale-95 transition-transform">
                                      <Wrench size={20} />
                                  </div>
                                  <div>
                                      <div className="text-[15px] font-bold text-[#111]">预约进店检修</div>
                                      <div className="text-[12px] text-gray-500 mt-0.5">距离最近网点 2.3km</div>
                                  </div>
                              </div>
                              <ChevronRight size={18} className="text-gray-300" />
                          </div>
                      )}
                      
                      <div className="flex items-center justify-between px-6 py-5 active:bg-gray-50 transition-colors cursor-pointer group">
                          <div className="flex items-center gap-4">
                              <div className="w-10 h-10 bg-white border border-gray-200 text-[#111] rounded-[8px] flex items-center justify-center group-active:scale-95 transition-transform">
                                  <Phone size={20} />
                              </div>
                              <div>
                                  <div className="text-[15px] font-bold text-[#111]">联系技术专家</div>
                                  <div className="text-[12px] text-gray-500 mt-0.5">在线解答疑问</div>
                              </div>
                          </div>
                          <ChevronRight size={18} className="text-gray-300" />
                      </div>
                  </div>
              </div>
          </div>

          {/* Fixed Bottom Bar - Rectangular buttons */}
          <div className="absolute bottom-0 left-0 right-0 p-4 bg-white border-t border-gray-100 pb-[34px] z-30 shadow-[0_-4px_20px_rgba(0,0,0,0.02)]">
              {MOCK_RESULT.severity === 'danger' ? (
                  <button 
                    onClick={onNavigateToRescue}
                    className="w-full h-12 bg-[#D93025] text-white rounded-[4px] font-bold flex items-center justify-center gap-2 active:scale-[0.99] transition-transform shadow-lg shadow-red-100"
                  >
                      <AlertTriangle size={18} /> 呼叫道路救援
                  </button>
              ) : (
                  <button 
                    onClick={onBack}
                    className="w-full h-12 bg-[#111] text-white rounded-[4px] font-bold flex items-center justify-center gap-2 active:scale-[0.99] transition-transform shadow-lg shadow-black/10"
                  >
                      完成诊断
                  </button>
              )}
          </div>
      </div>
  );

  // Helper Icon
  const PlusIcon = ({ size, className }: any) => (
      <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1" className={className}>
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
      </svg>
  );

  return (
    <div className="absolute inset-0 z-[200] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300 font-sans">
      {/* Dynamic Header - Transparent & Subtle */}
      {step !== 'camera' && step !== 'analyzing' && (
          <div className="pt-[54px] px-5 pb-3 flex items-center justify-between z-20 bg-transparent absolute top-0 left-0 right-0 pointer-events-none">
            <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center bg-white/10 backdrop-blur-md shadow-sm active:scale-90 transition-transform pointer-events-auto border border-white/20 text-white">
                <ArrowLeft size={24} />
            </button>
            <div className="w-10" />
          </div>
      )}

      {/* Main Content Switcher */}
      {step === 'start' && renderStartScreen()}
      {step === 'camera' && renderCameraScreen()}
      {step === 'analyzing' && renderAnalyzingScreen()}
      {step === 'result' && renderResultScreen()}
      
      <style>{`
        @keyframes scan-short {
            0% { top: 38%; opacity: 0.2; }
            50% { opacity: 1; }
            100% { top: 58%; opacity: 0.2; }
        }
      `}</style>
    </div>
  );
};

export default FaultReportingView;
