
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  MoreHorizontal, 
  MapPin, 
  Share2, 
  ShieldCheck, 
  Heart,
  Check
} from 'lucide-react';
import { DISCOVERY_DATA } from '../data';
import { IconButton } from './ui/Button';
import MedalVector from './ui/MedalVector';
import MedalDetailView from './MedalDetailView';

interface ProfileViewProps {
  onBack: () => void;
}

const TABS = ['发布', '点赞', '勋章'];

const MEDALS_DATA = {
    unlocked: [
        { id: 1, name: '持之以恒', date: '2025.03.01', desc: '登录北京汽车App-社区，累计1天即可获得' },
        { id: 2, name: '越野新秀', date: '2023.06.20', desc: '成功完成首台北京汽车车辆绑定' },
        { id: 3, name: '活跃达人', date: '2023.11.02', desc: '在社区发布超过10条动态并获得勋章' },
    ],
    locked: [
        { id: 4, name: '进藏英雄', task: '单次行驶里程超过3000公里', progress: '1200/3000' },
        { id: 5, name: '阿拉善之星', task: '参与1次英雄会沙漠挑战', progress: '0/1' },
        { id: 6, name: '金牌改装', task: '发布3条精华改装动态', progress: '1/3' },
    ]
};

const ProfileView: React.FC<ProfileViewProps> = ({ onBack }) => {
  const [activeTab, setActiveTab] = useState('发布');
  const [selectedMedal, setSelectedMedal] = useState<any>(null);
  const [wornMedalId, setWornMedalId] = useState<number | null>(1);
  
  const publishedPosts = DISCOVERY_DATA.slice(0, 3); 
  const likedPosts = DISCOVERY_DATA.slice(3, 6);

  const handleWearMedal = (id: number) => {
      setWornMedalId(wornMedalId === id ? null : id);
      setSelectedMedal(null);
  };

  const renderContent = () => {
    if (activeTab === '勋章') {
        return (
            <div className="flex flex-col gap-10 p-5 pb-20">
                <div>
                    <div className="flex justify-between items-center mb-6 px-1">
                        <h3 className="text-[15px] font-bold text-[#111] flex items-center gap-2">
                            已点亮 <span className="bg-[#111] text-white text-[10px] px-2 py-0.5 rounded-full font-oswald">{MEDALS_DATA.unlocked.length}</span>
                        </h3>
                    </div>
                    <div className="grid grid-cols-3 gap-y-10">
                        {MEDALS_DATA.unlocked.map(medal => (
                            <div 
                                key={medal.id} 
                                onClick={() => setSelectedMedal(medal)}
                                className="flex flex-col items-center gap-3 active:scale-95 transition-transform cursor-pointer group"
                            >
                                <div className="relative">
                                    <MedalVector id={medal.id} className="w-16 h-16 drop-shadow-md" />
                                    {wornMedalId === medal.id && (
                                        <div className="absolute -top-1 -right-1 bg-[#111] text-[#E5C07B] text-[8px] font-bold px-1.5 py-0.5 rounded-full border-2 border-white shadow-sm flex items-center gap-0.5">
                                            佩戴中
                                        </div>
                                    )}
                                </div>
                                <div className="text-center">
                                    <div className="text-[12px] font-bold text-[#111] mb-0.5">{medal.name}</div>
                                    <div className="text-[9px] text-gray-400 font-oswald">{medal.date}</div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>

                <div>
                    <div className="flex justify-between items-center mb-6 px-1">
                        <h3 className="text-[15px] font-bold text-gray-400 flex items-center gap-2">
                            待解锁 <span className="bg-gray-100 text-gray-400 text-[10px] px-2 py-0.5 rounded-full font-oswald">{MEDALS_DATA.locked.length}</span>
                        </h3>
                    </div>
                    <div className="grid grid-cols-3 gap-y-10">
                        {MEDALS_DATA.locked.map(medal => (
                            <div 
                                key={medal.id} 
                                onClick={() => setSelectedMedal(medal)}
                                className="flex flex-col items-center gap-3 active:scale-95 transition-transform cursor-pointer group opacity-60"
                            >
                                <MedalVector id={medal.id} grayscale className="w-16 h-16" />
                                <div className="text-center">
                                    <div className="text-[12px] font-bold text-gray-400 mb-1">{medal.name}</div>
                                    <div className="w-10 h-1 bg-gray-100 rounded-full mx-auto overflow-hidden">
                                        <div 
                                            className="h-full bg-gray-300" 
                                            style={{ width: `${(parseInt(medal.progress.split('/')[0]) / parseInt(medal.progress.split('/')[1])) * 100}%` }} 
                                        />
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        );
    }

    const posts = activeTab === '点赞' ? likedPosts : publishedPosts;

    return (
        <div className="columns-2 gap-2 space-y-2 p-4 bg-[#FAFAFA] flex-1 overflow-y-auto no-scrollbar">
            {posts.map((post, idx) => (
                <div key={idx} className="break-inside-avoid bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-50 active:scale-95 transition-transform cursor-pointer">
                    <div className="relative">
                        <img 
                            src={post.image || (post.images && post.images[0]) || 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop'} 
                            className="w-full h-auto object-cover" 
                            alt="Post Content"
                        />
                    </div>
                    <div className="p-3">
                        <div className="text-[12px] font-bold text-[#111] line-clamp-2 mb-2 leading-tight">
                            {post.title || post.content}
                        </div>
                        <div className="flex justify-between items-center text-[10px] text-gray-400">
                            <div className="flex items-center gap-1.5">
                                <img src={post.user?.avatar} className="w-4 h-4 rounded-full" alt="User" />
                                <span className="max-w-[50px] truncate">{post.user?.name}</span>
                            </div>
                            <div className="flex items-center gap-0.5 font-oswald">
                                <Heart size={10} className={activeTab === '点赞' ? 'fill-red-500 text-red-500' : ''} /> {post.likes}
                            </div>
                        </div>
                    </div>
                </div>
            ))}
        </div>
    );
  };

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-500 overflow-hidden">
      {selectedMedal && (
          <MedalDetailView 
            medal={selectedMedal} 
            isWorn={wornMedalId === selectedMedal.id}
            onBack={() => setSelectedMedal(null)}
            onWear={handleWearMedal}
          />
      )}

      <div className="h-[220px] relative w-full bg-gray-800 shrink-0">
          <img 
            src="https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop" 
            className="w-full h-full object-cover opacity-80"
            alt="Profile Background"
          />
          <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-transparent to-[#F5F7FA]" />
          
          <div className="absolute top-0 left-0 right-0 pt-[54px] px-5 flex justify-between items-center z-10">
              <IconButton 
                icon={ArrowLeft} 
                onClick={onBack} 
                variant="blur" 
                className="bg-black/20 text-white"
              />
              <div className="flex gap-3">
                  <IconButton icon={Share2} variant="blur" className="bg-black/20 text-white" />
                  <IconButton icon={MoreHorizontal} variant="blur" className="bg-black/20 text-white" />
              </div>
          </div>
      </div>

      <div className="flex-1 -mt-32 relative z-10 overflow-hidden flex flex-col">
          <div className="px-5 pb-4">
              <div className="flex justify-between items-end mb-4">
                  <div className="relative">
                      <img 
                        src="https://randomuser.me/api/portraits/men/75.jpg" 
                        className="w-[80px] h-[80px] rounded-full border-[3px] border-white shadow-lg object-cover"
                        alt="Avatar"
                      />
                      {wornMedalId && (
                        <div className="absolute -top-1 -right-1 w-7 h-7 bg-white rounded-full p-0.5 shadow-md animate-in zoom-in">
                            <MedalVector id={wornMedalId} className="w-full h-full" />
                        </div>
                      )}
                      <div className="absolute -bottom-1 -right-1 bg-[#111] text-[#E5C07B] text-[9px] font-bold px-2 py-0.5 rounded-full border-2 border-white flex items-center gap-0.5">
                          <ShieldCheck size={10} /> BJ40车主
                      </div>
                  </div>
                  <button className="h-9 px-6 rounded-xl bg-[#111] text-white text-[13px] font-bold shadow-lg active:scale-95 transition-transform">
                      编辑资料
                  </button>
              </div>

              <div className="mb-4">
                  <div className="flex items-center gap-2 mb-0.5">
                    <h1 className="text-[22px] font-bold text-[#111]">张越野</h1>
                    <span className="text-[11px] text-gray-400 font-medium">ID: 88293011</span>
                  </div>
                  
                  <div className="flex items-center gap-3 text-[12px] text-gray-500 mb-3">
                      <div className="flex items-center gap-1">
                          <MapPin size={12} /> 北京·朝阳
                      </div>
                      <span className="w-[1px] h-2.5 bg-gray-300" />
                      <p className="line-clamp-1 italic">“热爱越野，热爱生活。”</p>
                  </div>

                  <div className="flex gap-8">
                      <div className="flex items-baseline gap-1.5">
                          <span className="text-[18px] font-bold font-oswald text-[#111]">128</span>
                          <span className="text-[11px] text-gray-400">关注</span>
                      </div>
                      <div className="flex items-baseline gap-1.5">
                          <span className="text-[18px] font-bold font-oswald text-[#111]">3.4k</span>
                          <span className="text-[11px] text-gray-400">粉丝</span>
                      </div>
                      <div className="flex items-baseline gap-1.5">
                          <span className="text-[18px] font-bold font-oswald text-[#111]">15.2k</span>
                          <span className="text-[11px] text-gray-400">获赞</span>
                      </div>
                  </div>
              </div>
          </div>

          {/* Corrected: rounded-t-3xl (24px) aligned with Design System Radius-L */}
          <div className="flex-1 bg-white rounded-t-3xl shadow-[0_-8px_30px_rgba(0,0,0,0.04)] flex flex-col overflow-hidden">
              <div className="flex border-b border-gray-50 px-4">
                  {TABS.map(tab => (
                      <button 
                        key={tab}
                        onClick={() => setActiveTab(tab)}
                        className={`flex-1 py-4 text-[15px] font-bold relative transition-colors ${
                            activeTab === tab ? 'text-[#111]' : 'text-gray-400'
                        }`}
                      >
                          {tab}
                          {activeTab === tab && (
                              <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-5 h-1.5 bg-[#111] rounded-full" />
                          )}
                      </button>
                  ))}
              </div>

              <div className="flex-1 overflow-y-auto no-scrollbar bg-[#FAFAFA]">
                  {renderContent()}
              </div>
          </div>
      </div>
    </div>
  );
};

export default ProfileView;
