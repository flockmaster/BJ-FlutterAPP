import React, { useState, useEffect } from 'react';
import { 
  ArrowLeft, 
  MapPin, 
  ChevronRight, 
  CreditCard, 
  CheckCircle2, 
  Ticket, 
  Coins, 
  Check, 
  MessageCircle, 
  FileText,
  ShoppingBag,
  Clock,
  Wallet,
  X
} from 'lucide-react';
import { StoreProduct } from '../types';
import { MOCK_ADDRESSES } from './AddressListView';
import { ActionButton } from './ui/Button';

interface CheckoutItem {
    product: StoreProduct;
    spec: string;
    quantity: number;
}

interface StoreCheckoutViewProps {
  items: CheckoutItem[]; 
  onBack: () => void;
  onViewOrder?: (orderId: string, extras: any) => void;
}

const StoreCheckoutView: React.FC<StoreCheckoutViewProps> = ({ items, onBack, onViewOrder }) => {
  // Steps: confirm (fill info) -> cashier (select payment) -> paying (processing) -> success
  const [step, setStep] = useState<'confirm' | 'cashier' | 'paying' | 'success'>('confirm');
  
  const [usePoints, setUsePoints] = useState(false);
  const [agreed, setAgreed] = useState(true);
  
  const [invoiceMode, setInvoiceMode] = useState<'none' | 'personal' | 'company'>('none');
  const [invoiceData, setInvoiceData] = useState({
      name: '',
      company: '',
      taxId: ''
  });

  // Generated Order ID
  const [orderId, setOrderId] = useState('');

  const orderType = items[0]?.product?.type || 'physical';

  const subtotal = items.reduce((acc, item) => {
      const price = parseFloat(item.product.price.replace(/,/g, ''));
      return acc + price * item.quantity;
  }, 0);
  
  const shippingFee = 0; 
  const couponDiscount = 50; 
  const pointsDiscount = usePoints ? 20 : 0;
  const finalTotal = subtotal + shippingFee - couponDiscount - pointsDiscount;

  const handleSubmitOrder = () => {
      if (!agreed) return alert('请先阅读并同意服务协议');
      if (invoiceMode === 'personal' && !invoiceData.name) return alert('请填写个人发票姓名');
      if (invoiceMode === 'company' && (!invoiceData.company || !invoiceData.taxId)) return alert('请完整填写企业发票信息');
      
      // Simulate Order Creation
      const newOrderId = `BAIC-${Date.now().toString().slice(-8)}`;
      setOrderId(newOrderId);
      setStep('cashier');
  };

  const handlePaymentSuccess = () => {
      setStep('success');
  };

  if (step === 'success') {
      return (
          <div className="absolute inset-0 z-[300] bg-white flex flex-col items-center justify-center p-10 animate-in zoom-in-95 duration-300">
              <div className="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mb-8">
                  <CheckCircle2 size={44} className="text-[#10B981]" />
              </div>
              <h2 className="text-[24px] font-bold text-[#111] mb-2">支付成功</h2>
              <div className="text-[14px] text-gray-400 mb-10 text-center leading-relaxed">
                  订单已进入处理流程<br/>您可以在“我的订单”中查看物流进度
              </div>
              
              <div className="bg-[#F9FAFB] rounded-3xl p-8 w-full mb-10 border border-gray-100">
                  <div className="text-center">
                      <div className="text-[13px] text-gray-400 mb-1">支付金额</div>
                      <div className="text-[36px] font-bold font-oswald text-[#111] mb-6">¥{finalTotal.toLocaleString()}</div>
                  </div>
                  <div className="w-full h-px bg-gray-200 mb-6" />
                  <div className="space-y-3 px-2">
                      <div className="flex justify-between text-[13px]">
                          <span className="text-gray-400 font-medium">订单编号</span>
                          <span className="text-[#111] font-bold font-oswald tracking-tight">{orderId}</span>
                      </div>
                      <div className="flex justify-between text-[13px]">
                          <span className="text-gray-400 font-medium">交易时间</span>
                          <span className="text-[#111] font-bold">刚刚</span>
                      </div>
                  </div>
              </div>

              <div className="w-full space-y-3">
                  <ActionButton 
                    label="查看订单详情" 
                    className="w-full"
                    onClick={() => onViewOrder?.(orderId, { price: finalTotal.toLocaleString(), type: orderType })}
                  />
                  <ActionButton 
                    label="回到商城" 
                    variant="outline" 
                    className="w-full"
                    onClick={onBack} 
                  />
              </div>
          </div>
      );
  }

  return (
    <div className="absolute inset-0 z-[250] bg-[#F5F7FA] flex flex-col animate-in slide-in-from-right duration-300">
      {/* Checkout Header */}
      <div className="pt-[54px] px-5 pb-3 flex items-center justify-between bg-white border-b border-gray-100 shrink-0 z-50">
        <button onClick={onBack} className="w-10 h-10 -ml-2 rounded-full flex items-center justify-center active:bg-gray-50 transition-colors">
            <ArrowLeft size={24} className="text-[#111]" />
        </button>
        <div className="text-[17px] font-bold text-[#111]">确认订单</div>
        <div className="w-10" />
      </div>

      {/* Checkout Content */}
      <div className="flex-1 overflow-y-auto no-scrollbar pb-[140px] space-y-3 pt-3">
          {/* Address */}
          <div className="bg-white mx-4 rounded-2xl p-5 shadow-sm border border-white flex gap-4 active:bg-gray-50 transition-colors">
              <div className="w-10 h-10 rounded-full bg-[#F5F7FA] flex items-center justify-center text-[#111] shrink-0 mt-0.5"><MapPin size={20} /></div>
              <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1.5">
                      <span className="text-[16px] font-bold text-[#111]">{MOCK_ADDRESSES[0].name}</span>
                      <span className="text-[14px] text-gray-400 font-oswald">{MOCK_ADDRESSES[0].phone}</span>
                      <span className="bg-[#111] text-white text-[9px] px-1.5 py-0.5 rounded font-bold uppercase">Default</span>
                  </div>
                  <div className="text-[13px] text-gray-500 leading-snug">{MOCK_ADDRESSES[0].address}</div>
              </div>
              <ChevronRight size={18} className="text-gray-300 mt-2.5" />
          </div>

          {/* Product List */}
          <div className="bg-white mx-4 rounded-2xl p-5 shadow-sm border border-white">
              <div className="text-[11px] font-bold text-gray-400 mb-5 flex items-center gap-2 uppercase tracking-widest">
                  <ShoppingBag size={12} /> Baic Official Store
              </div>
              <div className="space-y-6">
                  {items.map((item, idx) => (
                      <div key={idx} className="flex gap-4">
                          <div className="w-[72px] h-[72px] bg-[#F5F7FA] rounded-xl overflow-hidden shrink-0 border border-gray-100">
                              <img src={item.product.image} className="w-full h-full object-cover" />
                          </div>
                          <div className="flex-1 flex flex-col justify-between py-0.5">
                              <div className="text-[14px] font-bold text-[#111] line-clamp-1 leading-snug">{item.product.title}</div>
                              <div className="flex items-center justify-between">
                                  <div className="text-[11px] text-gray-400 bg-gray-50 px-2 py-0.5 rounded font-bold uppercase">{item.spec}</div>
                                  <div className="text-[12px] text-gray-300 font-bold font-oswald">x{item.quantity}</div>
                              </div>
                              <div className="text-[15px] font-bold font-oswald text-[#111]">¥{item.product.price}</div>
                          </div>
                      </div>
                  ))}
              </div>
          </div>

          {/* Coupons & Points */}
          <div className="bg-white mx-4 rounded-2xl overflow-hidden shadow-sm border border-white">
              <div className="flex items-center justify-between p-5 border-b border-gray-50 active:bg-gray-50 transition-colors">
                  <div className="flex items-center gap-3">
                      <Ticket size={18} className="text-[#111]" />
                      <span className="text-[14px] font-bold text-[#111]">优惠券</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                      <span className="text-[13px] text-[#FF6B00] font-bold">-¥50.00</span>
                      <ChevronRight size={16} className="text-gray-300" />
                  </div>
              </div>
              <div className="flex items-center justify-between p-5">
                  <div className="flex items-center gap-3">
                      <Coins size={18} className="text-[#111]" />
                      <div className="flex flex-col">
                          <span className="text-[14px] font-bold text-[#111]">积分抵扣</span>
                          <span className="text-[11px] text-gray-400">可用 2,450 积分，最高抵扣 <span className="font-oswald font-bold">¥20</span></span>
                      </div>
                  </div>
                  <button 
                    onClick={() => setUsePoints(!usePoints)}
                    className={`w-[44px] h-[24px] rounded-full transition-all relative flex items-center px-1 ${
                        usePoints ? 'bg-[#111]' : 'bg-gray-200'
                    }`}
                  >
                      <div className={`w-[18px] h-[18px] bg-white rounded-full shadow-sm transition-transform duration-300 transform ${
                          usePoints ? 'translate-x-[20px]' : 'translate-x-0'
                      }`} />
                  </button>
              </div>
          </div>

          {/* Invoice */}
          <div className="bg-white mx-4 rounded-2xl overflow-hidden shadow-sm border border-white">
              <div className="p-5 border-b border-gray-50 flex justify-between items-center">
                   <div className="flex items-center gap-3">
                      <FileText size={18} className="text-[#111]" />
                      <span className="text-[14px] font-bold text-[#111]">开具发票</span>
                  </div>
                  <div className="flex gap-2">
                      {['none', 'personal', 'company'].map(mode => (
                          <button 
                            key={mode}
                            onClick={() => setInvoiceMode(mode as any)}
                            className={`px-3 py-1.5 rounded-lg text-[11px] font-bold transition-all border ${
                                invoiceMode === mode 
                                    ? 'bg-[#111] text-white border-[#111]' 
                                    : 'bg-white text-gray-400 border-gray-100'
                            }`}
                          >
                              {mode === 'none' ? '不开' : mode === 'personal' ? '个人' : '企业'}
                          </button>
                      ))}
                  </div>
              </div>
              {invoiceMode !== 'none' && (
                  <div className="p-5 bg-[#F9FAFB] animate-in slide-in-from-top duration-300">
                      <div className="flex flex-col gap-3">
                          <input 
                            type="text"
                            placeholder={invoiceMode === 'personal' ? "请输入发票抬头姓名" : "单位全称"}
                            className="w-full h-11 bg-white rounded-xl px-4 text-[13px] outline-none border border-gray-100 focus:border-[#111] transition-all"
                          />
                          {invoiceMode === 'company' && (
                              <input 
                                type="text"
                                placeholder="纳税人识别号"
                                className="w-full h-11 bg-white rounded-xl px-4 text-[13px] font-oswald outline-none border border-gray-100 focus:border-[#111] transition-all"
                              />
                          )}
                      </div>
                  </div>
              )}
          </div>

          {/* Summary */}
          <div className="bg-white mx-4 rounded-2xl p-6 shadow-sm border border-white space-y-4">
              <div className="flex justify-between text-[13px]">
                  <span className="text-gray-400">商品总额</span>
                  <span className="text-[#111] font-bold font-oswald">¥{subtotal.toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-[13px]">
                  <span className="text-gray-400">运费</span>
                  <span className="text-green-500 font-bold">免运费</span>
              </div>
              <div className="flex justify-between text-[13px]">
                  <span className="text-gray-400">优惠券</span>
                  <span className="text-[#FF6B00] font-bold font-oswald">-¥{couponDiscount.toFixed(2)}</span>
              </div>
              {usePoints && (
                  <div className="flex justify-between text-[13px]">
                      <span className="text-gray-400">积分抵扣</span>
                      <span className="text-[#FF6B00] font-bold font-oswald">-¥{pointsDiscount.toFixed(2)}</span>
                  </div>
              )}
              <div className="pt-4 border-t border-gray-50 flex justify-between items-center">
                  <span className="text-[14px] font-bold text-[#111]">实付款</span>
                  <span className="text-[22px] font-bold font-oswald text-[#FF6B00]">¥{finalTotal.toLocaleString()}</span>
              </div>
          </div>

          {/* Agreement */}
          <div className="px-8 flex items-start gap-3 pb-6">
              <button 
                onClick={() => setAgreed(!agreed)}
                className={`mt-0.5 w-4 h-4 rounded border transition-all flex items-center justify-center shrink-0 ${
                    agreed ? 'bg-[#111] border-[#111] text-white' : 'bg-white border-gray-300'
                }`}
              >
                  {agreed && <Check size={12} strokeWidth={4} />}
              </button>
              <div className="text-[11px] text-gray-400 leading-relaxed">
                  我已阅读并同意 <span className="text-[#111] font-bold">《商城协议》</span> 及隐私条款。
              </div>
          </div>
      </div>

      {/* Bottom Action Bar */}
      <div className="bg-white border-t border-gray-100 px-6 pt-3 pb-[34px] flex items-center shadow-[0_-8px_30px_rgba(0,0,0,0.06)] z-[60]">
          <div className="flex flex-col mr-6">
              <span className="text-[10px] text-gray-400 font-bold uppercase tracking-tight">Total</span>
              <div className="flex items-baseline gap-0.5 text-[#FF6B00] font-oswald leading-none">
                  <span className="text-[14px] font-bold">¥</span>
                  <span className="text-[28px] font-bold">{finalTotal.toLocaleString()}</span>
              </div>
          </div>
          <ActionButton 
            label="提交订单" 
            onClick={handleSubmitOrder} 
            className="flex-1 w-full"
          />
      </div>

      {/* Cashier Modal */}
      {(step === 'cashier' || step === 'paying') && (
          <CashierModal 
            orderId={orderId} 
            amount={finalTotal} 
            onClose={() => setStep('confirm')} 
            onPaySuccess={handlePaymentSuccess}
            isPaying={step === 'paying'}
            onStartPayment={() => setStep('paying')}
          />
      )}
    </div>
  );
};

// Internal Component: Cashier Modal
const CashierModal: React.FC<{ 
    orderId: string, 
    amount: number, 
    onClose: () => void, 
    onPaySuccess: () => void,
    isPaying: boolean,
    onStartPayment: () => void
}> = ({ orderId, amount, onClose, onPaySuccess, isPaying, onStartPayment }) => {
    const [timeLeft, setTimeLeft] = useState(900); // 15 minutes in seconds
    const [selectedMethod, setSelectedMethod] = useState<'wechat' | 'alipay' | 'card'>('wechat');

    useEffect(() => {
        const timer = setInterval(() => {
            setTimeLeft(prev => {
                if (prev <= 0) {
                    clearInterval(timer);
                    return 0;
                }
                return prev - 1;
            });
        }, 1000);
        return () => clearInterval(timer);
    }, []);

    useEffect(() => {
        if (isPaying) {
            const t = setTimeout(() => {
                onPaySuccess();
            }, 2000);
            return () => clearTimeout(t);
        }
    }, [isPaying]);

    const formatTime = (seconds: number) => {
        const m = Math.floor(seconds / 60);
        const s = seconds % 60;
        return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
    };

    return (
        <div className="absolute inset-0 z-[300] flex flex-col justify-end">
            <div className="absolute inset-0 bg-black/60 backdrop-blur-sm animate-in fade-in duration-300" onClick={onClose} />
            <div className="bg-white w-full rounded-t-[32px] relative z-10 animate-in slide-in-from-bottom duration-300 pb-[34px] flex flex-col overflow-hidden shadow-2xl">
                {/* Cashier Header */}
                <div className="px-5 py-4 flex items-center justify-between border-b border-gray-50">
                    <button onClick={onClose} className="p-2 -ml-2 rounded-full active:bg-gray-50">
                        <X size={20} className="text-[#111]" />
                    </button>
                    <div className="text-[17px] font-bold text-[#111]">收银台</div>
                    <div className="w-9" />
                </div>

                <div className="p-6 flex flex-col items-center">
                    <div className="text-[13px] text-gray-500 font-medium mb-1 flex items-center gap-1.5">
                        <Clock size={14} className="text-[#FF6B00]" />
                        支付剩余时间 <span className="text-[#FF6B00] font-oswald tracking-wide">{formatTime(timeLeft)}</span>
                    </div>
                    <div className="flex items-baseline gap-1 text-[#111] mb-8">
                        <span className="text-[20px] font-bold">¥</span>
                        <span className="text-[48px] font-bold font-oswald leading-none tracking-tight">{amount.toLocaleString()}</span>
                    </div>

                    <div className="w-full space-y-3 mb-8">
                        <PaymentRow 
                            selected={selectedMethod === 'wechat'} 
                            onClick={() => setSelectedMethod('wechat')} 
                            icon={<div className="bg-[#07C160] p-1.5 rounded-lg text-white"><MessageCircle size={20} fill="white" /></div>}
                            label="微信支付" 
                            subLabel="推荐使用，安全快捷"
                        />
                        <PaymentRow 
                            selected={selectedMethod === 'alipay'} 
                            onClick={() => setSelectedMethod('alipay')} 
                            icon={<div className="bg-[#1677FF] p-1.5 rounded-lg text-white"><CreditCard size={20} fill="white" /></div>}
                            label="支付宝" 
                            subLabel="数亿用户的选择"
                        />
                        <PaymentRow 
                            selected={selectedMethod === 'card'} 
                            onClick={() => setSelectedMethod('card')} 
                            icon={<div className="bg-[#111] p-1.5 rounded-lg text-white"><Wallet size={20} /></div>}
                            label="找人代付" 
                            subLabel="发送给好友帮忙买单"
                        />
                    </div>

                    <ActionButton 
                        label={`确认支付 ¥${amount.toLocaleString()}`} 
                        loading={isPaying} 
                        onClick={onStartPayment}
                        className="w-full"
                    />
                </div>
            </div>
        </div>
    );
};

const PaymentRow: React.FC<{ selected: boolean, onClick: () => void, icon: any, label: string, subLabel?: string }> = ({ selected, onClick, icon, label, subLabel }) => (
    <div onClick={onClick} className={`flex items-center justify-between p-4 rounded-2xl cursor-pointer transition-all border ${selected ? 'bg-[#F5F7FA] border-[#111]' : 'bg-white border-gray-100'}`}>
        <div className="flex items-center gap-4">
            {icon}
            <div>
                <div className="text-[15px] font-bold text-[#111]">{label}</div>
                {subLabel && <div className="text-[11px] text-gray-400 mt-0.5">{subLabel}</div>}
            </div>
        </div>
        <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center transition-all ${selected ? 'bg-[#111] border-[#111] text-white' : 'border-gray-200'}`}>
            {selected && <Check size={12} strokeWidth={4} />}
        </div>
    </div>
);

export default StoreCheckoutView;