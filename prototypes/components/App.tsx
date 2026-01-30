
import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import { 
  Search, 
  ShoppingBag, 
  CarFront, 
  Headset, 
  User,
  Info,
  CheckCircle2,
  XCircle,
  MousePointerClick
} from 'lucide-react';
import { CAR_DATA } from './data';
import AIChatModal from './components/AIChatModal';
import NavIcon from './components/NavIcon';
import DiscoveryView from './components/DiscoveryView';
import StoreView from './components/StoreView';
import CarBuyingView from './components/CarBuyingView';
import ServiceView from './components/ServiceView';
import MineView from './components/MineView';
import MyVehiclesView from './components/MyVehiclesView';
import BindVehicleView from './components/BindVehicleView';
import UnifiedScannerView from './components/UnifiedScannerView';
import MyQRCodeView from './components/MyQRCodeView';
import LoginView from './components/LoginView';

type MainTab = 'discovery' | 'store' | 'car-buying' | 'service' | 'mine';
type SubView = 'none' | 'my-vehicles' | 'bind-vehicle' | 'scanner' | 'my-qrcode';

// Key for our local storage "file"
const USER_STORAGE_KEY = 'baic_app_user_data_v1';

// --- External Hint Component using Portal ---
const LoginGuideHints = () => {
    const portalRoot = document.getElementById('hint-root');
    if (!portalRoot) return null;

    return ReactDOM.createPortal(
        <div className="absolute top-1/2 left-1/2 -translate-y-1/2 ml-[230px] w-[300px] animate-in slide-in-from-left-4 fade-in duration-500">
            <div className="bg-white/90 backdrop-blur-md rounded-2xl p-6 shadow-2xl border border-white/40 relative">
                {/* Pointer Arrow */}
                <div className="absolute top-1/2 -left-3 -translate-y-1/2 w-0 h-0 border-t-[10px] border-t-transparent border-b-[10px] border-b-transparent border-r-[12px] border-r-white/90 drop-shadow-sm" />
                
                <h3 className="text-[18px] font-bold text-[#111] mb-4 flex items-center gap-2">
                    <Info size={20} className="text-[#FF6B00]" /> 
                    演示账号说明
                </h3>
                
                <div className="space-y-4">
                    <div className="bg-orange-50 rounded-xl p-3 border border-orange-100">
                        <div className="flex items-center gap-2 mb-1">
                            <MousePointerClick size={16} className="text-[#FF6B00]" />
                            <span className="text-[14px] font-bold text-[#111]">一键登录</span>
                        </div>
                        <p className="text-[12px] text-gray-600 leading-relaxed">
                            模拟<span className="font-bold text-[#FF6B00] mx-1">已认证车主</span>身份。<br/>
                            登录后在“服务”页面可看到已绑定的车辆卡片及相关数据。
                        </p>
                    </div>

                    <div className="bg-gray-50 rounded-xl p-3 border border-gray-200">
                        <div className="flex items-center gap-2 mb-1">
                            <User size={16} className="text-gray-500" />
                            <span className="text-[14px] font-bold text-[#111]">其他方式 (如微信)</span>
                        </div>
                        <p className="text-[12px] text-gray-500 leading-relaxed">
                            模拟<span className="font-bold text-gray-700 mx-1">新注册用户</span>身份。<br/>
                            登录后“服务”页面显示未绑定车辆，引导进行绑车流程。
                        </p>
                    </div>
                </div>
            </div>
        </div>,
        portalRoot
    );
};

const App: React.FC = () => {
  const [activeMainTab, setActiveMainTab] = useState<MainTab>('discovery');
  const [activeSubView, setActiveSubView] = useState<SubView>('none');
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [showLogin, setShowLogin] = useState(false);

  // Initialize state by reading from the "File" (localStorage) immediately
  const [userProfile, setUserProfile] = useState(() => {
      try {
          const savedData = localStorage.getItem(USER_STORAGE_KEY);
          if (savedData) {
              return JSON.parse(savedData);
          }
      } catch (e) {
          console.error("Failed to read user data", e);
      }
      return {
          name: '',
          avatar: '',
          id: '',
          vipLevel: 0,
          isUpdated: false,
          hasVehicle: false 
      };
  });

  const [isLoggedIn, setIsLoggedIn] = useState(() => {
      return !!localStorage.getItem(USER_STORAGE_KEY);
  });

  // Default User Data (Fallback)
  const MOCK_USER = {
      name: '张越野',
      avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
      id: '88293011',
      vipLevel: 5,
      isUpdated: true,
      hasVehicle: true
  };

  const handleLoginSuccess = (profileData?: any) => {
      const dataToSave = profileData || MOCK_USER;
      
      // 1. Write to "File" (Persistence)
      localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(dataToSave));
      
      // 2. Update Memory State
      setIsLoggedIn(true);
      setUserProfile(dataToSave);
      setShowLogin(false);
  };

  const handleLogout = () => {
      // 1. Clear "File"
      localStorage.removeItem(USER_STORAGE_KEY);

      // 2. Update Memory State
      setIsLoggedIn(false);
      setUserProfile({ name: '', avatar: '', id: '', vipLevel: 0, isUpdated: false, hasVehicle: false });
      setActiveSubView('none');
  };

  const handleUpdateProfile = (name: string, avatar: string) => {
      const updatedProfile = {
          ...userProfile,
          name,
          avatar,
          isUpdated: true
      };
      // Update persistent storage as well
      localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(updatedProfile));
      setUserProfile(updatedProfile);
  };

  // Car Buying State
  const [currentModelKey, setCurrentModelKey] = useState<string>('BJ40');
  const currentCar = CAR_DATA[currentModelKey];

  const renderMainContent = () => {
    const animationClass = "animate-in fade-in slide-in-from-bottom-2 duration-300 h-full";

    switch (activeMainTab) {
      case 'discovery':
        return (
            <div key="discovery" className={animationClass}>
                <DiscoveryView 
                    currentUser={userProfile}
                    onUpdateProfile={handleUpdateProfile}
                />
            </div>
        );
      case 'store':
        return <div key="store" className={animationClass}><StoreView /></div>;
      case 'car-buying':
        return (
          <div key="car-buying" className={animationClass}>
             <CarBuyingView 
                currentModelKey={currentModelKey} 
                setCurrentModelKey={setCurrentModelKey}
                onChatOpen={() => setIsChatOpen(true)}
              />
          </div>
        );
      case 'service':
        // Explicitly pass the hasVehicle state read from storage/state
        return <div key="service" className={animationClass}><ServiceView hasVehicle={userProfile.hasVehicle} /></div>;
      case 'mine':
        return (
          <div key="mine" className={animationClass}>
            <MineView 
              isLoggedIn={isLoggedIn}
              userProfile={userProfile}
              onNavigateToLogin={() => setShowLogin(true)}
              onLogout={handleLogout}
              onNavigateToMyVehicles={() => {
                  if(!isLoggedIn) { setShowLogin(true); return; }
                  setActiveSubView('my-vehicles');
              }} 
              onOpenScanner={() => setActiveSubView('scanner')}
              onOpenMyQR={() => {
                  if(!isLoggedIn) { setShowLogin(true); return; }
                  setActiveSubView('my-qrcode');
              }}
            />
          </div>
        );
      default:
        return null;
    }
  };

  return (
    <div className="h-full w-full relative bg-[#F5F7FA] overflow-hidden flex flex-col">
      <div className="flex-1 overflow-hidden relative">
        {renderMainContent()}
      </div>

      <nav className="absolute bottom-0 left-0 right-0 h-[80px] bg-white border-t border-[#eee] z-40 flex justify-around pt-2.5 pb-[20px]">
         <NavIcon 
            icon={Search} 
            label="发现" 
            active={activeMainTab === 'discovery'} 
            onClick={() => setActiveMainTab('discovery')} 
         />
         <NavIcon 
            icon={ShoppingBag} 
            label="商城" 
            active={activeMainTab === 'store'} 
            onClick={() => setActiveMainTab('store')} 
         />
         <NavIcon 
            icon={CarFront} 
            label="购车" 
            active={activeMainTab === 'car-buying'} 
            onClick={() => setActiveMainTab('car-buying')} 
         />
         <NavIcon 
            icon={Headset} 
            label="服务" 
            active={activeMainTab === 'service'} 
            onClick={() => setActiveMainTab('service')} 
         />
         <NavIcon 
            icon={User} 
            label="我的" 
            active={activeMainTab === 'mine'} 
            onClick={() => setActiveMainTab('mine')} 
         />
      </nav>

      {/* Sub Views Overlay */}
      {activeSubView === 'my-vehicles' && (
        <div className="absolute inset-0 z-50 animate-in slide-in-from-right duration-300">
          <MyVehiclesView 
            onBack={() => setActiveSubView('none')} 
            onAddVehicle={() => setActiveSubView('bind-vehicle')}
            hasVehicle={userProfile.hasVehicle}
          />
        </div>
      )}
      {activeSubView === 'bind-vehicle' && (
        <div className="absolute inset-0 z-[60] animate-in slide-in-from-right duration-300">
           <BindVehicleView 
             onBack={() => setActiveSubView('my-vehicles')} 
           />
        </div>
      )}
      {activeSubView === 'scanner' && (
        <div className="absolute inset-0 z-50 animate-in slide-in-from-right duration-300">
            <UnifiedScannerView onBack={() => setActiveSubView('none')} />
        </div>
      )}
      {activeSubView === 'my-qrcode' && (
        <div className="absolute inset-0 z-50 animate-in slide-in-from-right duration-300">
            <MyQRCodeView onBack={() => setActiveSubView('none')} />
        </div>
      )}

      {/* Login Overlay */}
      {showLogin && (
          <LoginView 
            onLoginSuccess={handleLoginSuccess}
            onClose={() => setShowLogin(false)}
          />
      )}

      {/* External Hints Overlay (Only visible when Login Modal is open) */}
      {showLogin && <LoginGuideHints />}

      <AIChatModal 
        isOpen={isChatOpen} 
        onClose={() => setIsChatOpen(false)} 
        currentCar={currentCar}
      />
    </div>
  );
};

export default App;
