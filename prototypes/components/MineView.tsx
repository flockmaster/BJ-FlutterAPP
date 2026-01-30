
import React, { useState, useRef, useEffect } from 'react';
import { 
  QrCode, 
  ChevronRight, 
  ShoppingBag, 
  Coins, 
  Ticket, 
  ClipboardList, 
  Headset, 
  HelpCircle, 
  Settings, 
  ShieldCheck, 
  Gift,
  ScanLine,
  CalendarCheck,
  Bell,
  UserCircle
} from 'lucide-react';
import ProfileView from './ProfileView';
import DailyCheckInView from './DailyCheckInView';
import FollowListView from './FollowListView';
import MyPostsView from './MyPostsView';
import MyFavoritesView from './MyFavoritesView';
import OrderListView from './OrderListView';
import PointsHistoryView from './PointsHistoryView';
import MyCouponsView from './MyCouponsView';
import TaskCenterView from './TaskCenterView';
import MessageCenterView from './MessageCenterView';
import HelpCenterView from './HelpCenterView';
import SettingsView from './SettingsView';
import CustomerServiceView from './CustomerServiceView';
import InviteFriendsView from './InviteFriendsView';
import OrderDetailView from './OrderDetailView';
import AddressListView from './AddressListView'; 
import InvoiceListView from './InvoiceListView'; 
import NotificationSettingsView from './NotificationSettingsView'; 
import PrivacySettingsView from './PrivacySettingsView';
import FeedbackView from './FeedbackView';
import AccountBindingView from './AccountBindingView'; 
import Skeleton from './ui/Skeleton';
import { ListCell } from './ui/ListCell';
import { IconButton } from './ui/Button';
import MedalVector from './ui/MedalVector';
import TireTrackBackground from './ui/TireTrackBackground';

interface MineViewProps {
    isLoggedIn: boolean;
    userProfile: any;
    onNavigateToLogin: () => void;
    onLogout: () => void;
    onNavigateToMyVehicles?: () => void;
    onOpenScanner: () => void;
    onOpenMyQR: () => void;
}

const COLOR_BG = 'bg-[#F5F7FA]'; 
const COLOR_SURFACE = 'bg-white';
const COLOR_TEXT_MAIN = 'text-[#111827]';
const COLOR_TEXT_SEC = 'text-[#6B7280]';
const COLOR_PRIMARY = 'text-[#FF6B00]';
const FONT_NUM = 'font-oswald';

type MineSubView = 'none' | 'profile' | 'checkin' | 'following' | 'followers' | 'posts' | 'favorites' | 'orders' | 'order-detail' | 'points' | 'coupons' | 'tasks' | 'messages' | 'help' | 'settings' | 'service' | 'invite' | 'addresses' | 'invoices' | 'notifications' | 'privacy' | 'feedback' | 'account-binding';

const MineView: React.FC<MineViewProps> = ({ 
    isLoggedIn, 
    userProfile, 
    onNavigateToLogin, 
    onLogout,
    onNavigateToMyVehicles, 
    onOpenScanner, 
    onOpenMyQR 
}) => {
  const [isLoading, setIsLoading] = useState(true);
  const [headerOpacity, setHeaderOpacity] = useState(0);
  const [activeSubView, setActiveSubView] = useState<MineSubView>('none');
  const [selectedOrder, setSelectedOrder] = useState<any>(null); 
  const scrollRef = useRef<HTMLDivElement>(null);
  const [msgIndex, setMsgIndex] = useState(0);

  const messages = isLoggedIn ? [
    { text: '您的BJ40预约保养已确认，请准时前往' },
    { text: '双11特惠活动开启，越野配件由低至5折' },
    { text: '恭喜您获得“越野达人”勋章，快去查看' }
  ] : [
    { text: '登录后可查看最新服务通知' },
    { text: '新用户注册立享500积分好礼' }
  ];

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 800);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        const scrollTop = scrollRef.current.scrollTop;
        const opacity = Math.min(scrollTop / 60, 1);
        setHeaderOpacity(opacity);
      }
    };
    const element = scrollRef.current;
    if (element) {
        element.addEventListener('scroll', handleScroll);
        return () => element.removeEventListener('scroll', handleScroll);
    }
  }, [isLoading]);

  useEffect(() => {
    const timer = setInterval(() => {
        setMsgIndex(prev => (prev + 1) % messages.length);
    }, 4000);
    return () => clearInterval(timer);
  }, [messages.length]);

  // Auth Guard Helper
  const navigateTo = (view: MineSubView) => {
      if (!isLoggedIn) {
          onNavigateToLogin();
      } else {
          setActiveSubView(view);
      }
  };

  if (isLoading) {
      return (
          <div className={`h-full w-full ${COLOR_BG} relative overflow-hidden`}>
              <div className="pt-[54px] px-5 pb-3 flex justify-end gap-4">
                  <Skeleton width="40px" height="40px" variant="circle" />
                  <Skeleton width="40px" height="40px" variant="circle" />
              </div>
              <div className="pt-4 px-5 space-y-6">
                  <div className="flex items-center gap-4">
                      <Skeleton width="72px" height="72px" variant="circle" />
                      <div className="space-y-2">
                           <Skeleton width="120px" height="24px" />
                           <Skeleton width="80px" height="16px" />
                      </div>
                  </div>
                  <Skeleton height="120px" className="w-full rounded-3xl" />
                  <Skeleton height="100px" className="w-full rounded-2xl" />
              </div>
          </div>
      );
  }

  return (
    <div className={`h-full w-full ${COLOR_BG} relative animate-in fade-in duration-500`}>
      {/* Sub Views */}
      {activeSubView === 'profile' && <ProfileView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'checkin' && <DailyCheckInView onBack={() => setActiveSubView('none')} onNavigateToPoints={() => setActiveSubView('points')} />}
      {activeSubView === 'following' && <FollowListView type="following" onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'followers' && <FollowListView type="followers" onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'posts' && <MyPostsView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'favorites' && <MyFavoritesView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'orders' && <OrderListView onBack={() => setActiveSubView('none')} onSelectOrder={(o) => { setSelectedOrder(o); setActiveSubView('order-detail'); }} />}
      {activeSubView === 'order-detail' && <OrderDetailView order={selectedOrder} onBack={() => setActiveSubView('orders')} />}
      {activeSubView === 'points' && <PointsHistoryView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'coupons' && <MyCouponsView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'tasks' && <TaskCenterView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'messages' && <MessageCenterView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'help' && <HelpCenterView onBack={() => setActiveSubView('none')} onContactService={() => setActiveSubView('service')} />}
      
      {/* Settings & Sub-settings */}
      {activeSubView === 'settings' && <SettingsView onBack={() => setActiveSubView('none')} onNavigateToAddress={() => setActiveSubView('addresses')} onNavigateToInvoice={() => setActiveSubView('invoices')} onNavigateToNotifications={() => setActiveSubView('notifications')} onNavigateToPrivacy={() => setActiveSubView('privacy')} onNavigateToFeedback={() => setActiveSubView('feedback')} onNavigateToAccountBinding={() => setActiveSubView('account-binding')} onLogout={onLogout} />}
      {activeSubView === 'addresses' && <AddressListView onBack={() => setActiveSubView('settings')} />}
      {activeSubView === 'invoices' && <InvoiceListView onBack={() => setActiveSubView('settings')} />}
      {activeSubView === 'notifications' && <NotificationSettingsView onBack={() => setActiveSubView('settings')} />}
      {activeSubView === 'privacy' && <PrivacySettingsView onBack={() => setActiveSubView('settings')} />}
      {activeSubView === 'feedback' && <FeedbackView onBack={() => setActiveSubView('settings')} />}
      {activeSubView === 'account-binding' && <AccountBindingView onBack={() => setActiveSubView('settings')} />}
      
      {activeSubView === 'service' && <CustomerServiceView onBack={() => setActiveSubView('none')} />}
      {activeSubView === 'invite' && <InviteFriendsView onBack={() => setActiveSubView('none')} />}

      {/* Dynamic Header */}
      <div className="absolute top-0 left-0 right-0 z-40 transition-all duration-300 pointer-events-none">
          <div 
            className="absolute inset-0 transition-opacity duration-300 bg-[#F5F7FA]/95 backdrop-blur-xl border-b border-gray-100/50"
            style={{ opacity: headerOpacity }}
          />
          <div className="pt-[54px] px-5 pb-3 flex justify-end items-center relative z-10 pointer-events-auto gap-4">
             <IconButton icon={ScanLine} onClick={onOpenScanner} variant="blur" className="bg-white/80 border border-white/50" />
             <IconButton icon={QrCode} onClick={onOpenMyQR} variant="blur" className="bg-white/80 border border-white/50" />
          </div>
      </div>

      <div ref={scrollRef} className="h-full overflow-y-auto no-scrollbar pb-[100px]">
         <div className="pt-[110px] px-5">
             {/* User Profile Area */}
             <div className="flex items-center justify-between mb-8">
                {isLoggedIn ? (
                    <div className="flex items-center gap-4 cursor-pointer flex-1 min-w-0" onClick={() => setActiveSubView('profile')}>
                        <div className="relative shrink-0">
                            <img src={userProfile.avatar} className="w-[72px] h-[72px] rounded-full border-[3px] border-white shadow-xl object-cover" />
                            {userProfile.vipLevel > 0 && (
                                <div className="absolute -top-1 -right-1 w-6 h-6 bg-white rounded-full p-0.5 shadow-md border border-gray-100">
                                    <MedalVector id={1} className="w-full h-full" />
                                </div>
                            )}
                        </div>
                        <div className="flex flex-col gap-1 min-w-0">
                            <div className={`text-2xl font-bold ${COLOR_TEXT_MAIN} flex items-center gap-1`}>
                                <span className="truncate max-w-[160px]">{userProfile.name}</span>
                                <ChevronRight size={18} className="text-gray-300 shrink-0" />
                            </div>
                            <div className="flex gap-2">
                                <span className="text-[10px] bg-[#111827] text-[#FFD700] px-2 py-0.5 rounded-md font-bold flex items-center gap-1 shrink-0">
                                    <ShieldCheck size={10} /> 认证车主
                                </span>
                                <span className="text-[10px] bg-white border border-gray-100 text-gray-400 px-2 py-0.5 rounded-md font-bold shrink-0">
                                    LV.{userProfile.vipLevel}
                                </span>
                            </div>
                        </div>
                    </div>
                ) : (
                    <div className="flex items-center gap-4 cursor-pointer flex-1 min-w-0" onClick={onNavigateToLogin}>
                        <div className="w-[72px] h-[72px] rounded-full bg-[#E5E7EB] flex items-center justify-center border-[3px] border-white shadow-inner text-gray-400 shrink-0">
                            <UserCircle size={48} strokeWidth={1.5} />
                        </div>
                        <div className="flex flex-col gap-1">
                            <div className={`text-2xl font-bold ${COLOR_TEXT_MAIN} flex items-center gap-1`}>
                                登录 / 注册 <ChevronRight size={18} className="text-gray-300" />
                            </div>
                            <div className="text-[12px] text-gray-400">
                                登录解锁更多精彩内容
                            </div>
                        </div>
                    </div>
                )}

                <button 
                    onClick={() => isLoggedIn ? setActiveSubView('checkin') : onNavigateToLogin()}
                    className="bg-[#111] text-white px-4 py-2 rounded-xl flex items-center gap-2 active:scale-95 transition-transform shadow-lg shadow-black/10 shrink-0 ml-2"
                >
                    <CalendarCheck size={16} />
                    <span className="text-[13px] font-bold">签到</span>
                </button>
             </div>

             {/* Social Stats - Logic to hide numbers if not logged in */}
             <div className="flex justify-between items-center mb-8 px-2">
                <SocialStatItem label="关注" value={isLoggedIn ? "128" : "-"} onClick={() => navigateTo('following')} />
                <SocialStatItem label="粉丝" value={isLoggedIn ? "3,450" : "-"} onClick={() => navigateTo('followers')} />
                <SocialStatItem label="动态" value={isLoggedIn ? "42" : "-"} onClick={() => navigateTo('posts')} />
                <SocialStatItem label="赞过" value={isLoggedIn ? "156" : "-"} onClick={() => navigateTo('favorites')} />
             </div>

             {/* Notification Ticker */}
             <div onClick={() => navigateTo('messages')} className="bg-white rounded-2xl px-5 py-3.5 shadow-sm border border-gray-100 flex items-center gap-3 active:scale-[0.99] transition-transform mb-4">
                 <div className="w-8 h-8 rounded-full bg-orange-50 flex items-center justify-center text-[#FF6B00]">
                    <Bell size={18} />
                 </div>
                 <div className="flex-1 overflow-hidden h-[20px] relative">
                    <div className="absolute w-full transition-transform duration-500 ease-in-out" style={{ transform: `translateY(-${msgIndex * 20}px)` }}>
                        {messages.map((msg, i) => (
                            <div key={i} className="h-[20px] flex items-center w-full"><span className={`text-[13px] ${COLOR_TEXT_MAIN} truncate font-medium`}>{msg.text}</span></div>
                        ))}
                    </div>
                 </div>
                 <ChevronRight size={16} className="text-gray-300" />
             </div>

             {/* Vehicle Management */}
             <div onClick={onNavigateToMyVehicles} className="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 mb-6 relative overflow-hidden group active:scale-[0.99] transition-transform cursor-pointer">
                <TireTrackBackground />
                <div className="flex justify-between items-center mb-6 relative z-10">
                   <h3 className="text-[17px] font-bold text-[#111]">我的车库</h3>
                   <span className="text-[12px] text-gray-400 font-medium">查看全部 <ChevronRight size={14} className="inline ml-0.5" /></span>
                </div>
                
                {isLoggedIn ? (
                    userProfile.hasVehicle ? (
                        <div className="flex items-center gap-6 relative z-10">
                            <div className="w-[120px] h-[75px] bg-[#F5F7FA] rounded-2xl flex items-center justify-center p-2 overflow-hidden">
                                <img src="https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png" className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" alt="Car" />
                            </div>
                            <div className="flex-1">
                                <div className="text-[16px] font-bold text-[#111] mb-1">北京BJ40 PLUS</div>
                                <div className="flex items-center gap-2">
                                    <span className="text-[11px] text-gray-500 bg-[#F5F7FA] px-2 py-0.5 rounded-md font-oswald">京A·12345</span>
                                    <span className="text-[11px] text-green-500 font-bold flex items-center gap-1 bg-green-50 px-2 py-0.5 rounded-md"><ShieldCheck size={12} /> 在线</span>
                                </div>
                            </div>
                        </div>
                    ) : (
                        <div className="flex flex-col items-center justify-center py-4 relative z-10">
                            <p className="text-[13px] text-gray-400 font-medium mb-3">您尚未绑定车辆，立即绑定开启智能车联</p>
                            <button className="px-6 py-2 rounded-full border border-gray-200 text-[#111] text-[12px] font-bold">立即绑定</button>
                        </div>
                    )
                ) : (
                    <div className="flex flex-col items-center justify-center py-4 relative z-10">
                        <p className="text-[13px] text-gray-400 font-medium mb-3">登录后管理爱车，查看车辆状态</p>
                        <button className="px-6 py-2 rounded-full border border-gray-200 text-[#111] text-[12px] font-bold">立即登录</button>
                    </div>
                )}
             </div>

             {/* Asset Grid */}
             <div className="bg-white rounded-[24px] p-6 shadow-sm border border-gray-50 mb-4 grid grid-cols-4 gap-2">
                <AssetItem icon={ShoppingBag} label="我的订单" onClick={() => navigateTo('orders')} />
                <AssetItem icon={Coins} label="可用积分" onClick={() => navigateTo('points')} sub={isLoggedIn ? "2,450" : "-"} />
                <AssetItem icon={Ticket} label="优惠券" onClick={() => navigateTo('coupons')} sub={isLoggedIn ? "3张" : "-"} />
                <AssetItem icon={ClipboardList} label="任务中心" onClick={() => navigateTo('tasks')} />
             </div>

             {/* Invite Friends */}
             <div onClick={() => navigateTo('invite')} className="relative h-[120px] rounded-[24px] overflow-hidden mb-6 shadow-md active:scale-[0.99] transition-transform group cursor-pointer bg-[#F8F9FA]">
                <img 
                    src="https://youke3.picui.cn/s1/2026/01/07/695dfffc2e905.jpg" 
                    className="absolute inset-0 w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                    alt="Invite Friends"
                />
                <div className="relative z-10 h-full flex flex-col justify-center px-6">
                   <div className="text-white drop-shadow-md">
                      <div className="text-[22px] font-bold mb-1 italic tracking-wider">无兄弟，不越野</div>
                      <div className="text-[12px] text-[#FF6B00] font-bold flex items-center gap-1 bg-white px-3 py-1 rounded-full w-fit shadow-sm mt-1">
                          速速邀请兄弟入伙！ <ChevronRight size={12} />
                      </div>
                   </div>
                </div>
             </div>

             {/* System List */}
             <div className="bg-white rounded-[24px] overflow-hidden shadow-sm border border-gray-50 mb-10">
                <ListCell icon={Headset} label="专属在线客服" onClick={() => navigateTo('service')} />
                <ListCell icon={HelpCircle} label="帮助与反馈" onClick={() => navigateTo('help')} />
                <ListCell icon={Settings} label="设置" isLast onClick={() => setActiveSubView('settings')} />
             </div>
         </div>
      </div>
    </div>
  );
};

const SocialStatItem: React.FC<{ label: string, value: string, onClick: () => void }> = ({ label, value, onClick }) => (
    <div onClick={onClick} className="flex flex-col items-center flex-1 active:scale-95 transition-transform cursor-pointer">
        <span className={`${FONT_NUM} text-[20px] font-bold ${COLOR_TEXT_MAIN}`}>{value}</span>
        <span className="text-[12px] text-gray-400 font-medium">{label}</span>
    </div>
);

const AssetItem: React.FC<{ icon: any, label: string, onClick: () => void, sub?: string }> = ({ icon: Icon, label, onClick, sub }) => (
    <div onClick={onClick} className="flex flex-col items-center gap-2 active:scale-95 transition-transform group">
        <div className="w-12 h-12 bg-[#F5F7FA] rounded-full flex items-center justify-center text-[#111] group-hover:bg-orange-50 group-hover:text-[#FF6B00] transition-colors">
            <Icon size={24} strokeWidth={1.5} />
        </div>
        <div className="flex flex-col items-center">
            <span className="text-[12px] text-[#111] font-bold">{label}</span>
            {sub && <span className="text-[10px] text-[#FF6B00] font-bold font-oswald">{sub}</span>}
        </div>
    </div>
);

export default MineView;
