import os
import glob
import soundfile as sf
import numpy as np

def calculate_rms(audio):
    if len(audio) == 0: return 0
    return 20 * np.log10(np.sqrt(np.mean(audio**2)) + 1e-10)

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root_dir = os.path.dirname(script_dir)
    source_dir = os.path.join(root_dir, "audio_raw")
    target_dir = os.path.join(root_dir, "audio_normalized")
    target_rms_dbfs = -4.6

    if not os.path.exists(source_dir):
        print(f"Source directory not found: {source_dir}")
        print("Please run 02-recordAudio.py first to generate raw audio.")
        return

    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    files = glob.glob(os.path.join(source_dir, "*.ogg"))
    print(f"Found {len(files)} files to normalize.")

    for f in files:
        basename = os.path.basename(f)
        try:
            audio, fs = sf.read(f)
        except Exception as e:
            print(f"Error reading {basename}: {e}")
            continue

        if len(audio) == 0:
            print(f"Skipping empty file {basename}")
            continue

        current_rms = calculate_rms(audio)
        
        # Calculate the gain multiplier
        gain_db = target_rms_dbfs - current_rms
        gain_multiplier = 10 ** (gain_db / 20)

        # Apply gain
        normalized_audio = audio * gain_multiplier

        output_path = os.path.join(target_dir, basename)
        sf.write(output_path, normalized_audio, fs)
        
    print("\n===============================")
    print("Normalization complete!")
    print(f"Files saved to: {target_dir}")
    print("===============================\n")

if __name__ == "__main__":
    main()
