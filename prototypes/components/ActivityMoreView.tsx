
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Trophy,
  Calendar,
  MapPin,
  Users,
  ChevronRight,
  Filter
} from 'lucide-react';
import { DISCOVERY_OFFICIAL_DATA } from '../data';

interface ActivityMoreViewProps {
  onBack: () => void;
}

// Generate more mock data based on existing items
const BASE_ACTIVITIES = DISCOVERY_OFFICIAL_DATA.sections.find(s => s.id === 'activities')?.items || [];
const MOCK_ACTIVITIES = [
    ...BASE_ACTIVITIES,
    { id: 'act_m1', title: 'BJ60 车主专享：周末露营派对', image: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400&auto=format&fit=crop', date: '招募中', views: 5600, points: 800, tag: '官方车友会', status: 'recruiting' },
    { id: 'act_m2', title: '分享你的越野故事，赢取千元油卡', image: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=400&auto=format&fit=crop', date: '进行中', views: 12500, points: 500, tag: '线上征集', status: 'ongoing' },
    { id: 'act_m3', title: '爱车讲堂：冬季用车养护指南', image: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?q=80&w=400&auto=format&fit=crop', date: '已结束', views: 3200, points: 100, tag: '线上直播', status: 'ended' },
    { id: 'act_m4', title: '2024 阿拉善英雄会招募令', image: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=400&auto=format&fit=crop', date: '招募中', views: 45000, points: 2000, tag: '年度盛典', status: 'recruiting' },
    { id: 'act_m5', title: '问卷调查：新车型配置偏好调研', image: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?q=80&w=400&auto=format&fit=crop', date: '进行中', views: 890, points: 150, tag: '调研', status: 'ongoing' },
];

const TABS = [
    { label: '全部', id: 'all' },
    { label: '招募中', id: 'recruiting' },
    { label: '进行中', id: 'ongoing' },
    { label: '已结束', id: 'ended' }
];

const ActivityMoreView: React.FC<ActivityMoreViewProps> = ({ onBack }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('all');
  const [isScrolled, setIsScrolled] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 1000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        setIsScrolled(scrollRef.current.scrollTop > 10);
      }
    };
    const el = scrollRef.current;
    if (el) {
        el.addEventListener('scroll', handleScroll);
        return () => el.removeEventListener('scroll', handleScroll);
    }
  }, [isLoading]);

  const filteredItems = activeTab === 'all' 
    ? MOCK_ACTIVITIES 
    : MOCK_ACTIVITIES.filter(item => (item as any).status === activeTab || (activeTab === 'recruiting' && item.date === '招募中') || (activeTab === 'ongoing' && item.date === '进行中'));

  // --- Skeleton Screen ---
  if (isLoading) {
      return (
          <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col">
              <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
                 <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
                 <div className="w-32 h-6 bg-gray-100 rounded animate-shimmer" />
                 <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
              </div>
              <div className="px-5 py-4 flex gap-3">
                 {[1,2,3,4].map(i => <div key={i} className="w-20 h-8 rounded-full bg-gray-200 animate-shimmer" />)}
              </div>
              <div className="px-5 space-y-4">
                 {[1,2,3].map(i => (
                     <div key={i} className="w-full h-[240px] rounded-[24px] bg-gray-200 animate-shimmer" />
                 ))}
              </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header */}
      <div className={`pt-[54px] px-5 pb-3 flex justify-between items-center z-20 transition-all duration-300 ${
          isScrolled ? 'bg-white shadow-[0_4px_20px_rgba(0,0,0,0.03)]' : 'bg-[#F5F7FA]'
      }`}>
          <button onClick={onBack} className="w-10 h-10 -ml-2 flex items-center justify-center rounded-full active:bg-black/5 transition-colors">
              <ArrowLeft size={24} className="text-[#111]" />
          </button>
          
          <div className="text-[18px] font-bold text-[#111]">活动广场</div>
          
          {/* User Points Display in Header */}
          <div className="flex items-center gap-1.5 bg-orange-50 px-3 py-1.5 rounded-full border border-orange-100">
              <Trophy size={14} className="text-[#FF6B00]" />
              <span className="text-[12px] font-bold text-[#FF6B00] font-oswald">2,450</span>
          </div>
      </div>

      {/* Scroll Content */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto no-scrollbar relative">
          {/* Sticky Tabs */}
          <div className="sticky top-0 z-10 bg-[#F5F7FA]/95 backdrop-blur-md px-5 pb-4 pt-2">
              <div className="flex gap-3 overflow-x-auto no-scrollbar">
                  {TABS.map(tab => (
                      <button
                        key={tab.id}
                        onClick={() => setActiveTab(tab.id)}
                        className={`px-5 py-2 rounded-full text-[13px] font-medium whitespace-nowrap transition-all active:scale-95 ${
                            activeTab === tab.id
                                ? 'bg-[#111] text-white shadow-md'
                                : 'bg-white text-gray-500 border border-gray-100 shadow-sm'
                        }`}
                      >
                          {tab.label}
                      </button>
                  ))}
              </div>
          </div>

          <div className="px-5 pb-10 space-y-5">
              {filteredItems.map((item, index) => {
                  const isLarge = index === 0; // First item is always large
                  const status = (item as any).status || (item.date === '招募中' ? 'recruiting' : item.date === '已结束' ? 'ended' : 'ongoing');
                  
                  return (
                      <div 
                        key={`${item.id}-${index}`}
                        className={`bg-white rounded-[24px] overflow-hidden shadow-[0_4px_20px_rgba(0,0,0,0.05)] active:scale-[0.98] transition-transform cursor-pointer group relative`}
                      >
                          {/* Image Area */}
                          <div className={`w-full relative ${isLarge ? 'h-[200px]' : 'h-[160px]'}`}>
                              <img src={item.image} className="w-full h-full object-cover group-active:scale-105 transition-transform duration-700" />
                              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
                              
                              {/* Status Badge */}
                              <div className={`absolute top-4 left-4 px-2.5 py-1 rounded-lg text-[10px] font-bold text-white shadow-sm flex items-center gap-1 ${
                                  status === 'recruiting' ? 'bg-[#111]' : 
                                  status === 'ended' ? 'bg-gray-500' : 'bg-[#10B981]'
                              }`}>
                                  {status === 'recruiting' && '🔥 招募中'}
                                  {status === 'ongoing' && '🟢 进行中'}
                                  {status === 'ended' && '⚫ 已结束'}
                              </div>

                              {/* Points Badge */}
                              <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-md text-[#111] px-3 py-1 rounded-full text-[12px] font-bold font-oswald shadow-lg flex items-center gap-1">
                                  <Trophy size={12} className="fill-[#111]" />
                                  +{item.points}
                              </div>
                          </div>

                          {/* Content Area */}
                          <div className="p-4">
                              <h3 className={`text-[16px] font-bold text-[#111] mb-2 leading-snug line-clamp-2`}>
                                  {item.title}
                              </h3>
                              
                              <div className="flex items-center justify-between mt-3">
                                  {/* Left: Metadata */}
                                  <div className="flex items-center gap-3 text-gray-400 text-[11px] font-medium">
                                      {item.tag && (
                                          <span className="bg-gray-50 text-gray-500 px-1.5 py-0.5 rounded border border-gray-100">
                                              #{item.tag}
                                          </span>
                                      )}
                                      <span className="flex items-center gap-1"><Users size={12} /> {item.views}人参与</span>
                                  </div>
                                  
                                  {/* Right: Action Button */}
                                  <div className={`flex items-center gap-1 text-[12px] font-bold ${
                                      status === 'ended' ? 'text-gray-300' : 'text-[#111]'
                                  }`}>
                                      {status === 'ended' ? '查看回顾' : '立即报名'} <ChevronRight size={14} />
                                  </div>
                              </div>
                          </div>
                      </div>
                  )
              })}

              {filteredItems.length === 0 && (
                  <div className="py-20 text-center">
                      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-300">
                          <Trophy size={24} />
                      </div>
                      <p className="text-gray-400 text-sm">暂无相关活动</p>
                  </div>
              )}
              
              <div className="py-6 text-center text-[10px] text-gray-300 font-oswald tracking-[0.2em]">
                  更多精彩活动即将上线
              </div>
          </div>
      </div>
    </div>
  );
};

export default ActivityMoreView;
