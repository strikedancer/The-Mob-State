#!/usr/bin/env python3
"""
Create a simple test video file with actual video frames
Uses moviepy to create a proper MP4 video
"""
import os

OUTPUT_DIR = 'client/assets/videos/crimes'
os.makedirs(OUTPUT_DIR, exist_ok=True)

def create_test_video():
    """Create a simple test video with text and fade effect"""
    try:
        from moviepy.editor import TextClip, ColorClip, CompositeVideoClip
        from moviepy.video.fx import fadein, fadeout
        
        print("📹 Creating test video for pickpocket crime...")
        
        # Create black background (10 seconds)
        background = ColorClip(size=(640, 480), color=(0, 0, 0), duration=10)
        
        # Create text overlay
        title = TextClip("ZAKKENROLLEN", fontsize=50, color='white', font='Arial-Bold')
        title = title.set_pos('center').set_duration(10)
        title = fadein(title, 1).fadeout(1)
        
        subtitle = TextClip("Crime in Progress...", fontsize=30, color='yellow', font='Arial')
        subtitle = subtitle.set_pos(('center', 350)).set_duration(10)
        subtitle = fadein(subtitle, 1).fadeout(1)
        
        # Composite video
        video = CompositeVideoClip([background, title, subtitle])
        
        # Write video file
        output_file = f"{OUTPUT_DIR}/pickpocket_crime.mp4"
        print(f"  Writing video to: {output_file}")
        
        video.write_videofile(
            output_file,
            fps=30,
            codec='libx264',
            audio=False,
            preset='ultrafast',
            logger=None  # Suppress moviepy logs
        )
        
        filesize = os.path.getsize(output_file) / 1024  # KB
        print(f"✅ Video created successfully! ({filesize:.1f} KB)")
        return True
        
    except ImportError:
        print("❌ moviepy not installed. Installing...")
        import subprocess
        subprocess.check_call(['pip', 'install', 'moviepy'])
        print("✅ moviepy installed. Please run script again.")
        return False
    except Exception as e:
        print(f"❌ Error creating video: {e}")
        return False

if __name__ == "__main__":
    print("\n" + "="*60)
    print("🎬 Test Video Generator")
    print("="*60 + "\n")
    
    if create_test_video():
        print("\n" + "="*60)
        print("✅ Done! Rebuild Flutter app to test the video.")
        print("="*60)
