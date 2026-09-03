Note: An understanding of how the Pacenotes folder system works is requisite.



While JanneMod V3 is the bedrock of modern RBR co-driver packages, we can't forget the rest of them. What this script does is:

1. Asks for the current Plugins/Pacenote/config layout

2. Scans `pacenote` and `ranges` for all .ini files

3. Reads the mapping for .ogg files

4. Outputs them into a new script file

From there, you are able to follow the audio recording and normalization routine. **DO NOT** use the stencil script. You will need to manually create your own folder within */template/Plugins/Pacenote/config/sounds/* (or use the provided My Custom RBRDUCK Mod template), and copy the recorded audio into it. 

If the audio files require a number at the end to satisfy the .ini files, you can run this PowerShell command to quickly rename them (right-click anywhere in the */template/Plugins/Pacenote/config/sounds/[mod]* folder and select 'Open Powershell window here'):

`Get-ChildItem -File | Rename-Item -NewName { $_.BaseName + "1" + $_.Extension }`



You will also need to manually update line 2 of the PaceNote.ini file in */Pacenote/* if you are using a different folder name than the provided template.

Additionally, any of the audio that belongs in any the /Audio/ subfolders will need to be manually sorted.

From there, the rest of the steps remain pretty much the same. Copy over the config files from the existing co-driver, paste them into your mod, and then paste the new Audio and Plugins folder to your RBR directory.
