
import React from 'react';
import { ArrowLeft, Gift, CheckCircle2, ChevronRight } from 'lucide-react';

interface TaskCenterViewProps {
  onBack: () => void;
}

const TaskCenterView: React.FC<TaskCenterViewProps> = ({ onBack }) => {
  return (
    <div className="absolute inset-0 z-[150] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Header Banner */}
      <div className="h-[240px] bg-[#111] relative overflow-hidden shrink-0">
          <div className="absolute inset-0 bg-gradient-to-br from-[#1a1a1a] to-[#333]" />
          <div className="relative z-10 pt-[54px] px-5">
              <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-white/10 transition-colors text-white">
                  <ArrowLeft size={24} />
              </button>
              <div className="mt-4 flex justify-between items-end text-white">
                  <div>
                      <h1 className="text-[24px] font-bold mb-1">任务中心</h1>
                      <p className="text-[12px] opacity-70">完成任务 赢取丰厚好礼</p>
                  </div>
                  <div className="w-16 h-16 bg-white/10 rounded-full flex items-center justify-center backdrop-blur-md border border-white/10 animate-bounce">
                      <Gift size={32} className="text-[#FF6B00]" />
                  </div>
              </div>
          </div>
          {/* Corrected: rounded-t-3xl (Radius-L) */}
          <div className="absolute bottom-0 left-0 right-0 h-10 bg-[#F5F7FA] rounded-t-3xl" />
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar px-5 -mt-6 relative z-10 pb-10">
          {/* Daily Tasks - Corrected: rounded-2xl (Radius-M) */}
          <div className="bg-white rounded-2xl p-5 shadow-sm mb-5">
              <h2 className="text-[16px] font-bold text-[#111] mb-4 flex items-center gap-2">
                  <span className="w-1 h-4 bg-[#FF6B00] rounded-full" />
                  每日任务
              </h2>
              <div className="space-y-6">
                  <TaskItem title="每日签到" desc="连续签到奖励更多" reward="+10" status="done" />
                  <TaskItem title="浏览商城" desc="浏览推荐商品 30 秒" reward="+20" status="todo" />
                  <TaskItem title="分享动态" desc="分享精彩生活到社区" reward="+50" status="todo" />
              </div>
          </div>

          {/* Growth Tasks - Corrected: rounded-2xl (Radius-M) */}
          <div className="bg-white rounded-2xl p-5 shadow-sm">
              <h2 className="text-[16px] font-bold text-[#111] mb-4 flex items-center gap-2">
                  <span className="w-1 h-4 bg-[#111] rounded-full" />
                  成长任务
              </h2>
              <div className="space-y-6">
                  <TaskItem title="完善个人信息" desc="填写昵称、头像等资料" reward="+100" status="done" />
                  <TaskItem title="绑定车辆" desc="认证成为车主" reward="+500" status="todo" />
                  <TaskItem title="首次保养" desc="完成首次车辆保养服务" reward="+300" status="locked" />
              </div>
          </div>
      </div>
    </div>
  );
};

const TaskItem = ({ title, desc, reward, status }: any) => (
    <div className="flex justify-between items-center">
        <div className="flex-1">
            <div className="text-[14px] font-bold text-[#111] mb-1">{title}</div>
            <div className="text-[11px] text-gray-400">{desc}</div>
        </div>
        <div className="flex flex-col items-end gap-1">
            <div className="text-[12px] font-bold text-[#FF6B00] font-oswald">{reward} 积分</div>
            {status === 'done' ? (
                <button className="px-4 py-1.5 rounded-full bg-gray-100 text-gray-400 text-[11px] font-bold flex items-center gap-1 cursor-default">
                    <CheckCircle2 size={12} /> 已完成
                </button>
            ) : status === 'locked' ? (
                <button className="px-4 py-1.5 rounded-full bg-gray-50 text-gray-300 text-[11px] font-bold cursor-not-allowed">
                    未解锁
                </button>
            ) : (
                <button className="px-4 py-1.5 rounded-full bg-[#111] text-white text-[11px] font-bold active:scale-95 transition-transform shadow-md">
                    去完成
                </button>
            )}
        </div>
    </div>
);

export default TaskCenterView;
