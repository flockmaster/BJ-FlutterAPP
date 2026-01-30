
import React, { useState, useMemo } from 'react';
import { 
  ArrowLeft, 
  Plus, 
  X, 
  Check, 
  AlertCircle, 
  EyeOff, 
  Eye,
  ChevronDown
} from 'lucide-react';
import { CAR_DATA } from '../data';

interface CarCompareViewProps {
  initialModelId: string;
  onBack: () => void;
}

// --- Mock Specification Data ---
// In a real app, this would come from an API or a centralized data file.
const SPEC_DATA: Record<string, any> = {
  BJ30: {
    price: '10.99-12.99万',
    engine: '1.5T 188马力 L4',
    transmission: '7挡湿式双离合',
    structure: '承载式 SUV',
    size: '4730*1910*1790',
    wheelbase: '2820',
    ground_clearance: '215mm',
    drive_mode: '前置前驱/四驱',
    angles: '25° / 30°',
    diff_lock: '-',
    screen: '10.25+14.6英寸',
    seat: '仿皮',
    adas: 'L2级辅助驾驶',
    speaker: '8扬声器'
  },
  BJ40: {
    price: '15.98-26.99万',
    engine: '2.0T 245马力 L4',
    transmission: '8挡手自一体',
    structure: '非承载式 SUV',
    size: '4790*1940*1929',
    wheelbase: '2745',
    ground_clearance: '220mm',
    drive_mode: '分时四驱',
    angles: '37° / 31°',
    diff_lock: '前/后桥差速锁',
    screen: '10.25+12.8英寸',
    seat: '真皮/仿皮',
    adas: 'L2级辅助驾驶',
    speaker: '12扬声器(燕飞利仕)'
  },
  BJ60: {
    price: '23.98-28.58万',
    engine: '2.0T 267马力 L4 + 48V',
    transmission: '8挡手自一体',
    structure: '非承载式 SUV',
    size: '5040*1955*1925',
    wheelbase: '2820',
    ground_clearance: '215mm',
    drive_mode: '分时四驱',
    angles: '30° / 24°',
    diff_lock: '前/后桥差速锁',
    screen: '10.25+12.8英寸',
    seat: '真皮',
    adas: 'L2.5级辅助驾驶',
    speaker: '12扬声器(哈曼卡顿)'
  },
  BJ80: {
    price: '29.80-39.80万',
    engine: '3.0T 280马力 V6',
    transmission: '8挡手自一体',
    structure: '非承载式 SUV',
    size: '4765*1955*1985',
    wheelbase: '2800',
    ground_clearance: '215mm',
    drive_mode: '分时四驱',
    angles: '39° / 33°',
    diff_lock: '后桥差速锁',
    screen: '10.25英寸',
    seat: 'Nappa真皮',
    adas: '-',
    speaker: '8扬声器'
  },
  WARRIOR: {
    price: '暂无报价',
    engine: '3.0T V6 / 2.4T 柴油',
    transmission: '9挡手自一体',
    structure: '非承载式 皮卡',
    size: '5400*1990*1960',
    wheelbase: '3200',
    ground_clearance: '235mm',
    drive_mode: '全时四驱',
    angles: '35° / 28°',
    diff_lock: '前/中/后三把锁',
    screen: '12.8+15.6英寸',
    seat: '真皮/翻毛皮',
    adas: 'L2+级辅助驾驶',
    speaker: '18扬声器'
  }
};

const CATEGORIES = [
  {
    title: '基本参数',
    items: [
      { key: 'price', label: '参考价格' },
      { key: 'structure', label: '车身结构' },
      { key: 'engine', label: '发动机' },
      { key: 'transmission', label: '变速箱' },
    ]
  },
  {
    title: '车身尺寸',
    items: [
      { key: 'size', label: '长*宽*高(mm)' },
      { key: 'wheelbase', label: '轴距(mm)' },
      { key: 'ground_clearance', label: '最小离地间隙' },
    ]
  },
  {
    title: '越野性能',
    items: [
      { key: 'drive_mode', label: '驱动方式' },
      { key: 'angles', label: '接近/离去角' },
      { key: 'diff_lock', label: '差速锁' },
    ]
  },
  {
    title: '智能配置',
    items: [
      { key: 'screen', label: '屏幕尺寸' },
      { key: 'adas', label: '辅助驾驶' },
      { key: 'speaker', label: '扬声器系统' },
      { key: 'seat', label: '座椅材质' },
    ]
  }
];

const AVAILABLE_MODELS = Object.keys(CAR_DATA).filter(k => k !== 'WARRIOR'); // Filter out preview model if needed, or keep it

const CarCompareView: React.FC<CarCompareViewProps> = ({ initialModelId, onBack }) => {
  const [selectedModels, setSelectedModels] = useState<string[]>([initialModelId]);
  const [hideSame, setHideSame] = useState(false);
  const [showAddModal, setShowAddModal] = useState(false);

  const handleAddModel = (modelId: string) => {
    if (selectedModels.includes(modelId)) return;
    if (selectedModels.length >= 2) {
      // Replace the second one or show alert? For simplicity, just append if < 2, else replace second
      if (selectedModels.length === 1) {
          setSelectedModels([...selectedModels, modelId]);
      } else {
          // Replace the last one
          setSelectedModels([selectedModels[0], modelId]);
      }
    } else {
        setSelectedModels([...selectedModels, modelId]);
    }
    setShowAddModal(false);
  };

  const handleRemoveModel = (modelId: string) => {
    if (selectedModels.length <= 1) return; // Prevent removing the last one
    setSelectedModels(selectedModels.filter(id => id !== modelId));
  };

  // Helper to check if row values are different
  const isDifferent = (key: string) => {
    if (selectedModels.length < 2) return true;
    const val1 = SPEC_DATA[selectedModels[0]]?.[key];
    const val2 = SPEC_DATA[selectedModels[1]]?.[key];
    return val1 !== val2;
  };

  return (
    <div className="absolute inset-0 z-[150] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100 shrink-0 z-20">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">车型对比</div>
        <button 
            onClick={() => setHideSame(!hideSame)}
            className={`flex items-center gap-1.5 text-[12px] font-medium px-3 py-1.5 rounded-full transition-colors ${hideSame ? 'bg-[#111] text-white' : 'bg-gray-100 text-gray-600'}`}
        >
            {hideSame ? <EyeOff size={14} /> : <Eye size={14} />}
            {hideSame ? '显示全部' : '隐藏相同'}
        </button>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-y-auto no-scrollbar relative">
          
          {/* Sticky Header Row (Car Images) */}
          <div className="sticky top-0 bg-white/95 backdrop-blur-md z-10 border-b border-gray-100 shadow-sm">
              <div className="flex">
                  <div className="w-[100px] shrink-0 p-4 flex items-center justify-center text-[12px] text-gray-400 font-bold border-r border-gray-50">
                      车型信息
                  </div>
                  {/* Columns */}
                  <div className="flex-1 flex">
                      {[0, 1].map(index => {
                          const modelId = selectedModels[index];
                          const car = modelId ? CAR_DATA[modelId] : null;
                          
                          return (
                              <div key={index} className="flex-1 min-w-0 p-3 flex flex-col items-center relative border-r border-transparent last:border-0">
                                  {car ? (
                                      <>
                                          <div className="w-full h-[60px] mb-2 relative">
                                              <img src={car.backgroundImage} className="w-full h-full object-contain" />
                                              {/* Close Button */}
                                              {selectedModels.length > 1 && (
                                                  <button 
                                                    onClick={() => handleRemoveModel(modelId!)}
                                                    className="absolute -top-1 -right-1 w-5 h-5 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 hover:bg-red-50 hover:text-red-500"
                                                  >
                                                      <X size={12} />
                                                  </button>
                                              )}
                                          </div>
                                          <div className="text-[13px] font-bold text-[#111] text-center leading-tight mb-1">{car.name}</div>
                                          <div className="text-[12px] font-oswald text-[#FF6B00] font-bold">¥{car.price}</div>
                                      </>
                                  ) : (
                                      <button 
                                        onClick={() => setShowAddModal(true)}
                                        className="w-full h-full flex flex-col items-center justify-center gap-2 text-gray-400 hover:text-[#111] active:scale-95 transition-all"
                                      >
                                          <div className="w-10 h-10 rounded-full border border-dashed border-gray-300 flex items-center justify-center">
                                              <Plus size={20} />
                                          </div>
                                          <span className="text-[12px]">添加车型</span>
                                      </button>
                                  )}
                              </div>
                          );
                      })}
                  </div>
              </div>
          </div>

          {/* Specs List */}
          <div className="pb-10">
              {CATEGORIES.map((cat, catIdx) => (
                  <div key={catIdx}>
                      <div className="bg-gray-50 px-5 py-2 text-[12px] font-bold text-gray-500 sticky top-[110px] z-0">
                          {cat.title}
                      </div>
                      <div>
                          {cat.items.map((item, itemIdx) => {
                              const showRow = !hideSame || isDifferent(item.key);
                              if (!showRow) return null;

                              return (
                                  <div key={itemIdx} className={`flex border-b border-gray-50 last:border-0 ${!isDifferent(item.key) && hideSame ? 'hidden' : ''}`}>
                                      <div className="w-[100px] shrink-0 p-4 text-[12px] text-gray-500 flex items-center border-r border-gray-50 bg-white">
                                          {item.label}
                                      </div>
                                      <div className="flex-1 flex bg-white">
                                          {[0, 1].map(index => {
                                              const modelId = selectedModels[index];
                                              const value = modelId ? (SPEC_DATA[modelId]?.[item.key] || '-') : '-';
                                              const isDiff = isDifferent(item.key) && selectedModels.length === 2 && modelId;
                                              
                                              return (
                                                  <div key={index} className={`flex-1 p-4 text-[13px] text-[#111] flex items-center justify-center text-center ${isDiff ? 'font-bold bg-[#FF6B00]/5' : ''}`}>
                                                      {value}
                                                  </div>
                                              );
                                          })}
                                      </div>
                                  </div>
                              );
                          })}
                      </div>
                  </div>
              ))}
          </div>
      </div>

      {/* Add Model Modal */}
      {showAddModal && (
          <div className="absolute inset-0 z-50 bg-black/60 backdrop-blur-sm flex flex-col justify-end animate-in fade-in duration-200">
              <div className="bg-white rounded-t-[24px] overflow-hidden flex flex-col max-h-[70%] animate-in slide-in-from-bottom duration-300">
                  <div className="p-4 border-b border-gray-100 flex justify-between items-center">
                      <div className="text-[16px] font-bold text-[#111]">选择对比车型</div>
                      <button onClick={() => setShowAddModal(false)} className="p-1 bg-gray-100 rounded-full">
                          <X size={18} className="text-gray-500" />
                      </button>
                  </div>
                  <div className="flex-1 overflow-y-auto p-4 grid grid-cols-2 gap-3">
                      {AVAILABLE_MODELS.map(key => {
                          const car = CAR_DATA[key];
                          const isSelected = selectedModels.includes(key);
                          return (
                              <button 
                                key={key}
                                onClick={() => handleAddModel(key)}
                                disabled={isSelected}
                                className={`p-3 rounded-xl border flex flex-col items-center gap-2 transition-all ${
                                    isSelected 
                                      ? 'border-gray-100 bg-gray-50 opacity-50 cursor-not-allowed' 
                                      : 'border-gray-100 bg-white hover:border-[#111] active:scale-95 shadow-sm'
                                }`}
                              >
                                  <img src={car.backgroundImage} className="w-full h-[80px] object-contain" />
                                  <div className="text-[14px] font-bold text-[#111]">{car.name}</div>
                                  <div className="text-[12px] text-[#FF6B00] font-oswald">¥{car.price}</div>
                              </button>
                          );
                      })}
                  </div>
              </div>
          </div>
      )}
    </div>
  );
};

export default CarCompareView;
