
import React, { useState, useEffect, useRef } from 'react';
import { 
  ArrowLeft, 
  Search, 
  Eye, 
  Filter
} from 'lucide-react';
import { DISCOVERY_OFFICIAL_DATA } from '../data';

interface OfficialNewsListViewProps {
  onBack: () => void;
}

// Flatten data for the list
const ALL_NEWS = DISCOVERY_OFFICIAL_DATA.sections.flatMap(section => 
    section.items.map(item => ({...item, category: section.title}))
);

const CATEGORIES = ['全部', ...DISCOVERY_OFFICIAL_DATA.sections.map(s => s.title)];

const OfficialNewsListView: React.FC<OfficialNewsListViewProps> = ({ onBack }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [activeCategory, setActiveCategory] = useState('全部');
  const [isScrolled, setIsScrolled] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 1000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      if (scrollRef.current) {
        // Change header style when content scrolls under it
        setIsScrolled(scrollRef.current.scrollTop > 10);
      }
    };
    const el = scrollRef.current;
    if (el) {
        el.addEventListener('scroll', handleScroll);
        return () => el.removeEventListener('scroll', handleScroll);
    }
  }, [isLoading]);

  const filteredNews = activeCategory === '全部' 
    ? ALL_NEWS 
    : ALL_NEWS.filter(item => item.category === activeCategory);

  // --- Skeleton Screen ---
  if (isLoading) {
      return (
          <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col">
              {/* Header Skeleton */}
              <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
                 <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
                 <div className="w-32 h-6 bg-gray-100 rounded animate-shimmer" />
                 <div className="w-8 h-8 bg-gray-100 rounded animate-shimmer" />
              </div>
              
              {/* Tabs Skeleton */}
              <div className="px-5 py-4 flex gap-3 overflow-hidden">
                 {[1,2,3,4].map(i => <div key={i} className="w-20 h-8 rounded-full bg-gray-200 animate-shimmer shrink-0" />)}
              </div>

              {/* List Skeleton */}
              <div className="px-5 space-y-4">
                 {/* Hero Skeleton */}
                 <div className="w-full h-[200px] rounded-[24px] bg-gray-200 animate-shimmer mb-6" />
                 
                 {[1,2,3,4].map(i => (
                     <div key={i} className="flex gap-4 p-4 bg-white rounded-[20px]">
                         <div className="flex-1 space-y-3">
                             <div className="w-full h-4 bg-gray-100 rounded animate-shimmer" />
                             <div className="w-2/3 h-4 bg-gray-100 rounded animate-shimmer" />
                             <div className="w-1/3 h-3 bg-gray-100 rounded animate-shimmer mt-2" />
                         </div>
                         <div className="w-[100px] h-[75px] bg-gray-200 rounded-[16px] animate-shimmer" />
                     </div>
                 ))}
              </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-[100] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header - Stays at top of Flex Column */}
      <div className={`pt-[54px] px-5 pb-3 flex justify-between items-center z-20 transition-all duration-300 ${
          isScrolled ? 'bg-white shadow-[0_4px_20px_rgba(0,0,0,0.03)]' : 'bg-[#F5F7FA]'
      }`}>
          <button onClick={onBack} className="w-10 h-10 -ml-2 flex items-center justify-center rounded-full active:bg-black/5 transition-colors">
              <ArrowLeft size={24} className="text-[#111]" />
          </button>
          <div className="text-[18px] font-bold text-[#111]">官方资讯</div>
          <button className="w-10 h-10 -mr-2 flex items-center justify-center rounded-full active:bg-black/5 transition-colors">
              <Search size={22} className="text-[#111]" />
          </button>
      </div>

      {/* Scroll Content - Takes remaining height */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto no-scrollbar relative">
          {/* Categories Tab - Sticky to the top of THIS container (which is just below Header) */}
          <div className="sticky top-0 z-10 bg-[#F5F7FA]/95 backdrop-blur-md px-5 pb-4 pt-2 transition-colors duration-300">
              <div className="flex gap-3 overflow-x-auto no-scrollbar">
                  {CATEGORIES.map(cat => (
                      <button
                        key={cat}
                        onClick={() => setActiveCategory(cat)}
                        className={`px-5 py-2 rounded-full text-[13px] font-medium whitespace-nowrap transition-all active:scale-95 ${
                            activeCategory === cat
                                ? 'bg-[#111] text-white shadow-md'
                                : 'bg-white text-gray-500 border border-gray-100 shadow-sm'
                        }`}
                      >
                          {cat}
                      </button>
                  ))}
              </div>
          </div>

          <div className="px-5 pb-10">
              {/* Hero Item (Show first item of filtered list as Hero) */}
              {filteredNews.length > 0 && (
                  <div className="mb-6 group cursor-pointer active:scale-[0.98] transition-transform">
                      <div className="w-full h-[220px] rounded-[24px] overflow-hidden relative shadow-[0_8px_24px_rgba(0,0,0,0.08)]">
                          <img src={filteredNews[0].image} className="w-full h-full object-cover group-active:scale-105 transition-transform duration-700" />
                          <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
                          <div className="absolute bottom-5 left-5 right-5">
                              {filteredNews[0].tag && (
                                  <span className="inline-block px-2 py-0.5 bg-[#FF6B00] text-white text-[10px] font-bold rounded mb-2 shadow-sm">
                                      {filteredNews[0].tag}
                                  </span>
                              )}
                              <h3 className="text-[20px] font-bold text-white leading-tight mb-2">
                                  {filteredNews[0].title}
                              </h3>
                              <div className="flex items-center gap-3 text-white/70 text-[11px] font-oswald">
                                  <span>{filteredNews[0].date}</span>
                                  <span className="flex items-center gap-1"><Eye size={12} /> {filteredNews[0].views}</span>
                              </div>
                          </div>
                      </div>
                  </div>
              )}

              {/* List Items */}
              <div className="flex flex-col gap-4">
                  {filteredNews.slice(1).map((item, index) => (
                      <div 
                        key={`${item.id}-${index}`}
                        className="bg-white rounded-[20px] p-4 flex gap-4 shadow-[0_4px_20px_rgba(0,0,0,0.03)] active:scale-[0.99] transition-transform cursor-pointer border border-transparent hover:border-gray-50"
                      >
                          <div className="flex-1 flex flex-col justify-between py-1">
                              <div>
                                  {item.tag && (
                                      <span className="inline-block px-1.5 py-0.5 bg-orange-50 text-[#FF6B00] text-[9px] font-bold rounded mb-1.5 border border-orange-100">
                                          {item.tag}
                                      </span>
                                  )}
                                  <h4 className="text-[15px] font-bold text-[#111] leading-snug line-clamp-2">
                                      {item.title}
                                  </h4>
                              </div>
                              <div className="flex items-center justify-between mt-3">
                                  <div className="flex items-center gap-3 text-gray-400 text-[11px] font-oswald">
                                      <span>{item.date}</span>
                                      <span className="flex items-center gap-1"><Eye size={12} /> {item.views}</span>
                                  </div>
                              </div>
                          </div>
                          <div className="w-[110px] h-[80px] rounded-[16px] overflow-hidden shrink-0 bg-gray-100 relative shadow-sm">
                              <img src={item.image} className="w-full h-full object-cover" />
                              {/* Type Indicator */}
                              {(item as any).category === '活动赚积分' && (
                                  <div className="absolute top-0 right-0 bg-[#FF6B00] text-white text-[9px] px-1.5 py-0.5 rounded-bl-lg font-bold shadow-sm">
                                      积分
                                  </div>
                              )}
                          </div>
                      </div>
                  ))}
              </div>

              {filteredNews.length === 0 && (
                  <div className="py-20 text-center">
                      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-300">
                          <Filter size={24} />
                      </div>
                      <p className="text-gray-400 text-sm">暂无相关资讯</p>
                  </div>
              )}
              
              <div className="py-8 text-center text-[10px] text-gray-300 font-oswald tracking-[0.2em]">
                  已经到底了
              </div>
          </div>
      </div>
    </div>
  );
};

export default OfficialNewsListView;
