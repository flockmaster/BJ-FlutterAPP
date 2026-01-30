
import React, { useState, useEffect } from 'react';
import { 
  Search, 
  ShoppingBag, 
  CarFront, 
  Headset, 
  User
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

const App: React.FC = () => {
  const [activeMainTab, setActiveMainTab] = useState<MainTab>('discovery');
  const [activeSubView, setActiveSubView] = useState<SubView>('none');
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [showLogin, setShowLogin] = useState(false);

  // Global Auth State - Default is Logged OUT
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userProfile, setUserProfile] = useState({
      name: '',
      avatar: '',
      id: '',
      vipLevel: 0,
      isUpdated: false,
      hasVehicle: false
  });

  // Default User Data (Simulating a database fetch after login)
  const MOCK_USER = {
      name: '张越野',
      avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
      id: '88293011',
      vipLevel: 5,
      isUpdated: true,
      hasVehicle: true
  };

  const handleLoginSuccess = (profileData?: any) => {
      setIsLoggedIn(true);
      setUserProfile(profileData || MOCK_USER);
      setShowLogin(false);
  };

  const handleLogout = () => {
      setIsLoggedIn(false);
      setUserProfile({ name: '', avatar: '', id: '', vipLevel: 0, isUpdated: false, hasVehicle: false });
      setActiveSubView('none');
      // Optionally redirect to discovery
      // setActiveMainTab('discovery'); 
  };

  const handleUpdateProfile = (name: string, avatar: string) => {
      setUserProfile(prev => ({
          ...prev,
          name,
          avatar,
          isUpdated: true
      }));
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

      <AIChatModal 
        isOpen={isChatOpen} 
        onClose={() => setIsChatOpen(false)} 
        currentCar={currentCar}
      />
    </div>
  );
};

export default App;
