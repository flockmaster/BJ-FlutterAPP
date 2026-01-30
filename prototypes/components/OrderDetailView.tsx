import React, { useState } from 'react';
import { 
  ArrowLeft, 
  MapPin, 
  Truck, 
  MessageSquare, 
  Phone, 
  Copy, 
  FileText, 
  ShoppingBag, 
  ChevronRight, 
  MoreHorizontal, 
  PackageCheck, 
  Circle, 
  X, 
  Headset, 
  QrCode, 
  Store, 
  Ticket, 
  CheckCircle2,
  Receipt,
  CreditCard,
  Wallet
} from 'lucide-react';

interface OrderDetailViewProps {
  order: any;
  onBack: () => void;
}

const OrderDetailView: React.FC<OrderDetailViewProps> = ({ order, onBack }) => {
  const [showLogistics, setShowLogistics] = useState(false);
  const orderType = order?.type || 'physical'; 

  // Mocking enriched data that would typically come from the backend based on the order ID
  // In a real app, 'order' prop is the summary, and we fetch details here.
  const orderDetails = {
      id: order?.id || 'ORD202401128829',
      status: order?.status || '已完成',
      createTime: '2024-01-12 10:23:45',
      payTime: '2024-01-12 10:24:10',
      paymentMethod: '微信支付',
      address: { name: '张越野', phone: '138****8888', detail: '北京市朝阳区建国路88号 SOHO现代城' },
      store: { name: '北京汽车越野4S店（朝阳）', address: '北京市朝阳区建国路88号', distance: '2.3km' },
      verifyCode: '8930 2931',
      redeemCode: 'ABCD-1234-EFGH',
      logistics: { company: '顺丰速运', no: 'SF138492039482', latest: '您的快件已签收，感谢使用顺丰速运。', time: '2024-01-14 18:30' },
      products: [
          { title: order?.title || '户外露营天幕帐篷', spec: order?.spec || '标准版', price: order?.price || '899', count: 1, image: order?.image || 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=200&auto=format&fit=crop' }
      ],
      // Financial Breakdown (Restoring the missing link from Checkout)
      costs: {
          subtotal: 949.00,
          shipping: 0,
          coupon: 50.00,
          points: 20.00, // Assuming 2000 points used
          total: parseFloat((order?.price || '899').replace(/,/g, ''))
      },
      // Invoice Info (Restoring missing link)
      invoice: {
          type: '电子普通发票',
          titleType: '个人',
          title: '张越野',
          content: '商品明细'
      }
  };

  return (
    <div className="absolute inset-0 z-[200] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100 z-10">
        <button onClick={onBack} className="w-9 h-9 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50"><ArrowLeft size={24} className="text-[#111]" /></button>
        <div className="text-[17px] font-bold text-[#111]">订单详情</div>
        <button className="w-9 h-9 -mr-2 rounded-full flex items-center justify-center active:bg-gray-50"><MoreHorizontal size={20} className="text-[#111]" /></button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar pb-[120px]">
          {/* Header Status */}
          <div className="bg-[#111] text-white p-6 pb-12">
              <div className="text-[22px] font-bold mb-1">{orderDetails.status}</div>
              <div className="text-[13px] opacity-60 font-medium">
                  {orderType === 'physical' ? '包裹已由顺丰速运送达' : orderType === 'service' ? '请前往预约门店核销服务' : '兑换码已发送至您的账户'}
              </div>
          </div>

          <div className="-mt-8 px-4 space-y-4">
              {/* Type Specific: Service Code */}
              {orderType === 'service' && (
                  <div className="bg-white rounded-3xl p-7 shadow-sm border border-white flex flex-col items-center">
                      <div className="text-[15px] font-bold text-[#111] mb-5 flex items-center gap-2"><QrCode size={18} className="text-blue-600" /> 服务核销码</div>
                      <div className="w-44 h-44 bg-[#F9FAFB] p-3 rounded-2xl mb-5 border border-gray-100"><QrCode size={152} className="text-[#111] w-full h-full" /></div>
                      <div className="font-oswald text-[28px] font-bold text-[#111] tracking-[0.2em] mb-1">{orderDetails.verifyCode}</div>
                      <div className="text-[12px] text-gray-400 font-medium">请出示给店员进行扫码核销</div>
                  </div>
              )}

              {/* Type Specific: Virtual Code */}
              {orderType === 'virtual' && (
                  <div className="bg-white rounded-3xl p-7 shadow-sm border border-white">
                      <div className="flex justify-between items-center mb-5">
                          <div className="text-[15px] font-bold text-[#111] flex items-center gap-2"><Ticket size={18} className="text-green-600" /> 兑换码</div>
                          <button className="text-[13px] text-[#FF6B00] font-bold" onClick={() => alert('已复制')}>复制</button>
                      </div>
                      <div className="bg-[#F9FAFB] rounded-2xl p-5 text-center border-2 border-dashed border-gray-200">
                          <div className="font-oswald text-[24px] font-bold text-[#111] tracking-wider">{orderDetails.redeemCode}</div>
                      </div>
                  </div>
              )}

              {/* Type Specific: Physical Logistics & Address */}
              {orderType === 'physical' && (
                  <>
                      <div onClick={() => setShowLogistics(true)} className="bg-white rounded-2xl p-4 shadow-sm active:bg-gray-50 cursor-pointer border border-white">
                          <div className="flex items-start gap-4">
                              <div className="w-10 h-10 bg-blue-50 text-blue-600 rounded-full flex items-center justify-center mt-0.5"><Truck size={20} /></div>
                              <div className="flex-1">
                                  <div className="text-[14px] font-bold text-[#111] mb-1 line-clamp-1">{orderDetails.logistics.latest}</div>
                                  <div className="text-[11px] text-gray-400">{orderDetails.logistics.time}</div>
                              </div>
                              <ChevronRight size={18} className="text-gray-300 mt-2" />
                          </div>
                      </div>
                      <div className="bg-white rounded-2xl p-4 shadow-sm flex items-start gap-4 border border-white">
                          <div className="w-10 h-10 bg-[#111] text-white rounded-full flex items-center justify-center shrink-0 mt-0.5"><MapPin size={20} /></div>
                          <div>
                              <div className="flex items-center gap-3 mb-1.5"><span className="text-[16px] font-bold text-[#111]">{orderDetails.address.name}</span><span className="text-[14px] text-gray-400 font-oswald">{orderDetails.address.phone}</span></div>
                              <div className="text-[13px] text-gray-500 font-medium">{orderDetails.address.detail}</div>
                          </div>
                      </div>
                  </>
              )}

              {/* Type Specific: Store Info */}
              {orderType === 'service' && (
                  <div className="bg-white rounded-2xl p-5 shadow-sm flex items-start gap-4 border border-blue-50">
                      <div className="w-11 h-11 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center shrink-0"><Store size={22} /></div>
                      <div className="flex-1">
                          <div className="text-[16px] font-bold text-[#111] mb-1.5">{orderDetails.store.name}</div>
                          <div className="text-[13px] text-gray-500 font-medium mb-4">{orderDetails.store.address}</div>
                          <div className="flex gap-3">
                              <button className="flex-1 h-9 bg-gray-50 rounded-full text-[12px] font-bold text-[#111] flex items-center justify-center gap-1.5"><Phone size={14} /> 联系门店</button>
                              <button className="flex-1 h-9 bg-[#111] rounded-full text-[12px] font-bold text-white flex items-center justify-center gap-1.5"><MapPin size={14} /> 导航</button>
                          </div>
                      </div>
                  </div>
              )}

              {/* Product List */}
              <div className="bg-white rounded-3xl p-5 shadow-sm border border-white">
                  <div className="flex items-center gap-2.5 mb-5 border-b border-gray-50 pb-4">
                      <ShoppingBag size={18} className="text-[#111]" />
                      <span className="text-[15px] font-bold text-[#111]">北京汽车商城自营</span>
                  </div>
                  {orderDetails.products.map((item, idx) => (
                      <div key={idx} className="flex gap-4">
                          <div className="w-[84px] h-[84px] bg-gray-50 rounded-2xl overflow-hidden shrink-0 border border-gray-100">
                              <img src={item.image} className="w-full h-full object-cover" />
                          </div>
                          <div className="flex-1 flex flex-col justify-between py-1">
                              <div>
                                  <div className="text-[15px] font-bold text-[#111] mb-1.5">{item.title}</div>
                                  <div className="text-[11px] text-gray-400 bg-gray-50 w-fit px-2 py-0.5 rounded-lg font-bold">{item.spec}</div>
                              </div>
                              <div className="flex justify-between items-center">
                                  <div className="text-[18px] font-bold text-[#111] font-oswald">¥{item.price}</div>
                                  <div className="text-[12px] text-gray-400 font-bold">x{item.count}</div>
                              </div>
                          </div>
                      </div>
                  ))}
              </div>

              {/* NEW: Financial Breakdown (Mirroring Checkout Logic) */}
              <div className="bg-white rounded-3xl p-5 shadow-sm border border-white">
                  <div className="space-y-3 pb-4 border-b border-gray-50">
                      <div className="flex justify-between text-[13px]">
                          <span className="text-gray-500">商品总额</span>
                          <span className="text-[#111] font-oswald">¥{orderDetails.costs.subtotal.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between text-[13px]">
                          <span className="text-gray-500">运费</span>
                          <span className="text-[#111] font-oswald">¥{orderDetails.costs.shipping.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between text-[13px]">
                          <span className="text-gray-500">优惠券</span>
                          <span className="text-[#FF6B00] font-oswald">-¥{orderDetails.costs.coupon.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between text-[13px]">
                          <span className="text-gray-500">积分抵扣</span>
                          <span className="text-[#FF6B00] font-oswald">-¥{orderDetails.costs.points.toFixed(2)}</span>
                      </div>
                  </div>
                  <div className="pt-4 flex justify-between items-center">
                      <span className="text-[14px] font-bold text-[#111]">实付款</span>
                      <span className="text-[20px] font-bold font-oswald text-[#FF6B00]">¥{orderDetails.costs.total.toLocaleString()}</span>
                  </div>
              </div>

              {/* NEW: Invoice & Order Info */}
              <div className="bg-white rounded-3xl overflow-hidden shadow-sm border border-white">
                  {/* Invoice Section */}
                  <div className="p-5 border-b border-gray-50">
                      <div className="flex items-center gap-2 mb-3">
                          <Receipt size={16} className="text-[#111]" />
                          <span className="text-[14px] font-bold text-[#111]">发票信息</span>
                      </div>
                      <div className="text-[13px] text-gray-500 space-y-1">
                          <div className="flex"><span className="w-16 opacity-70">发票类型</span><span>{orderDetails.invoice.type}</span></div>
                          <div className="flex"><span className="w-16 opacity-70">发票抬头</span><span>{orderDetails.invoice.title} ({orderDetails.invoice.titleType})</span></div>
                          <div className="flex"><span className="w-16 opacity-70">发票内容</span><span>{orderDetails.invoice.content}</span></div>
                      </div>
                      <div className="mt-3">
                          <button className="text-[11px] font-bold text-[#111] border border-gray-200 px-3 py-1 rounded-full active:bg-gray-50">
                              查看发票
                          </button>
                      </div>
                  </div>

                  {/* Basic Order Info */}
                  <div className="p-5">
                      <div className="flex items-center gap-2 mb-3">
                          <FileText size={16} className="text-[#111]" />
                          <span className="text-[14px] font-bold text-[#111]">订单信息</span>
                      </div>
                      <div className="text-[12px] text-gray-500 space-y-2">
                          <div className="flex justify-between">
                              <span className="opacity-70">订单编号</span>
                              <span className="font-oswald flex items-center gap-2">
                                  {orderDetails.id} 
                                  <Copy size={10} className="text-[#111]" />
                              </span>
                          </div>
                          <div className="flex justify-between">
                              <span className="opacity-70">创建时间</span>
                              <span className="font-oswald">{orderDetails.createTime}</span>
                          </div>
                          <div className="flex justify-between">
                              <span className="opacity-70">支付时间</span>
                              <span className="font-oswald">{orderDetails.payTime}</span>
                          </div>
                          <div className="flex justify-between">
                              <span className="opacity-70">支付方式</span>
                              <span className="flex items-center gap-1.5">
                                  {orderDetails.paymentMethod === '微信支付' ? <MessageSquare size={12} className="text-[#07C160] fill-current" /> : <Wallet size={12} className="text-[#1677FF]" />}
                                  {orderDetails.paymentMethod}
                              </span>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>

      <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-xl border-t border-gray-100 px-5 pt-3 pb-[34px] flex justify-end items-center gap-3 shadow-[0_-4px_30px_rgba(0,0,0,0.04)]">
          <button className="px-5 py-2.5 rounded-full border border-gray-200 text-[13px] text-gray-600 font-bold active:bg-gray-50 flex items-center gap-1">
              <Headset size={14} /> 专属客服
          </button>
          <button className="px-8 py-2.5 rounded-full bg-[#111] text-white text-[13px] font-bold active:scale-95 transition-transform shadow-lg shadow-black/20">
              再次购买
          </button>
      </div>
    </div>
  );
};

export default OrderDetailView;