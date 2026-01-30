
import React, { useState, useRef, useEffect } from 'react';
import { 
  ArrowLeft, 
  Image as ImageIcon, 
  MapPin, 
  Hash, 
  Smile, 
  X, 
  Loader2, 
  Video, 
  Type, 
  AlignLeft, 
  Plus, 
  Trash2,
  MoreVertical,
  HelpCircle,
  Tag,
  Coins,
  Heading
} from 'lucide-react';

interface CreatePostViewProps {
  type: 'post' | 'video' | 'question' | 'article';
  onBack: () => void;
  onPublish: () => void;
}

// Types for Article Blocks
// Added 'header' type
type ArticleBlockType = 'text' | 'image' | 'header';
interface ArticleBlock {
    id: string;
    type: ArticleBlockType;
    content: string; // Text content or Image URL
    caption?: string; // For images
}

const CreatePostView: React.FC<CreatePostViewProps> = ({ type, onBack, onPublish }) => {
  const [isPublishing, setIsPublishing] = useState(false);
  const bottomRef = useRef<HTMLDivElement>(null);

  // --- State for Standard Post ---
  const [postContent, setPostContent] = useState('');
  const [postImages, setPostImages] = useState<string[]>([]);

  // --- State for Article (Block-based Editor) ---
  const [articleTitle, setArticleTitle] = useState('');
  const [articleBlocks, setArticleBlocks] = useState<ArticleBlock[]>([
      { id: '1', type: 'text', content: '' } // Start with one text block
  ]);

  // --- State for Video ---
  const [videoTitle, setVideoTitle] = useState('');
  const [videoDesc, setVideoDesc] = useState('');
  const [videoFile, setVideoFile] = useState<string | null>(null);

  // --- State for Question ---
  const [questionTitle, setQuestionTitle] = useState('');
  const [questionDesc, setQuestionDesc] = useState('');
  const [questionTags, setQuestionTags] = useState<string[]>([]);

  // Scroll to bottom when adding new blocks
  useEffect(() => {
      if (type === 'article' && articleBlocks.length > 1) {
          bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
      }
  }, [articleBlocks.length, type]);

  // --- Handlers ---

  const handlePublish = () => {
      // Basic validation
      if (type === 'post' && !postContent && postImages.length === 0) return;
      if (type === 'article' && !articleTitle) return;
      if (type === 'question' && !questionTitle) return;
      if (type === 'video' && !videoFile) return;

      setIsPublishing(true);
      setTimeout(() => {
          setIsPublishing(false);
          onPublish();
      }, 1500);
  };

  // --- Article Logic ---
  const addArticleBlock = (blockType: ArticleBlockType) => {
      const newBlock: ArticleBlock = {
          id: Date.now().toString(),
          type: blockType,
          content: blockType === 'image' 
            ? `https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop&sig=${Math.random()}` 
            : ''
      };
      setArticleBlocks([...articleBlocks, newBlock]);
  };

  const updateBlock = (id: string, value: string, field: 'content' | 'caption' = 'content') => {
      setArticleBlocks(articleBlocks.map(b => 
          b.id === id ? { ...b, [field]: value } : b
      ));
  };

  const removeBlock = (id: string) => {
      if (articleBlocks.length <= 1) return;
      setArticleBlocks(articleBlocks.filter(b => b.id !== id));
  };

  // --- Standard Post Logic ---
  const handleAddPostImage = () => {
      if (postImages.length < 9) {
          const newImg = `https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=200&auto=format&fit=crop&sig=${Math.random()}`;
          setPostImages([...postImages, newImg]);
      }
  };

  // --- Video Logic ---
  const handleAddVideo = () => {
      setVideoFile('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=800&auto=format&fit=crop'); // Mock video thumbnail
  };

  // --- Renders ---

  const renderHeader = (title: string, isValid: boolean) => (
      <div className="pt-[54px] px-5 pb-3 flex justify-between items-center bg-white border-b border-gray-100 z-20 relative">
        <button onClick={onBack} className="text-[15px] text-[#111] font-medium px-2 -ml-2">
            取消
        </button>
        <div className="text-[17px] font-bold text-[#111]">{title}</div>
        <button 
            onClick={handlePublish}
            disabled={isPublishing || !isValid}
            className={`px-5 py-1.5 rounded-full text-[13px] font-bold transition-all flex items-center gap-2 ${
                isValid && !isPublishing
                ? 'bg-[#111] text-white active:scale-95' 
                : 'bg-gray-100 text-gray-400'
            }`}
        >
            {isPublishing && <Loader2 size={14} className="animate-spin" />}
            发布
        </button>
      </div>
  );

  // 1. Article Editor (Rich Text)
  const renderArticleEditor = () => (
      <div className="flex-1 flex flex-col h-full bg-white">
          {renderHeader('写文章', articleTitle.length > 0 && articleBlocks.length > 0)}
          
          <div className="flex-1 overflow-y-auto p-5 pb-[100px]">
              {/* Cover/Title Area */}
              <div className="mb-8">
                  <input 
                      type="text"
                      placeholder="请输入文章标题 (必填)"
                      value={articleTitle}
                      onChange={(e) => setArticleTitle(e.target.value)}
                      className="w-full text-[24px] font-bold text-[#111] placeholder:text-gray-300 outline-none mb-4 leading-tight bg-transparent"
                  />
                  <div className="text-[12px] text-gray-400 flex items-center gap-2">
                      <div className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center">
                          <ImageIcon size={16} />
                      </div>
                      <span>设置封面图 (可选)</span>
                  </div>
              </div>
              
              <div className="w-full h-[1px] bg-gray-100 mb-6" />

              {/* Blocks */}
              <div className="space-y-6">
                  {articleBlocks.map((block, index) => (
                      <div key={block.id} className="relative group">
                          {/* Delete Handle */}
                          {articleBlocks.length > 1 && (
                              <button 
                                onClick={() => removeBlock(block.id)}
                                className="absolute -right-8 top-2 p-2 text-gray-300 hover:text-red-500 opacity-0 group-hover:opacity-100 transition-opacity"
                              >
                                  <Trash2 size={16} />
                              </button>
                          )}

                          {block.type === 'header' && (
                              <div className="flex gap-3 items-start">
                                  <div className="w-1 h-6 bg-[#111] mt-1 shrink-0" />
                                  <input 
                                      type="text"
                                      value={block.content}
                                      onChange={(e) => updateBlock(block.id, e.target.value)}
                                      placeholder="请输入小标题"
                                      className="w-full text-[18px] font-bold text-[#111] placeholder:text-gray-300 outline-none bg-transparent"
                                      autoFocus
                                  />
                              </div>
                          )}

                          {block.type === 'text' && (
                              <textarea 
                                  value={block.content}
                                  onChange={(e) => {
                                      updateBlock(block.id, e.target.value);
                                      e.target.style.height = 'auto';
                                      e.target.style.height = e.target.scrollHeight + 'px';
                                  }}
                                  placeholder="请输入正文内容..."
                                  className="w-full text-[16px] text-[#333] leading-relaxed outline-none resize-none overflow-hidden min-h-[60px] bg-transparent"
                                  rows={1}
                                  autoFocus={index === articleBlocks.length - 1}
                              />
                          )}

                          {block.type === 'image' && (
                              <div className="rounded-xl overflow-hidden bg-[#F9FAFB] border border-gray-100">
                                  <img src={block.content} className="w-full h-auto max-h-[300px] object-cover" />
                                  <div className="p-3 bg-gray-50 flex items-center gap-3 border-t border-gray-100">
                                      <div className="w-5 h-5 bg-white border border-gray-200 rounded flex items-center justify-center text-gray-400 shrink-0">
                                          <Type size={10} />
                                      </div>
                                      <input 
                                          type="text"
                                          placeholder="添加图片说明（选填）"
                                          value={block.caption || ''}
                                          onChange={(e) => updateBlock(block.id, e.target.value, 'caption')}
                                          className="flex-1 bg-transparent text-[13px] text-[#333] outline-none placeholder:text-gray-400"
                                      />
                                  </div>
                              </div>
                          )}
                      </div>
                  ))}
                  <div ref={bottomRef} />
              </div>
          </div>

          {/* Improved Bottom Toolbar for Articles */}
          <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-100 px-5 pt-3 pb-[34px] z-30 shadow-[0_-4px_20px_rgba(0,0,0,0.03)]">
              <div className="flex items-center justify-around">
                  <ToolButton 
                      icon={AlignLeft} 
                      label="正文" 
                      onClick={() => addArticleBlock('text')} 
                  />
                  <ToolButton 
                      icon={Heading} 
                      label="标题" 
                      onClick={() => addArticleBlock('header')} 
                  />
                  <ToolButton 
                      icon={ImageIcon} 
                      label="图片" 
                      onClick={() => addArticleBlock('image')} 
                  />
                  <div className="w-[1px] h-6 bg-gray-200 mx-2" />
                  <ToolButton icon={Hash} label="话题" />
              </div>
          </div>
      </div>
  );

  // 2. Video Editor
  const renderVideoEditor = () => (
      <div className="flex-1 flex flex-col h-full bg-white">
          {renderHeader('发布视频', !!videoFile && !!videoTitle)}
          
          <div className="flex-1 overflow-y-auto p-5">
              {/* Video Uploader */}
              <div 
                onClick={!videoFile ? handleAddVideo : undefined}
                className={`w-full aspect-video rounded-2xl mb-6 relative overflow-hidden flex flex-col items-center justify-center transition-all ${
                    videoFile ? 'bg-black' : 'bg-gray-50 border-2 border-dashed border-gray-200 active:bg-gray-100'
                }`}
              >
                  {videoFile ? (
                      <>
                          <img src={videoFile} className="w-full h-full object-cover opacity-80" />
                          <div className="absolute inset-0 flex items-center justify-center">
                              <div className="w-14 h-14 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center">
                                  <Video size={24} className="text-white fill-white" />
                              </div>
                          </div>
                          <button 
                            onClick={(e) => { e.stopPropagation(); setVideoFile(null); }}
                            className="absolute top-2 right-2 w-8 h-8 bg-black/50 text-white rounded-full flex items-center justify-center"
                          >
                              <X size={16} />
                          </button>
                      </>
                  ) : (
                      <>
                          <div className="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center text-gray-400 mb-2">
                              <Video size={24} />
                          </div>
                          <span className="text-[13px] text-gray-400 font-medium">点击上传视频</span>
                      </>
                  )}
              </div>

              <input 
                  type="text"
                  placeholder="填写标题，更容易被推荐..."
                  value={videoTitle}
                  onChange={(e) => setVideoTitle(e.target.value)}
                  className="w-full text-[18px] font-bold text-[#111] placeholder:text-gray-300 outline-none mb-4"
              />
              
              <textarea 
                  value={videoDesc}
                  onChange={(e) => setVideoDesc(e.target.value)}
                  placeholder="描述一下视频内容，添加话题让更多人看到..."
                  className="w-full text-[15px] text-[#333] h-[100px] outline-none resize-none placeholder:text-gray-400"
              />

              <div className="flex flex-wrap gap-2 mt-4">
                  <ToolItem icon={Hash} label="话题" />
                  <ToolItem icon={MapPin} label="位置" />
              </div>
          </div>
      </div>
  );

  // 3. Question Editor
  const renderQuestionEditor = () => (
      <div className="flex-1 flex flex-col h-full bg-white">
          {renderHeader('提问题', !!questionTitle)}
          
          <div className="flex-1 overflow-y-auto p-5">
              <div className="bg-orange-50 rounded-xl p-3 mb-6 flex items-start gap-2">
                  <HelpCircle size={16} className="text-[#FF6B00] mt-0.5 shrink-0" />
                  <div className="text-[12px] text-orange-800 leading-relaxed">
                      请准确描述您遇到的问题，更有利于大神解答。优秀的提问可获得积分奖励。
                  </div>
              </div>

              <input 
                  type="text"
                  placeholder="一句话描述您的问题 (必填)"
                  value={questionTitle}
                  onChange={(e) => setQuestionTitle(e.target.value)}
                  className="w-full text-[18px] font-bold text-[#111] placeholder:text-gray-300 outline-none mb-4 pb-4 border-b border-gray-100"
              />
              
              <textarea 
                  value={questionDesc}
                  onChange={(e) => setQuestionDesc(e.target.value)}
                  placeholder="请详细描述问题背景、车型信息、故障现象等..."
                  className="w-full text-[15px] text-[#333] h-[150px] outline-none resize-none placeholder:text-gray-400 leading-relaxed"
              />

              <div className="flex gap-2 mb-6">
                  {/* Mock Image Upload for Question Context */}
                  <button className="w-20 h-20 bg-gray-50 rounded-xl flex flex-col items-center justify-center text-gray-400 border border-gray-100">
                      <ImageIcon size={20} />
                      <span className="text-[10px] mt-1">添加图片</span>
                  </button>
              </div>

              <div className="border-t border-gray-100 pt-4">
                  <div className="flex justify-between items-center mb-3">
                      <span className="text-[14px] font-bold text-[#111]">添加标签</span>
                      <span className="text-[12px] text-gray-400">精准匹配专家</span>
                  </div>
                  <div className="flex flex-wrap gap-2">
                      {['维修保养', '故障求助', '改装', '选车'].map(tag => (
                          <button 
                            key={tag}
                            onClick={() => {
                                if (questionTags.includes(tag)) {
                                    setQuestionTags(questionTags.filter(t => t !== tag));
                                } else {
                                    setQuestionTags([...questionTags, tag]);
                                }
                            }}
                            className={`px-3 py-1.5 rounded-full text-[12px] transition-all border ${
                                questionTags.includes(tag) 
                                    ? 'bg-[#111] text-white border-[#111]' 
                                    : 'bg-white text-gray-500 border-gray-200'
                            }`}
                          >
                              {tag}
                          </button>
                      ))}
                  </div>
              </div>
              
              <div className="border-t border-gray-100 mt-6 pt-4 flex justify-between items-center">
                  <div className="flex items-center gap-2">
                      <Coins size={18} className="text-[#FFD700]" />
                      <span className="text-[14px] font-bold text-[#111]">悬赏积分</span>
                  </div>
                  <div className="flex items-center gap-2 text-gray-400 text-[12px]">
                      <span>0 积分</span>
                      <ArrowLeft size={12} className="rotate-180" />
                  </div>
              </div>
          </div>
      </div>
  );

  // 4. Standard Post Editor (Feed)
  const renderPostEditor = () => (
      <div className="flex-1 flex flex-col h-full bg-white">
          {renderHeader('发动态', postContent.length > 0 || postImages.length > 0)}
          
          <div className="flex-1 overflow-y-auto p-5">
              <textarea 
                value={postContent}
                onChange={(e) => setPostContent(e.target.value)}
                className="w-full h-[120px] text-[16px] text-[#111] placeholder:text-gray-400 outline-none resize-none leading-relaxed"
                placeholder="分享这一刻的新鲜事..."
                autoFocus
              />

              {/* Grid Images */}
              <div className="grid grid-cols-3 gap-2 mb-6">
                  {postImages.map((img, idx) => (
                      <div key={idx} className="aspect-square relative rounded-[12px] overflow-hidden group">
                          <img src={img} className="w-full h-full object-cover" />
                          <button 
                            onClick={() => setPostImages(postImages.filter((_, i) => i !== idx))}
                            className="absolute top-1 right-1 w-6 h-6 bg-black/50 rounded-full flex items-center justify-center text-white"
                          >
                              <X size={14} />
                          </button>
                      </div>
                  ))}
                  {postImages.length < 9 && (
                      <button 
                        onClick={handleAddPostImage}
                        className="aspect-square bg-[#F7F8FA] rounded-[12px] flex flex-col items-center justify-center text-gray-400 active:bg-gray-200 transition-colors"
                      >
                          <ImageIcon size={24} />
                          <span className="text-[10px] mt-1">添加图片</span>
                      </button>
                  )}
              </div>

              {/* Tools */}
              <div className="space-y-1 border-t border-gray-50 pt-2">
                  <ToolItem icon={Hash} label="添加话题" />
                  <ToolItem icon={MapPin} label="所在位置" />
                  <ToolItem icon={Smile} label="表情/贴纸" />
              </div>
          </div>
      </div>
  );

  return (
    <div className="absolute inset-0 z-[200] bg-white flex flex-col animate-in slide-in-from-bottom duration-300">
        {type === 'article' && renderArticleEditor()}
        {type === 'video' && renderVideoEditor()}
        {type === 'question' && renderQuestionEditor()}
        {type === 'post' && renderPostEditor()}
    </div>
  );
};

const ToolItem = ({ icon: Icon, label }: any) => (
    <button className="w-full flex items-center gap-3 py-3.5 px-2 active:bg-gray-50 rounded-xl transition-colors text-[#111]">
        <Icon size={20} />
        <span className="text-[14px] font-medium">{label}</span>
    </button>
);

const ToolButton = ({ icon: Icon, label, onClick }: any) => (
    <button 
        onClick={onClick}
        className="flex flex-col items-center gap-1 p-2 rounded-xl active:bg-gray-50 transition-colors w-[60px]"
    >
        <div className="w-8 h-8 rounded-full border border-gray-200 flex items-center justify-center text-[#333]">
            <Icon size={16} />
        </div>
        <span className="text-[10px] text-gray-500 font-medium">{label}</span>
    </button>
);

export default CreatePostView;
