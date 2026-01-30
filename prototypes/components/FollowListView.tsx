
import React, { useState } from 'react';
import { ArrowLeft, UserCheck, UserPlus } from 'lucide-react';

interface FollowListViewProps {
  type: 'following' | 'followers';
  onBack: () => void;
}

const FollowListView: React.FC<FollowListViewProps> = ({ type, onBack }) => {
  const [users, setUsers] = useState([
      { id: 1, name: '越野老炮', bio: '专注硬派越野30年', avatar: 'https://randomuser.me/api/portraits/men/1.jpg', isFollowing: true },
      { id: 2, name: '旅行家小王', bio: '开着BJ60环游中国', avatar: 'https://randomuser.me/api/portraits/men/2.jpg', isFollowing: false },
      { id: 3, name: '改装达人', bio: '专业改装咨询', avatar: 'https://randomuser.me/api/portraits/women/3.jpg', isFollowing: true },
      { id: 4, name: '北汽铁粉', bio: 'BJ40车主，热爱生活', avatar: 'https://randomuser.me/api/portraits/men/4.jpg', isFollowing: false },
      { id: 5, name: '荒野求生', bio: '户外生存专家', avatar: 'https://randomuser.me/api/portraits/men/5.jpg', isFollowing: true },
  ]);

  const toggleFollow = (id: number) => {
      setUsers(users.map(u => u.id === id ? { ...u, isFollowing: !u.isFollowing } : u));
  };

  return (
    <div className="absolute inset-0 z-[150] bg-white flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex items-center gap-3 bg-white border-b border-gray-100">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">
            {type === 'following' ? '我的关注' : '我的粉丝'}
        </div>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar">
          {users.map(user => (
              <div key={user.id} className="flex items-center justify-between p-5 border-b border-gray-50 last:border-0 hover:bg-gray-50 transition-colors cursor-pointer">
                  <div className="flex items-center gap-4">
                      <img src={user.avatar} className="w-12 h-12 rounded-full bg-gray-100 object-cover" />
                      <div>
                          <div className="text-[15px] font-bold text-[#111] mb-0.5">{user.name}</div>
                          <div className="text-[12px] text-gray-400 line-clamp-1">{user.bio}</div>
                      </div>
                  </div>
                  <button 
                    onClick={(e) => {
                        e.stopPropagation();
                        toggleFollow(user.id);
                    }}
                    className={`h-8 px-4 rounded-full text-[12px] font-bold flex items-center gap-1 transition-all ${
                        user.isFollowing 
                            ? 'bg-gray-100 text-gray-500 border border-transparent' 
                            : 'bg-[#111] text-white shadow-md active:scale-95'
                    }`}
                  >
                      {user.isFollowing ? (
                          <>已关注</>
                      ) : (
                          <><UserPlus size={14} /> 关注</>
                      )}
                  </button>
              </div>
          ))}
          <div className="py-8 text-center text-[11px] text-gray-300 font-oswald tracking-[0.2em]">
              暂无更多用户
          </div>
      </div>
    </div>
  );
};

export default FollowListView;
