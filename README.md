<img width="3840" height="2160" alt="image" src="https://github.com/user-attachments/assets/b9dbc652-f13b-4c55-8ce7-ab09113e9424" />

## RBR co-Driver Universal Creation Kit

The **Richard Burns Rally co-Driver Universal Creation Kit** (RBRDUCK) is an SDK-like tool that allows an end-user or mod creator to quickly and conveniently record their own custom co-driver mod calls for Richard Burns Rally in a Luppis/JanneMod V3 framework.

**RBRDUCK** includes all the resources required:

- a powershell script to install required python modules
- a python script to record the audio
- multiple pacenote script files to aid in recording
- a powershell script to accurately copy and distribute appropriate audio files for *all* 42 corner systems (as per JanneMod V3)
- a complete packaged framework to easily deploy after creation

This tool was inspired by and uses re-worked components of Wrench's ['Co-Driver Tools'](https://github.com/Wrench36/RBR-Co-Driver-Tools).

Because this uses JanneMod V3 as its foundation, there are no required edits to .ini files. Furthermore, this mod is designed to work with existing JanneMod V3 installations. So long as your game directory uses JanneMod V3, you can use this tool to create your own custom co-driver calls.

<img width="4045" height="2612" alt="scalesHelper-V3" src="https://github.com/user-attachments/assets/d881834c-a6f0-4348-a1d4-e0c1877a8a8b" />

### Requirements

- [JanneMod V3](https://luppisrbr.blogspot.com/p/compatible-co-driver-mods-v3.html) *Scroll down a little bit*
- [Python 3](https://www.python.org/downloads/)

### Demonstration

A YouTube video will be here.

## Quick Start Workflow

1. **Prep:** Within your Richard Burns install folder, create a new folder called 'Tools'.
2. **Download:** Download the latest release of RBRDUCK from the [releases page](https://github.com/abzy-wtf/RBRDUCK/releases) to the newly-created Tools folder.
3. **Extract:** Extract the contents of the downloaded release by right-clicking and choosing *'Extract to RBRDUCK\'*. You should now have *\Tools\RBRDUCK\\* within your RBR directory.
4. **Install:** Run `scripts/01-installRequirements.ps1` to ensure your Python environment is ready.
5. **Record:** Execute `scripts/02-recordAudio.py` and follow the prompts to record your pacenotes based on the provided Pacenote Script files. Run `scripts/03-normalizeAudio.py` to normalize your audio files.
6. **Package:** Execute `scripts/04-stencilDistribute.ps1` to automatically package your audio into a JanneMod corner system framework.
7. **Inject:** Copy the desired JanneMod V3 config files (`pacenote` and `ranges` folders) into *\Tools\RBRDUCK\template\Plugins\Pacenote\config\\*.
8. **Deploy:** Copy the generated framework into your RBR directory (`Audio` and `Plugins` folders).

##### Why RBRDUCK?

- With only 868 individual calls, it is now possible to create a voicepack covering all 42 cornering systems in a single evening, variants included.

- Democratizes custom pacenote generation; the end-user does not need to know the underlying back-end to create a voicepack.

- If you are multilingual or a non-native English speaker, this is the easiest way to record pacenotes in your native tongue.

- Because Janne took the time to develop an awesome framework.
