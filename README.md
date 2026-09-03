## RBR co-Driver Universal Creation Kit

The Richard Burns Rally co-Driver Universal Creation Kit (RBRDUCK) is an SDK-like tool that allows an end-user to quickly and conveniently record their own custom co-driver calls for Richard Burns Rally in a JanneMod V3 framework.

RBRDUCK includes all the resources required:

- a powershell script to install required python modules
- a python script to record the audio
- multiple pacenote script files to aid in recording
- a powershell script to accurately copy and distribute all audio files for *all* 54 corner systems (as per JanneMod V3)
- a complete packaged framework to easily deploy after creation

This tool was inspired by and uses re-worked components of Wrench's 'Co-Driver Tools'.

Because this uses JanneMod V3 as its foundation, there are no required edits to .ini files. Furthermore, this mod is designed to work with existing JanneMod V3 installations. So long as your game directory uses JanneMod V3, you can use this tool to create your own custom co-driver calls.

It goes without saying that JanneMod V3 is required for this tool to work, as it only packages audio files.

## Quick Start Workflow

1. **Prep the Environment:** Within your Richard Burns install folder, create a new folder called 'Tools'.
2. **Download the Current Release:** Download the latest release of RBRDUCK from the [releases page](https://github.com/) to the newly-created Tools folder.
3. **Extract:** Extract the contents of the downloaded release by right-clicking and choosing *'Extract to RBRDUCK\'*. You should now have *\Tools\RBRDUCK\\* within your RBR directory.
4. **Install Dependencies:** Run `scripts/01-Install-Requirements.ps1` to ensure your Python environment is ready.
5. **Record:** Execute `scripts/02-recordAudio.py` and follow the prompts to record your pacenotes based on the provided Pacenote Script files. Run `scripts/03-normalizeAudio.py` to normalize your audio files.
6. **Package:** Execute `scripts/04-Stencil-Distribute.ps1` to automatically package your audio into a JanneMod corner system framework.
7. **Inject:** Copy the JanneMod V3 config files into *\Tools\RBRDUCK\Plugins\Pacenote\config\\*.
8. **Deploy:** Copy the generated framework into your RBR directory.
