import tkinter as tk
from tkinter import filedialog, messagebox
import os
import sounddevice as sd
import numpy as np
import soundfile as sf

def record_audio(duration, fs):
    print("Recording...")
    audio = sd.rec(int(duration * fs), samplerate=fs, channels=1, dtype='float32')
    sd.wait()
    print("Recording finished.")
    audio = audio.flatten()
    if np.max(np.abs(audio)) > 0:
        audio = audio / np.max(np.abs(audio))  # Normalize
    return audio

def auto_trim_by_chunks(audio_np, fs, chunk_size_ms=50, threshold=0.02):
    """
    Trims leading and trailing silence without destroying internal cadence.
    Finds the first and last chunk that exceeds the threshold relative to the peak.
    """
    chunk_size_samples = int(fs * chunk_size_ms / 1000)
    num_chunks = len(audio_np) // chunk_size_samples
    
    max_amp = np.max(np.abs(audio_np))
    if max_amp == 0:
        return audio_np
        
    abs_audio = np.abs(audio_np)
    
    first_idx = 0
    last_idx = len(audio_np)
    
    # Find start
    for i in range(num_chunks):
        start_idx = i * chunk_size_samples
        end_idx = (i + 1) * chunk_size_samples
        chunk = abs_audio[start_idx:end_idx]
        if np.max(chunk) > (max_amp * threshold):
            first_idx = max(0, start_idx - int(fs * 0.3)) # keep 300ms padding
            break
            
    # Find end
    for i in range(num_chunks - 1, -1, -1):
        start_idx = i * chunk_size_samples
        end_idx = (i + 1) * chunk_size_samples
        chunk = abs_audio[start_idx:end_idx]
        if np.max(chunk) > (max_amp * threshold):
            last_idx = min(len(audio_np), end_idx + int(fs * 0.3)) # keep 300ms padding
            break
            
    return audio_np[first_idx:last_idx]

def save_audio(audio, fs, filename):
    sf.write(filename, audio, fs)
    print(f"Audio saved as {os.path.basename(filename)}")

def main():
    duration = 2  # seconds
    fs = 44100  # Hz
    
    # SDK Framework Paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root_dir = os.path.dirname(script_dir)
    rec_path = os.path.join(root_dir, "audio_raw")
    resources_dir = os.path.join(root_dir, "resources")
    
    if not os.path.exists(rec_path):
        os.makedirs(rec_path)
        
    # Always open file dialog, default to resources dir
    root = tk.Tk()
    root.withdraw()
    file = filedialog.askopenfilename(initialdir=resources_dir, title="Select Script File", filetypes=[(".txt", "*")])
    if not file:
        return
        
    with open(file, 'r') as f:
        lines = f.readlines()
        
    print(f"Loaded script: {os.path.basename(file)}")
    print(f"Output directory: {rec_path}\n")
    
    for line in lines:
        line = line.strip()
        # Skip empty lines and headers
        if not line or line.startswith('-') or line.startswith('['):
            continue
            
        # Just in case they add (Speak:) tags back in the future
        filename = line.split(' (Speak:')[0].strip()
        
        output_file = os.path.join(rec_path, f"{filename}.ogg")
        
        # Skip if already recorded (helps if user takes a break and restarts the script)
        if os.path.exists(output_file):
            continue
            
        print(f"\n--- Recording: {line} ---")
        audio = record_audio(duration, fs)
        trimmed_audio = auto_trim_by_chunks(audio, fs, 50, 0.02)
        save_audio(trimmed_audio, fs, output_file)
        
    print("\n===============================")
    print("Recording Session Complete!")
    print("===============================\n")

if __name__ == "__main__":
    main()
