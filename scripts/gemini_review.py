import os
import sys
import subprocess
import google.generativeai as genai
import argparse

# Configuration
# Ensure you have set the environment variable: export GEMINI_API_KEY="your_key"
API_KEY = os.getenv("GEMINI_API_KEY")

def setup_gemini():
    if not API_KEY:
        print("❌ Error: GEMINI_API_KEY environment variable not set.")
        sys.exit(1)
    genai.configure(api_key=API_KEY)

def get_git_diff(range_start="HEAD@{1}", range_end="HEAD"):
    """
    Get the git diff for the specified range.
    Defaults to the changes introduced by the last operation (e.g., merge/pull).
    """
    try:
        # Check if there are changes
        cmd = ["git", "diff", f"{range_start}..{range_end}", "--unified=0"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError:
        # Fallback for simple commits or if HEAD@{1} doesn't exist (fresh clone)
        return ""

def review_code(diff_content, model_name="gemini-pro"):
    """
    Sends the diff to Gemini for review.
    """
    model = genai.GenerativeModel(model_name)
    
    prompt = f"""
    You are a Senior Tech Lead reviewing code changes. 
    Analyze the following git diff and provide a concise code review.
    
    Focus on:
    1. Critical Bugs (Logic errors, Null Safety issues in Flutter/Dart).
    2. Security Vulnerabilities.
    3. Performance Bottlenecks.
    4. Code Style & Best Practices (clean code).
    
    If the code looks good, just say "✅ Code looks good."
    
    Git Diff:
    ```
    {diff_content[:30000]} 
    ```
    (Diff truncated to first 30k chars if longer)
    """
    
    # Generate content
    try:
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"❌ AI Review Failed: {str(e)}"

def main():
    parser = argparse.ArgumentParser(description="Gemini AI Code Reviewer")
    parser.add_argument("--diff-range", default="HEAD@{1}..HEAD", help="Git revision range to review (default: last action)")
    parser.add_argument("--watcher", action="store_true", help="Run in watcher mode to auto-pull and review")
    args = parser.parse_args()

    setup_gemini()

    if args.watcher:
        run_watcher_mode()
    else:
        # One-shot mode (e.g., triggered by Hook)
        run_one_shot_mode(args.diff_range)

def run_one_shot_mode(diff_range):
    print("🔍 Analyzing code changes...")
    
    # Parse range for git command
    if ".." in diff_range:
        start, end = diff_range.split("..")
    else:
        start, end = "HEAD~1", "HEAD"

    diff = get_git_diff(start, end)
    
    if not diff.strip():
        print("ℹ️  No changes detected in this range.")
        return

    print(f"📦 Diff Content Length: {len(diff)} chars")
    print("🤖 Asking Gemini for review...")
    
    review = review_code(diff)
    
    print("\n" + "="*20 + " GEMINI CODE REVIEW " + "="*20)
    print(review)
    print("="*60 + "\n")

def run_watcher_mode():
    import time
    print("👀 Starting Watcher Mode... (Checking every 60s)")
    
    while True:
        try:
            # 1. Fetch remote
            subprocess.run(["git", "fetch"], check=True, capture_output=True)
            
            # 2. Check status
            status = subprocess.run(["git", "status", "-uno"], capture_output=True, text=True).stdout
            
            if "Your branch is behind" in status:
                print("\n🚀 New code detected on remote! Pulling...")
                
                # Get current HEAD before pull to define range
                before_pull = subprocess.run(["git", "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
                
                # Pull
                subprocess.run(["git", "pull"], check=True)
                
                # Get new HEAD
                after_pull = subprocess.run(["git", "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
                
                # Review the range
                if before_pull != after_pull:
                    run_one_shot_mode(f"{before_pull}..{after_pull}")
            
        except Exception as e:
            print(f"⚠️ Error in watcher loop: {e}")
            
        time.sleep(60)

if __name__ == "__main__":
    main()
