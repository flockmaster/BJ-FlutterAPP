import React, { useState, useRef, useEffect } from 'react';
/* Added ShieldCheck to the imports below */
import { 
  X, 
  Compass, 
  Upload,
  RotateCw,
  Box,
  Check,
  Sun,
  CloudSun,
  Moon,
  Info,
  Maximize2,
  ChevronRight,
  Loader2,
  ShieldCheck,
  AlertTriangle
} from 'lucide-react';

interface VRExperienceViewProps {
  image: string; 
  onClose: () => void;
  carName: string;
}

const CAR_COLORS = [
    { name: '熔岩橙', hex: '#FF6B00', metal: 0.8, rough: 0.2 },
    { name: '极夜黑', hex: '#1A1A1A', metal: 0.9, rough: 0.1 },
    { name: '雪域白', hex: '#FFFFFF', metal: 0.5, rough: 0.3 },
    { name: '太空银', hex: '#A5A5A5', metal: 1.0, rough: 0.1 },
];

const ENVIRONMENTS = [
    { id: 'neutral', name: '影棚', icon: Box },
    { id: 'park', name: '户外', icon: CloudSun },
    { id: 'sunset', name: '黄昏', icon: Sun },
];

const VRExperienceView: React.FC<VRExperienceViewProps> = ({ image, onClose, carName }) => {
  const [modelUrl, setModelUrl] = useState<string | null>(null);
  const [isAutoRotate, setIsAutoRotate] = useState(true);
  const [selectedColor, setSelectedColor] = useState(CAR_COLORS[0]);
  const [selectedEnv, setSelectedEnv] = useState(ENVIRONMENTS[0]);
  const [isLoading, setIsLoading] = useState(false);
  const [showHotspots, setShowHotspots] = useState(true);
  
  const fileInputRef = useRef<HTMLInputElement>(null);
  const modelViewerRef = useRef<any>(null);

  // Cast custom element to any to avoid JSX.IntrinsicElements errors
  const ModelViewer = 'model-viewer' as any;

  const applyMaterialSettings = () => {
    const mv = modelViewerRef.current;
    if (!mv || !mv.model) return;

    const r = parseInt(selectedColor.hex.slice(1, 3), 16) / 255;
    const g = parseInt(selectedColor.hex.slice(3, 5), 16) / 255;
    const b = parseInt(selectedColor.hex.slice(5, 7), 16) / 255;
    const rgba = [r, g, b, 1.0];

    mv.model.materials.forEach((mat: any) => {
      const name = mat.name.toLowerCase();
      // 匹配车漆材质
      if (name.includes('paint') || name.includes('body') || name.includes('car_color')) {
        mat.pbrMetallicRoughness.setBaseColorFactor(rgba);
        mat.pbrMetallicRoughness.setMetallicFactor(selectedColor.metal);
        mat.pbrMetallicRoughness.setRoughnessFactor(selectedColor.rough);
      }
    });
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file && (file.name.endsWith('.glb') || file.name.endsWith('.gltf'))) {
      setIsLoading(true);
      const url = URL.createObjectURL(file);
      setModelUrl(url);
    }
  };

  // 修复 Loading 不消失的 Bug：使用原生事件监听器
  useEffect(() => {
    const viewer = modelViewerRef.current;
    let safetyTimer: any;

    if (modelUrl && viewer) {
        // 1. 设置安全超时（10秒后强制关闭Loading）
        safetyTimer = setTimeout(() => {
            if (isLoading) {
                console.warn("Model load timed out or event missed");
                setIsLoading(false);
            }
        }, 10000);

        // 2. 定义加载成功处理函数
        const handleLoad = () => {
            console.log("Model loaded successfully");
            setIsLoading(false);
            applyMaterialSettings();
            clearTimeout(safetyTimer);
        };

        // 3. 定义加载失败处理函数
        const handleError = (error: any) => {
            console.error("Model load error:", error);
            setIsLoading(false);
            alert("模型文件解析失败，请检查文件格式是否为标准 .glb/.gltf");
            clearTimeout(safetyTimer);
        };

        // 4. 绑定原生事件
        viewer.addEventListener('load', handleLoad);
        viewer.addEventListener('error', handleError);

        // 5. 清理函数
        return () => {
            viewer.removeEventListener('load', handleLoad);
            viewer.removeEventListener('error', handleError);
            clearTimeout(safetyTimer);
        };
    }
  }, [modelUrl]); // 仅当模型URL变化时重新绑定

  // 颜色/环境变化时的实时应用
  useEffect(() => {
    if (modelUrl && !isLoading) {
      applyMaterialSettings();
    }
  }, [selectedColor, selectedEnv, isLoading]);

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] overflow-hidden animate-in fade-in duration-500">
      
      {/* 3D Canvas Layer */}
      <div className="h-full relative w-full bg-[#F5F7FA]">
          {modelUrl ? (
              <ModelViewer
                ref={modelViewerRef}
                src={modelUrl}
                alt="3D Car Model"
                auto-rotate={isAutoRotate ? '' : null}
                camera-controls
                shadow-intensity="2"
                environment-image={selectedEnv.id}
                exposure="1"
                interaction-prompt="none"
                style={{ width: '100%', height: '100%' }}
                // 注意：这里移除了 onLoad 属性，改用 useEffect 里的 addEventListener 来确保事件被捕获
              >
                  {/* Interactive Hotspots Simulation */}
                  {showHotspots && (
                      <>
                        <div slot="hotspot-wheel" data-position="1.5 0.4 1.2" className="w-6 h-6 bg-white/40 backdrop-blur-md rounded-full border-2 border-white flex items-center justify-center animate-pulse cursor-pointer">
                            <div className="w-2 h-2 bg-white rounded-full shadow-lg" />
                        </div>
                        <div slot="hotspot-headlight" data-position="0.8 0.7 2.2" className="w-6 h-6 bg-white/40 backdrop-blur-md rounded-full border-2 border-white flex items-center justify-center animate-pulse cursor-pointer">
                            <div className="w-2 h-2 bg-white rounded-full shadow-lg" />
                        </div>
                      </>
                  )}
              </ModelViewer>
          ) : (
              <div className="h-full flex flex-col items-center justify-center p-10 text-center">
                  <div className="w-24 h-24 bg-white rounded-[32px] flex items-center justify-center mb-8 shadow-[0_20px_50px_rgba(0,0,0,0.05)] border border-white animate-in zoom-in duration-700">
                      <Box size={40} className="text-[#FF6B00]" />
                  </div>
                  <h3 className="text-[20px] font-bold text-[#111] mb-2">360° 沉浸展厅</h3>
                  <p className="text-[13px] text-gray-400 mb-10 max-w-[240px] leading-relaxed">请选择本地车型的 .glb 格式 3D 模型文件以开启数字孪生体验</p>
                  <button 
                    onClick={() => fileInputRef.current?.click()}
                    className="flex items-center gap-3 bg-[#111] text-white px-10 py-4 rounded-full font-bold shadow-xl active:scale-95 transition-all"
                  >
                      <Upload size={20} /> 选择模型文件
                  </button>
                  <div className="mt-6 flex items-center gap-2 text-[11px] text-gray-300 font-bold uppercase tracking-widest">
                      <ShieldCheck size={12} /> Encrypted Session
                  </div>
              </div>
          )}

          {/* Loading Overlay */}
          {isLoading && (
              <div className="absolute inset-0 bg-[#F5F7FA]/80 backdrop-blur-md z-50 flex flex-col items-center justify-center animate-in fade-in duration-200">
                  <div className="w-16 h-16 border-4 border-gray-100 border-t-[#FF6B00] rounded-full animate-spin mb-4" />
                  <div className="text-[14px] font-bold text-[#111]">正在渲染数字座驾...</div>
                  <div className="text-[12px] text-gray-400 mt-2">解析物理材质与光影</div>
              </div>
          )}
      </div>

      <input type="file" ref={fileInputRef} onChange={handleFileChange} accept=".glb,.gltf" className="hidden" />

      {/* Interface Overlay */}
      <div className="absolute inset-0 pointer-events-none flex flex-col justify-between p-5 pb-[44px]">
          
          {/* Top Bar */}
          <div className="flex justify-between items-start pt-[44px]">
               <div className="pointer-events-auto">
                   <div className="bg-white/80 backdrop-blur-md rounded-2xl px-4 py-2 text-[#111] text-[11px] font-bold border border-white/50 flex items-center gap-2 shadow-sm">
                       <div className={`w-2 h-2 rounded-full ${modelUrl ? 'bg-green-500 animate-pulse' : 'bg-gray-300'}`} />
                       {modelUrl ? '物理光影渲染已开启' : '等待文件输入'}
                   </div>
                   {modelUrl && (
                       <div className="mt-4">
                           <h2 className="text-[#111] text-3xl font-bold tracking-tight">{carName}</h2>
                           <div className="text-[12px] text-gray-400 font-medium uppercase tracking-widest mt-1">Twin-Digital Edition</div>
                       </div>
                   )}
               </div>
               <div className="flex flex-col gap-3 pointer-events-auto">
                   <button 
                     onClick={onClose}
                     className="w-11 h-11 rounded-full bg-white/90 backdrop-blur-md flex items-center justify-center text-[#111] shadow-lg border border-white active:scale-90 transition-transform"
                   >
                       <X size={24} />
                   </button>
                   {modelUrl && (
                       <>
                        <button 
                            onClick={() => setIsAutoRotate(!isAutoRotate)}
                            className={`w-11 h-11 rounded-full flex items-center justify-center shadow-lg border transition-all active:scale-90 ${isAutoRotate ? 'bg-[#111] text-white border-[#111]' : 'bg-white text-gray-400 border-white'}`}
                        >
                            <RotateCw size={20} className={isAutoRotate ? "animate-spin-slow" : ""} />
                        </button>
                        <button 
                            onClick={() => setShowHotspots(!showHotspots)}
                            className={`w-11 h-11 rounded-full flex items-center justify-center shadow-lg border transition-all active:scale-90 ${showHotspots ? 'bg-[#FF6B00] text-white border-[#FF6B00]' : 'bg-white text-gray-400 border-white'}`}
                        >
                            <Info size={20} />
                        </button>
                       </>
                   )}
               </div>
          </div>

          {/* Bottom Control Pod */}
          {modelUrl && !isLoading && (
              <div className="pointer-events-auto flex flex-col items-center gap-6 w-full animate-in slide-in-from-bottom-10 duration-700">
                  
                  {/* Environment Switcher */}
                  <div className="bg-white/40 backdrop-blur-md rounded-full p-1.5 flex gap-1 border border-white/20 shadow-sm">
                      {ENVIRONMENTS.map(env => {
                          const Icon = env.icon;
                          const isSelected = selectedEnv.id === env.id;
                          return (
                              <button 
                                key={env.id}
                                onClick={() => setSelectedEnv(env)}
                                className={`flex items-center gap-2 px-4 py-1.5 rounded-full text-[11px] font-bold transition-all ${
                                    isSelected ? 'bg-white text-[#111] shadow-sm' : 'text-gray-500 hover:text-[#111]'
                                }`}
                              >
                                  <Icon size={14} /> {env.name}
                              </button>
                          );
                      })}
                  </div>

                  {/* Main Interaction Panel */}
                  <div className="w-full max-w-[360px] bg-white/95 backdrop-blur-xl rounded-[40px] px-8 py-6 shadow-[0_25px_60px_rgba(0,0,0,0.12)] border border-white flex flex-col gap-6">
                      
                      {/* Color Palette */}
                      <div className="flex justify-between items-center px-2">
                        {CAR_COLORS.map(color => {
                            const isSelected = selectedColor.hex === color.hex;
                            return (
                                <button
                                    key={color.name}
                                    onClick={() => setSelectedColor(color)}
                                    className="flex flex-col items-center gap-2.5 group"
                                >
                                    <div 
                                        className={`w-11 h-11 rounded-full border-2 transition-all duration-500 relative flex items-center justify-center ${
                                            isSelected 
                                                ? 'border-[#111] scale-110 shadow-lg ring-4 ring-[#111]/5' 
                                                : 'border-gray-100 group-hover:border-gray-200'
                                        }`}
                                        style={{ backgroundColor: color.hex }}
                                    >
                                        {isSelected && (
                                            <div className="animate-in fade-in zoom-in duration-300">
                                                <Check size={20} className={color.hex === '#FFFFFF' ? 'text-black' : 'text-white'} />
                                            </div>
                                        )}
                                    </div>
                                    <span className={`text-[10px] font-bold tracking-tight transition-colors ${isSelected ? 'text-[#111]' : 'text-gray-400'}`}>
                                        {color.name}
                                    </span>
                                </button>
                            );
                        })}
                      </div>
                      
                      <div className="h-px bg-gray-100" />

                      {/* Action Row */}
                      <div className="flex justify-between items-center">
                          <div className="flex flex-col">
                              <div className="text-[10px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">Estimated Price</div>
                              <div className="flex items-baseline gap-1">
                                  <span className="text-[14px] font-bold text-[#FF6B00]">¥</span>
                                  <span className="text-[24px] font-bold font-oswald text-[#111]">159,800</span>
                              </div>
                          </div>
                          
                          <div className="flex gap-3">
                            <button 
                                onClick={() => fileInputRef.current?.click()}
                                className="w-12 h-12 rounded-2xl bg-gray-50 flex items-center justify-center text-[#111] border border-gray-100 active:bg-gray-100 transition-colors"
                            >
                                <Upload size={22} />
                            </button>
                            <button 
                                className="px-8 h-12 rounded-2xl bg-[#111] text-white text-[14px] font-bold shadow-lg shadow-black/10 active:scale-95 transition-all flex items-center gap-2"
                            >
                                立即定购 <ChevronRight size={16} />
                            </button>
                          </div>
                      </div>
                  </div>

                  <div className="text-[10px] text-gray-400 font-bold tracking-[0.4em] uppercase">
                      Precision 3D Engine v3.1
                  </div>
              </div>
          )}
      </div>

      <style>{`
        @keyframes scan {
            0% { top: 0; opacity: 0; }
            20% { opacity: 1; }
            80% { opacity: 1; }
            100% { top: 100%; opacity: 0; }
        }
        @keyframes spin-slow {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        .animate-spin-slow {
            animation: spin-slow 8s linear infinite;
        }
      `}</style>
    </div>
  );
};

export default VRExperienceView;