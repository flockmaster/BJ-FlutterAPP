
import React, { useState } from 'react';
import { ArrowLeft, Search, Trash2, ShoppingCart, Heart } from 'lucide-react';
import { DISCOVERY_DATA, STORE_CATEGORIES } from '../data';

interface MyFavoritesViewProps {
  onBack: () => void;
}

const MyFavoritesView: React.FC<MyFavoritesViewProps> = ({ onBack }) => {
  const [activeTab, setActiveTab] = useState<'content' | 'product'>('content');
  
  // Mock favorites
  const favPosts = DISCOVERY_DATA.slice(0, 4);
  const favProducts = STORE_CATEGORIES[0].hotProducts?.slice(0, 4) || [];

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-0 bg-white border-b border-gray-100">
        <div className="flex justify-between items-center mb-4">
            <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                <ArrowLeft size={24} className="text-[#111]" />
            </button>
            <div className="text-[17px] font-bold text-[#111]">我的收藏</div>
            <button className="w-9 h-9 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
                <Search size={22} className="text-[#111]" />
            </button>
        </div>

        <div className="flex gap-8">
            {['content', 'product'].map((tab) => (
                <button
                    key={tab}
                    onClick={() => setActiveTab(tab as any)}
                    className={`pb-3 text-[15px] font-medium relative ${
                        activeTab === tab ? 'text-[#111] font-bold' : 'text-gray-400'
                    }`}
                >
                    {tab === 'content' ? '内容' : '商品'}
                    {activeTab === tab && (
                        <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-4 h-0.5 bg-[#111] rounded-full" />
                    )}
                </button>
            ))}
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-5">
          {activeTab === 'content' ? (
              <div className="space-y-4">
                  {favPosts.map((post, idx) => (
                      <div key={idx} className="bg-white rounded-[16px] p-4 flex gap-4 shadow-sm active:scale-[0.99] transition-transform cursor-pointer">
                          <div className="w-[100px] h-[75px] rounded-[10px] bg-gray-100 overflow-hidden shrink-0">
                              <img src={post.image || (post.images && post.images[0]) || ''} className="w-full h-full object-cover" />
                          </div>
                          <div className="flex-1 flex flex-col justify-between py-0.5">
                              <div className="text-[14px] font-bold text-[#111] line-clamp-2 leading-snug">{post.title || post.content}</div>
                              <div className="flex justify-between items-center text-[11px] text-gray-400">
                                  <div className="flex items-center gap-1.5">
                                      <img src={post.user?.avatar} className="w-4 h-4 rounded-full" />
                                      <span className="truncate max-w-[80px]">{post.user?.name}</span>
                                  </div>
                                  <span>{post.likes} 赞</span>
                              </div>
                          </div>
                      </div>
                  ))}
              </div>
          ) : (
              <div className="space-y-4">
                  {favProducts.map((prod, idx) => (
                      <div key={idx} className="bg-white rounded-[16px] p-4 flex gap-4 shadow-sm active:scale-[0.99] transition-transform cursor-pointer">
                          <div className="w-[90px] h-[90px] rounded-[10px] bg-gray-50 overflow-hidden shrink-0">
                              <img src={prod.image} className="w-full h-full object-cover" />
                          </div>
                          <div className="flex-1 flex flex-col justify-between py-1">
                              <div>
                                  <div className="text-[14px] font-bold text-[#111] line-clamp-2 leading-snug mb-1">{prod.title}</div>
                                  <div className="text-[10px] text-gray-400 bg-gray-50 w-fit px-1.5 py-0.5 rounded">
                                      已降价 ¥20
                                  </div>
                              </div>
                              <div className="flex justify-between items-center">
                                  <div className="text-[16px] font-bold text-[#FF6B00] font-oswald">¥{prod.price}</div>
                                  <button className="w-7 h-7 rounded-full bg-gray-100 flex items-center justify-center text-[#111] active:bg-[#111] active:text-white transition-colors">
                                      <ShoppingCart size={14} />
                                  </button>
                              </div>
                          </div>
                      </div>
                  ))}
              </div>
          )}
      </div>
    </div>
  );
};

export default MyFavoritesView;
