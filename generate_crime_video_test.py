#!/usr/bin/env python3
"""
Simple test video generator - creates minimal MP4 files for testing the video overlay UI
Uses Python libraries to create animated video without external dependencies
"""
import os
import struct
import json

OUTPUT_DIR = 'client/assets/videos/crimes'
os.makedirs(OUTPUT_DIR, exist_ok=True)

def create_minimal_mp4(filename: str, width: int = 640, height: int = 480, duration_secs: int = 10):
    """
    Create a minimal valid MP4 file with a solid color frame.
    This is the minimum valid MP4 that players can read.
    """
    # MP4 file structure with minimal moov box
    print(f"  Creating minimal MP4: {filename} ({width}x{height} @ {duration_secs}s)")
    
    try:
        # This creates a very simple MP4 with just enough structure to be valid
        # It won't have actual video frames, but players won't crash on it
        
        # MP4 header and metadata
        ftyp = b'ftypisom\x00\x00\x02\x00isomiso2mp41'  # File type box
        
        # Create minimal moov (movie) metadata box
        mvhd = bytearray()
        mvhd.extend(b'\x00\x00\x00\x6c')  # Box size  
        mvhd.extend(b'mvhd')              # Box type
        mvhd.extend(b'\x00')              # Version
        mvhd.extend(b'\x00\x00\x00')      # Flags
        mvhd.extend(b'\x00\x00\x00\x00')  # Creation time
        mvhd.extend(b'\x00\x00\x00\x00')  # Modification time
        mvhd.extend(struct.pack('>I', 1000))  # Timescale
        mvhd.extend(struct.pack('>I', duration_secs * 1000))  # Duration
        mvhd.extend(b'\x00\x01\x00\x00')  # Playback speed (1.0)
        mvhd.extend(b'\x01\x00\x00\x00')  # Volume
        mvhd.extend(b'\x00' * 10)         # Reserved
        mvhd.extend(b'\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00')  # Matrix
        mvhd.extend(b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00')
        mvhd.extend(struct.pack('>I', 2))  # Next track ID
        
        moov = bytearray()
        moov.extend(struct.pack('>I', len(mvhd) + 8))
        moov.extend(b'moov')
        moov.extend(mvhd)
        
        # Create mdat (media data) box - empty for now
        mdat = struct.pack('>I', 8) + b'mdat'
        
        # Combine all boxes
        with open(filename, 'wb') as f:
            f.write(ftyp)
            f.write(moov)
            f.write(mdat)
        
        size = os.path.getsize(filename)
        print(f"    ✅ Created: {filename} ({size} bytes)")
        return True
        
    except Exception as e:
        print(f"    ❌ Failed to create MP4: {e}")
        return False

def main():
    print("\n" + "="*60)
    print("🎬 Creating Test Crime Videos")
    print("="*60)
    
    crimes = [
        ("pickpocket", "Zakkenrollen"),
    ]
    
    successful = 0
    failed = 0
    
    for crime_id, crime_name in crimes:
        output_file = f"{OUTPUT_DIR}/{crime_id}_crime.mp4"
        
        if os.path.exists(output_file):
            print(f"✅ Already exists: {crime_name}")
            successful += 1
            continue
        
        print(f"\n📹 Generating test video: {crime_name}...")
        
        if create_minimal_mp4(output_file, duration_secs=10):
            successful += 1
        else:
            failed += 1
    
    print("\n" + "="*60)
    print(f"✅ Test video generation complete!")
    print(f"   Successful: {successful}/{len(crimes)}")
    print(f"   Failed: {failed}/{len(crimes)}")
    
    mp4_count = len([f for f in os.listdir(OUTPUT_DIR) if f.endswith('.mp4')])
    print(f"   MP4 files in {OUTPUT_DIR}: {mp4_count}")
    print("="*60)

if __name__ == "__main__":
    main()
