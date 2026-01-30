import React, { useState, useEffect } from 'react';
import { 
  Search, 
  Plus, 
  ChevronRight, 
  Eye, 
  Heart, 
  Play, 
  Navigation, 
  Timer, 
  Mountain, 
  Shield, 
  MessageSquare,
  ThermometerSun,
  Trophy,
  Share2,
  MoreHorizontal,
  ChevronLeft,
  Hammer,
  Flame,
  UserCheck,
  X,
  Trash2,
  Image as ImageIcon,
  Video,
  PenTool,
  HelpCircle,
  CheckCircle2,
  ShieldCheck,
  ArrowUpDown
} from 'lucide-react';
import { 
    DISCOVERY_DATA, 
    DISCOVERY_MODEL_DATA, 
    DISCOVERY_FOLLOW_DATA, 
    DISCOVERY_OFFICIAL_DATA, 
    DISCOVERY_QA_DATA, 
    DISCOVERY_WILD_DATA,
    DISCOVERY_QA_CATEGORIES,
    DISCOVERY_QA_EXPERTS,
    CAR_DATA
} from '../data';
import { DiscoveryItem } from '../types';
import OfficialNewsListView from './OfficialNewsListView';
import ActivityMoreView from './ActivityMoreView'; 
import EditProfileView from './EditProfileView'; 
import CreatePostView from './CreatePostView'; 

const MODEL_KEYS = Object.keys(CAR_DATA);
const DISCOVERY_COMMUNITY_TABS = ['关注', '推荐', ...MODEL_KEYS];

// --- Merged Design System Constants ---
const COLOR_BG = 'bg-[#F5F7FA]'; // L0
const COLOR_SURFACE = 'bg-white'; // L1
const COLOR_TEXT_MAIN = 'text-[#111827]'; 
const SHADOW_L1 = 'shadow-[0_2px_14px_rgba(0,0,0,0.04)]';
const RADIUS_M = 'rounded-[16px]'; 
const RADIUS_L = 'rounded-[24px]';

const DiscoveryView: React.FC<{ currentUser: any, onUpdateProfile: any }> = ({ currentUser, onUpdateProfile }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [activeTopTab, setActiveTopTab] = useState('推荐'); 
  const [activeSubTab, setActiveSubTab] = useState('推荐'); 
  const [viewingPost, setViewingPost] = useState<DiscoveryItem | null>(null);
  
  const [showNewsList, setShowNewsList] = useState(false);
  const [showActivityList, setShowActivityList] = useState(false); 
  const [showSearch, setShowSearch] = useState(false); 
  const [showPlusMenu, setShowPlusMenu] = useState(false); 
  
  const [showEditProfile, setShowEditProfile] = useState(false);
  const [showCreatePost, setShowCreatePost] = useState(false);
  const [postType, setPostType] = useState<'post' | 'video' | 'question' | 'article'>('post');

  useEffect(() => {
      setTimeout(() => setIsLoading(false), 1200);
  }, []);

  if (isLoading) {
      return (
        <div className={`h-full w-full ${COLOR_BG} flex flex-col relative overflow-hidden`}>
           <div className="pt-[60px] pb-2 px-5 bg-[#F5F7FA]/95 backdrop-blur-xl z-30">
              <div className="flex justify-between items-center">
                  <div className="flex gap-6 overflow-hidden py-2">
                     {[1,2,3,4,5].map(i => <div key={i} className="w-10 h-5 rounded bg-gray-200 animate-shimmer" />)}
                  </div>
              </div>
           </div>
           <div className="flex-1 px-4 pt-4 space-y-5">
              <div className="w-full h-[220px] rounded-[24px] bg-gray-200 animate-shimmer" />
              <div className="flex gap-4 p-4">
                  {[1,2,3].map(i => <div key={i} className="w-[280px] shrink-0 h-[220px] rounded-[24px] bg-gray-200 animate-shimmer" />)}
              </div>
           </div>
        </div>
      );
  }
  
  return (
    <div className={`h-full w-full ${COLOR_BG} flex flex-col relative animate-in fade-in duration-500`}>
       {viewingPost && <PostDetailView post={viewingPost} onClose={() => setViewingPost(null)} />}
       {showSearch && <DiscoverySearchView onClose={() => setShowSearch(false)} />}
       {showPlusMenu && <PlusMenu onClose={() => setShowPlusMenu(false)} onAction={(t: any) => { setPostType(t); setShowCreatePost(true); }} />}

       {/* Mode B: Immersive Header */}
       <div className="sticky top-0 z-30 pt-[60px] pb-0 bg-[#F5F7FA]/95 backdrop-blur-xl transition-all duration-300">
          <div className="flex items-center justify-between px-5 pb-2">
             <div className="flex items-center gap-8 overflow-x-auto no-scrollbar py-1">
                {['推荐', '官方', '改装', '去野'].map(tab => (
                    <button 
                        key={tab}
                        onClick={() => setActiveTopTab(tab)}
                        className={`relative text-[18px] whitespace-nowrap transition-all duration-300 flex flex-col items-center gap-1 ${
                            activeTopTab === tab 
                                ? `${COLOR_TEXT_MAIN} font-bold scale-105` 
                                : 'text-gray-400 font-medium'
                        }`}
                    >
                        {tab}
                        {activeTopTab === tab && <div className="w-4 h-1 bg-[#FF6B00] rounded-full animate-in zoom-in" />}
                    </button>
                ))}
             </div>
             <div className="flex items-center gap-3 shrink-0">
                 <button onClick={() => setShowSearch(true)} className="w-9 h-9 rounded-full bg-white shadow-sm flex items-center justify-center text-[#111827] active:scale-95 transition-transform"><Search size={18} /></button>
                 <button onClick={() => setShowPlusMenu(!showPlusMenu)} className="w-9 h-9 rounded-full bg-[#111] shadow-lg flex items-center justify-center text-white active:scale-95 transition-transform"><Plus size={20} /></button>
             </div>
          </div>
       </div>

       <div className={`flex-1 overflow-y-auto no-scrollbar pb-24 px-4 pt-4`}>
          {activeTopTab === '推荐' && (
              <div className="flex flex-col gap-4">
                  {DISCOVERY_DATA.map((item) => (
                    <SocialPostCard key={item.id} item={item} onClick={() => setViewingPost(item)} />
                  ))}
              </div>
          )}
          {activeTopTab === '官方' && <OfficialView onShowMore={() => setShowNewsList(true)} onShowActivityMore={() => setShowActivityList(true)} />}
       </div>
    </div>
  );
};

const SocialPostCard: React.FC<{ item: DiscoveryItem; onClick: () => void }> = ({ item, onClick }) => {
    const images = item.images || (item.image ? [item.image] : []);
    return (
        <div 
            onClick={onClick} 
            className={`bg-white ${RADIUS_M} p-5 border border-gray-100 ${SHADOW_L1} active:scale-[0.98] transition-all`}
        >
            {item.user && (
                <div className="flex justify-between items-center mb-4">
                    <div className="flex items-center gap-3">
                        <img src={item.user.avatar} className="w-10 h-10 rounded-full border border-gray-100" />
                        <div>
                            <div className="flex items-center gap-2">
                                <div className={`text-[15px] font-bold ${COLOR_TEXT_MAIN}`}>{item.user.name}</div>
                                {item.user.vipLevel && <span className="text-[9px] bg-[#FF6B00] text-white px-1.5 py-0.5 rounded font-bold">V{item.user.vipLevel}</span>}
                            </div>
                            <div className="text-[10px] text-gray-400 mt-0.5 font-bold uppercase tracking-tight">{item.user.time} {item.user.carModel && `· ${item.user.carModel}`}</div>
                        </div>
                    </div>
                    <button className="text-gray-300 p-1"><MoreHorizontal size={20} /></button>
                </div>
            )}
            <div className="mb-4">
                <p className={`text-[15px] text-[#4B5563] leading-relaxed line-clamp-3 font-medium`}>{item.content || item.title}</p>
            </div>
            {images.length > 0 && (
                <div className={`mb-4 overflow-hidden ${RADIUS_M} ${images.length > 1 ? 'grid gap-1 grid-cols-3' : ''}`}>
                    {images.slice(0, 3).map((img, idx) => (
                        <div key={idx} className={`relative bg-gray-50 ${images.length === 1 ? 'aspect-[16/9]' : 'aspect-square'}`}>
                            <img src={img} className="w-full h-full object-cover" />
                        </div>
                    ))}
                </div>
            )}
            <div className="flex items-center justify-between border-t border-gray-50 pt-4 mt-1">
                 <button className="flex items-center gap-2 text-gray-400 font-bold active:scale-110 transition-transform"><Share2 size={18} /></button>
                 <button className="flex items-center gap-2 text-gray-400 font-bold active:scale-110 transition-transform"><MessageSquare size={18} /><span className="text-[12px] font-oswald">{item.comments || 0}</span></button>
                 <button className="flex items-center gap-2 text-gray-400 font-bold active:scale-110 transition-transform"><Heart size={18} /><span className="text-[12px] font-oswald">{item.likes || 0}</span></button>
            </div>
        </div>
    );
};

// Sub-components logic remains similar but UI matches Merged Spec
const OfficialView: React.FC<{ onShowMore: any, onShowActivityMore: any }> = ({ onShowMore, onShowActivityMore }) => {
    const { slides, sections } = DISCOVERY_OFFICIAL_DATA;
    return (
        <div className="space-y-10 pb-20">
            {/* Banner - Mode B Hero */}
            <div className="h-[200px] w-full rounded-[24px] overflow-hidden relative shadow-md">
                <img src={slides[0].image} className="w-full h-full object-cover" />
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                <div className="absolute bottom-5 left-5 text-white">
                    <h3 className="text-xl font-bold mb-1">{slides[0].title}</h3>
                    <p className="text-xs opacity-80 uppercase tracking-widest">{slides[0].subtitle}</p>
                </div>
            </div>

            {sections.map(section => (
                <div key={section.id}>
                    <div className="flex justify-between items-center mb-5 px-1">
                        <h3 className={`text-[18px] font-bold ${COLOR_TEXT_MAIN}`}>{section.title}</h3>
                        <ChevronRight size={18} className="text-gray-300" />
                    </div>
                    <div className="flex overflow-x-auto no-scrollbar gap-4 px-1">
                        {section.items.map(item => (
                            <div key={item.id} className="w-[260px] shrink-0 bg-white rounded-3xl overflow-hidden border border-gray-50 shadow-sm active:scale-[0.98] transition-all">
                                <img src={item.image} className="w-full h-[140px] object-cover" />
                                <div className="p-4">
                                    <h4 className="text-[15px] font-bold line-clamp-2 leading-snug h-[42px]">{item.title}</h4>
                                    <div className="flex justify-between items-center mt-3 text-gray-400 text-[11px] font-oswald">
                                        <span>{item.date}</span>
                                        <span className="flex items-center gap-1"><Eye size={12} /> {item.views}</span>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            ))}
        </div>
    );
};

const PostDetailView: React.FC<{ post: DiscoveryItem; onClose: () => void }> = ({ post, onClose }) => (
    <div className="absolute inset-0 z-[2000] bg-white flex flex-col animate-in slide-in-from-right duration-300">
         <div className="pt-[54px] px-4 pb-3 flex items-center justify-between border-b border-gray-50">
             <button onClick={onClose} className="p-2"><ChevronLeft size={24} /></button>
             <div className="flex items-center gap-2">
                 <img src={post.user?.avatar} className="w-8 h-8 rounded-full" />
                 <span className="font-bold text-[14px]">{post.user?.name}</span>
             </div>
             <button className="text-[13px] font-bold text-[#FF6B00] border border-[#FF6B00] px-4 py-1 rounded-full">关注</button>
         </div>
         <div className="flex-1 overflow-y-auto p-5">
             <h1 className="text-[22px] font-bold mb-6 leading-tight">{post.title || post.content?.slice(0, 20)}</h1>
             <p className="text-[16px] text-[#374151] leading-relaxed mb-6">{post.content}</p>
             <div className="space-y-2">
                {post.images?.map((img, i) => <img key={i} src={img} className="w-full rounded-2xl" />)}
             </div>
         </div>
    </div>
);

const DiscoverySearchView = ({ onClose }: any) => <div className="absolute inset-0 z-[2100] bg-white animate-in slide-in-from-bottom duration-300"><div className="pt-[54px] px-5 flex items-center gap-4"><button onClick={onClose}><X /></button><input autoFocus className="flex-1 h-11 bg-gray-50 rounded-full px-5 outline-none" placeholder="搜索内容" /></div></div>;
const PlusMenu = ({ onClose, onAction }: any) => <div className="absolute inset-0 z-[2000] bg-black/60 backdrop-blur-sm animate-in fade-in" onClick={onClose}><div className="absolute bottom-[100px] left-5 right-5 bg-white rounded-[32px] p-8 grid grid-cols-2 gap-4 animate-in slide-in-from-bottom duration-300" onClick={e => e.stopPropagation()}><button onClick={() => onAction('post')} className="flex flex-col items-center gap-2"><div className="w-16 h-16 rounded-full bg-orange-50 flex items-center justify-center text-[#FF6B00]"><ImageIcon /></div><span className="font-bold">发动态</span></button><button onClick={() => onAction('video')} className="flex flex-col items-center gap-2"><div className="w-16 h-16 rounded-full bg-blue-50 flex items-center justify-center text-blue-500"><Video /></div><span className="font-bold">发视频</span></button></div></div>;

export default DiscoveryView;