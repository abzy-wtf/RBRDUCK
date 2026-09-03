import os
import re
import tkinter as tk
from tkinter import filedialog
from pathlib import Path

def main():
    print("===============================================")
    print("   RBRDUCK Agnostic Pacenote Script Generator")
    print("===============================================\n")

    root = tk.Tk()
    root.withdraw()
    
    print("Please select your RBR 'Plugins/Pacenote/config' folder...")
    config_dir = filedialog.askdirectory(title="Select your Plugins/Pacenote/config folder")
    
    if not config_dir:
        print("No directory selected. Exiting.")
        return
        
    config_path = Path(config_dir)
    
    # Create output directory inside resources
    output_dir = Path.cwd().parent / "resources" / "pacenote scripts" / "agnostic_scripts"
    
    # Fallback if run directly from the RBRDUCK root folder instead of the scripts folder
    if Path.cwd().name.lower() == "rbrduck":
        output_dir = Path.cwd() / "resources" / "pacenote scripts" / "agnostic_scripts"
        
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Regex to find sound= or sounds= in INI files, capturing the path
    sound_pattern = re.compile(r'^\s*sounds?\s*=\s*(.+)$', re.IGNORECASE)
    
    master_sounds = set()
    script_counter = 1
    
    ini_files = list(config_path.rglob('*.ini'))
    print(f"Found {len(ini_files)} .ini files. Processing...\n")
    
    for ini_file in ini_files:
        sounds_in_file = set()
        try:
            with open(ini_file, 'r', encoding='utf-8', errors='ignore') as f:
                for line in f:
                    match = sound_pattern.match(line)
                    if match:
                        # Extract the path, e.g. Audio\Speech\eng\easy_left.ogg
                        full_sound_path = match.group(1).strip()
                        
                        # Extract just the filename without extension (e.g. easy_left)
                        sound_name = Path(full_sound_path).stem
                        
                        # Clean up any trailing quotes or commas just in case
                        sound_name = sound_name.replace('"', '').replace(',', '').strip()
                        
                        if sound_name:
                            sounds_in_file.add(sound_name)
                            master_sounds.add(sound_name)
        except Exception as e:
            print(f"Error reading {ini_file}: {e}")
            
        if sounds_in_file:
            # Generate a specific script for this INI file
            safe_name = ini_file.stem
            out_filename = output_dir / f"{script_counter:02d}-{safe_name}-script.txt"
            
            with open(out_filename, 'w', encoding='utf-8') as f:
                for sound in sorted(sounds_in_file):
                    f.write(f"{sound}\n")
                    
            script_counter += 1
            print(f"Generated {out_filename.name} ({len(sounds_in_file)} calls)")
            
    if master_sounds:
        master_file = output_dir / "00-master-script.txt"
        with open(master_file, 'w', encoding='utf-8') as f:
            for sound in sorted(master_sounds):
                f.write(f"{sound}\n")
                
        print(f"\n--> Generated MASTER SCRIPT: 00-master-script.txt ({len(master_sounds)} unique calls)")
        print(f"--> All generated scripts saved to: {output_dir}")
    else:
        print("\nNo audio calls found in any .ini files.")

if __name__ == "__main__":
    main()
