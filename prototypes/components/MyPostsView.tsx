
import React from 'react';
import { ArrowLeft, MoreHorizontal, Heart, Video } from 'lucide-react';
import { DISCOVERY_DATA } from '../data';

interface MyPostsViewProps {
  onBack: () => void;
}

const MyPostsView: React.FC<MyPostsViewProps> = ({ onBack }) => {
  const posts = DISCOVERY_DATA; // Reuse discovery data for demo

  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">我的发布</div>
        <button className="w-9 h-9 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <MoreHorizontal size={22} className="text-[#111]" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar p-1">
          <div className="grid grid-cols-2 gap-1">
              {posts.map((post, idx) => (
                  <div key={idx} className="bg-white relative aspect-[4/5] overflow-hidden group cursor-pointer">
                      <img 
                        src={post.image || (post.images && post.images[0]) || 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop'} 
                        className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                      
                      {post.isVideo && (
                          <div className="absolute top-2 right-2 text-white drop-shadow-md">
                              <Video size={16} />
                          </div>
                      )}

                      <div className="absolute bottom-2 left-2 right-2 flex justify-between items-end text-white">
                          <div className="text-[10px] bg-black/20 backdrop-blur-md px-1.5 py-0.5 rounded flex items-center gap-1">
                              <Heart size={10} className="fill-white" /> {post.likes}
                          </div>
                      </div>
                  </div>
              ))}
          </div>
      </div>
    </div>
  );
};

export default MyPostsView;
