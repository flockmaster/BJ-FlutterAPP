
export interface CarVersion {
  id: string;
  name: string; // e.g., "Explorer Edition"
  badge: string;
  badgeColor: string;
  price: string;
  features: string[];
}

export interface StoreInfo {
  image: string;
  name: string;
  address: string;
  distance: string;
}

export interface CarModel {
  id: string; // e.g., "BJ40"
  name: string; // Display name
  fullName: string;
  subtitle: string;
  price: string;
  priceUnit?: string;
  backgroundImage: string;
  portraitImage?: string;
  heroVideo?: string; // New: Dynamic Video Background URL
  promoPrice: string;
  highlightImage: string;
  highlightText: string;
  vrImage: string;
  store?: StoreInfo;
  isPreview: boolean;
  releaseDate?: string;
  countdown?: {
    days: number;
    hours: number;
    minutes: number;
  };
  versions?: Record<string, CarVersion>;
  previewFeatures?: {
    icon: string;
    title: string;
    desc: string;
  }[];
}

export interface WishlistConfig {
  modelId: string;
  trimId: string;
  trimName: string;
  colorId: string;
  colorName: string;
  colorHex: string;
  interiorId: string; // New: Interior ID
  interiorName: string; // New: Interior Name
  interiorHex: string; // New: Interior Hex Color
  wheelId: string;
  wheelName: string;
  totalPrice: number;
  timestamp: number;
}

export interface ChatMessage {
  role: 'user' | 'model';
  text: string;
  timestamp: number;
}

export interface StoreProduct {
  id: string;
  title: string;
  price: string;
  image: string;
  originalPrice?: string;
  tags?: string[]; // e.g. ["新品", "特惠"]
  points?: number; // e.g. 200 (Max deduct 200 points)
  salesCount?: number; // For hot sellers logic if needed
  type?: 'physical' | 'virtual' | 'service'; // NEW: Product Type
  detailImages?: string[]; // NEW: Specific detail images for the product
}

export interface HeroSlide {
  image: string;
  title: string;
  subtitle: string;
}

export interface StoreFeature {
  id: string;
  title: string;
  subtitle: string;
  image: string;
  type: 'large' | 'small'; // large for left col, small for right col
}

export interface StoreSection {
  id: string;
  title: string;
  bannerImage: string;
  products: StoreProduct[];
}

export interface StoreCategory {
  id: string;
  name: string;
  slides: HeroSlide[];
  features?: StoreFeature[]; // 3-grid features
  hotProducts?: StoreProduct[]; // Top sellers list
  sections?: StoreSection[]; // Grouped sections like "Winter Special"
}

export type DiscoveryItemType = 'ad' | 'topic' | 'post' | 'video' | 'news' | 'article';

export interface DiscoveryContentBlock {
  type: 'text' | 'image' | 'header';
  value: string;
}

export interface DiscoveryItem {
  id: string;
  type: DiscoveryItemType;
  title: string;
  content?: string; // New: Full text content for social posts
  contentBlocks?: DiscoveryContentBlock[]; // For rich articles
  subtitle?: string;
  image: string; // Primary/Cover image
  images?: string[]; // New: For multi-image posts (1, 3, 6, 9 grid)
  tag?: string; // e.g. "预约试驾", "车主专享"
  tagColor?: string; // Hex color for the tag bg
  user?: {
    name: string;
    avatar: string;
    carModel?: string; // e.g. "L7", "BJ40"
    time?: string; // New: Publish time e.g. "2小时前"
    vipLevel?: number; // New: VIP Level 1-5
  };
  likes?: number;
  comments?: number; // New
  shares?: number; // New
  isVideo?: boolean;
}

export interface OfficialArticle {
  id: string;
  title: string;
  image: string;
  date: string;
  views: number;
  tag?: string; // New: For activity status or category
  points?: number; // New: For points reward
}

export interface OfficialSection {
  id: string;
  title: string;
  items: OfficialArticle[];
}

export interface ModItem {
  id: string;
  title: string;
  image: string;
  tags: string[];
  author: string;
  avatar: string;
  likes: number;
}

export interface ModService {
  id: string;
  title: string;
  iconName: 'case' | 'shop' | 'join' | 'kit';
  color: string;
}

export interface ModShop {
  id: string;
  name: string;
  image: string;
  rating: number;
  distance: string;
  tags: string[];
}

export interface QAItem {
  id: string;
  question: string;
  desc: string;
  tags: string[];
  answersCount: number;
  views: number;
  latestAnswerUser?: string;
  latestAnswerAvatar?: string;
}

export interface GoWildItem {
  id: string;
  type: 'route' | 'crossing' | 'camping';
  title: string;
  image: string;
  location?: string;
  distance?: string; // e.g. "120km"
  duration?: string; // e.g. "2天1夜"
  difficulty?: number; // 1-5 stars
  altitude?: string; // e.g. "4500m"
  tags?: string[];
  likes?: number;
}

export interface GoWildData {
    weekendRoutes: GoWildItem[];
    crossingChallenges: GoWildItem[];
    campingSpots: GoWildItem[];
}
