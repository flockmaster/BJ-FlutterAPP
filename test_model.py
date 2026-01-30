
import requests
import base64
import json
import os

# Update with your API Key
API_KEY = "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"
# 使用免费的 Gemini 2.0 Flash
MODEL = "google/gemini-2.0-flash-exp:free"

PROMPT = """
# 角色定位
你是一位经验丰富的汽车诊断顾问，擅长用**简洁专业**的语言向车主解释仪表盘状态。

# 判断流程（严格按顺序执行）

## Step 1: 观察转速表
- 仔细查看转速表(RPM/r/min)的指针位置
- **如果指针指向0或接近0** → 车辆未启动（钥匙在ON档或ACC档）
- **如果指针明显大于0**（如500-8000转） → 发动机已启动

## Step 2: 统计故障灯数量
数一数仪表盘上**同时亮起的故障指示灯总数**（不论颜色）:
- 机油灯、电瓶灯、发动机故障灯、胎压灯、刹车灯、ABS灯、安全带灯等

## Step 3: 综合判定车辆状态（核心逻辑）

### 情况A：转速 = 0 且 故障灯数量 ≥ 3个
**→ 判定为「自检中」**  
- 原因：车辆刚通电时会进行仪表盘自检，所有传感器会模拟故障状态，导致多个灯同时点亮
- 这是**正常现象**，不是真实故障

### 情况B：转速 = 0 且 故障灯数量 = 1-2个
**→ 判定为「静态故障提示」**  
- 原因：仅个别灯亮起，说明存在特定的静态问题（如真的胎压低、车门未关等）
- 这是**真实故障**，需要处理

### 情况C：转速 > 0 且 有任何故障灯亮起
**→ 判定为「行驶中故障」**  
- 原因：发动机已启动，正常情况下故障灯应该熄灭，若仍亮起则是真实故障
- 这是**紧急情况**，需立即处理

## 特别强调（防止错误判断）
❌ **错误示范**: 转速0 + 发动机灯+胎压灯+刹车灯(3个) → 判定为"静态故障提示"  
✅ **正确判断**: 转速0 + 发动机灯+胎压灯+刹车灯(3个) → **必须判定为「自检中」**

# 输出格式（纯JSON，不要包含任何Markdown标记）

{
    "is_valid": true,
    "vehicle_state": "自检中 或 静态故障提示 或 行驶中故障",
    "fault_names": "用专业术语描述故障（如：发动机系统故障、胎压监测异常、制动系统警告）",
    "system_category": "系统分类（如：发动机系统、底盘系统、多系统自检）",
    "severity_label": "提示 或 警告 或 危险",
    "technical_analysis": "用简洁、专业的语言描述诊断结果，要求：
    1. 说明车辆当前状态（如：车辆正在行驶中 / 车辆处于通电未启动状态 / 系统正在进行自检）
    2. 描述检测到的故障灯（使用专业名称，如：发动机故障灯（黄色）、胎压监测警告灯（红色））
    3. 给出简要诊断结论（如：发动机系统可能存在异常 / 轮胎气压低于标准值 / 仪表盘自检正常）
    4. 保持专业但易懂，避免过度技术化的描述
    示例（自检）：'系统正在进行仪表盘自检，检测到发动机故障灯、电瓶指示灯、机油压力警告灯等多个指示灯同时点亮。这是车辆通电后的正常自检程序，启动后将自动熄灭。'
    示例（行驶故障）：'车辆正在行驶中，检测到发动机故障灯（黄色）亮起。这表明发动机系统可能存在异常，建议尽快靠边检查或前往服务站诊断。'
    示例（静态故障）：'车辆处于通电未启动状态，检测到胎压监测警告灯亮起。这提示轮胎气压可能低于标准值，建议启动前检查四轮胎压。'",
    "driving_suggestion": "给出专业、具体的建议（如：建议立即前往最近的授权服务站进行系统诊断 / 请检查四轮胎压并充气至标准值 / 这是正常的自检程序，无需处理）",
    "confidence_score": "95%"
}

# 关键要求
1. **转速和数量是判定依据**：先看转速，再数灯，然后套用上述规则
2. **禁止编造**：所有内容必须基于图片真实观察，不得虚构数据
3. **禁止格式标记**：不要输出```json或其他Markdown格式，直接返回纯JSON
4. **专业简洁并重**：使用准确的汽车术语，但表达要简洁明了，避免冗长的技术描述
5. **无法识别时**：如果图片模糊或不是仪表盘，返回 "is_valid": false
"""

def analyze_image(image_path):
    print(f"Analyzing {image_path}...")
    try:
        with open(image_path, "rb") as image_file:
            base64_image = base64.b64encode(image_file.read()).decode('utf-8')

        headers = {
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://baic.com",
            "X-Title": "BAIC Python Test",
        }

        data = {
            "model": MODEL,
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": PROMPT},
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{base64_image}"
                            }
                        }
                    ]
                }
            ],
            "temperature": 0.2,
        }

        response = requests.post("https://openrouter.ai/api/v1/chat/completions", headers=headers, json=data)
        
        if response.status_code == 200:
            result = response.json()
            content = result['choices'][0]['message']['content']
            print("\nResponse:")
            print(content)
        else:
            print(f"Error: {response.status_code} - {response.text}")

    except Exception as e:
        print(f"Exception: {e}")

if __name__ == "__main__":
    # Test with one of the images in assets
    image_paths = [
        "assets/故障灯1.jpg",
        "assets/故障灯2.jpg", 
        "assets/故障灯3.jpg"
    ]
    
    for path in image_paths:
        if os.path.exists(path):
            analyze_image(path)
            # Break after one for now to test validity
            break
        else:
            print(f"File not found: {path} (Skipping)")
