import { GoogleGenAI } from "@google/genai";
import { CarModel } from "../types";

// Always initialize directly using process.env.API_KEY as a named parameter per guidelines
const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });

export const generateChatResponse = async (
  userMessage: string, 
  currentCar: CarModel,
  history: {role: string, parts: {text: string}[]}[]
): Promise<string> => {
  // Use the pre-initialized ai instance
  if (!process.env.API_KEY) {
    return "抱歉，目前我无法连接到人工智能服务（缺少 API 密钥）。";
  }

  try {
    const systemInstruction = `你是一位热情专业的北京汽车（BAIC）AI 销售顾问。
    你目前正在协助一位正在查看"${currentCar.fullName}"的客户。
    
    以下是客户正在查看的车型详情：
    - 车型名称: ${currentCar.fullName}
    - 副标题: ${currentCar.subtitle}
    - 价格: ${currentCar.price} ${currentCar.priceUnit || ''}
    - 关键特性: ${currentCar.versions ? Object.values(currentCar.versions).map(v => v.features.join(', ')).join(' | ') : '硬派越野性能'}
    - 状态: ${currentCar.isPreview ? '即将发布' : '现车在售'}
    
    你的目标是回答客户关于该车型的问题，如果被问及可以对比其他车型，并鼓励 them 预约试驾或下定。
    请保持回答简洁（50字以内）且语气自然亲切，使用中文回答。
    `;

    // Select gemini-3-flash-preview for basic text tasks (simple Q&A)
    const model = 'gemini-3-flash-preview';
    
    const chat = ai.chats.create({
      model: model,
      config: {
        systemInstruction: systemInstruction,
      },
      history: history
    });

    const result = await chat.sendMessage({ message: userMessage });
    // Correctly access .text property (not as a function call)
    return result.text || "抱歉，我没有听清，请您再说一遍？";
  } catch (error) {
    console.error("Gemini API Error:", error);
    return "我现在连接服务器有些问题，请稍后再试。";
  }
};