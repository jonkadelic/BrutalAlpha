# Brutal Alpha
A modification of Minecraft Alpha 1.1.2_01 based around improving combat, as well as a few QOL features where needed such as FOV sliders.

Uses [RetroMCP-Java](https://github.com/MCPHackers/RetroMCP-Java) to decompile, recompile, and re-obfuscate the game, as well as a modified version of [my own mappings for a1.1.2_01](https://github.com/jonkadelic/a1.1.2_01-official).

## Structure
At present, the project contains four directories:
- `data`: Contains the substitute mapping files to be used with RetroMCP-Java.
- `patch`: Contains patches to be applied to the decompiled source code.
- `script`: Contains scripts to set up the build environment, decompile the game, and regenerate the contents of `patch` and `src`.
- `src`: Contains files that should be copied to the source tree once the game has been decompiled. This includes the Gradle project files.

## Building
The build system uses patches for the decompiled a1.1.2_01 source code, which are applied using Bash shell scripts. These can be run under native Linux, or under something like WSL or Cygwin. I'll likely be moving to a Java-based solution in the future.

To set up the initial environment, run `script/setup.sh`, then to decompile the game and apply patches, run `script/decomp.sh`. This will generate a directory called `workspace`, which contains a pre-configured Gradle project that can be loaded in IntelliJ/Eclipse and run immediately.

To save your work, run `script/make_patches.sh`. This will create patches for any modified vanilla a1.1.2_01 source files, which are then stored in the `patch` directory to be re-applied next time the game is decompiled. Any files in `workspace` that are *not* modified vanilla source files will be copied to the `src` directory, to be copied over to the source tree next time the game is decompiled.

## Contributing
This is very early days for the project, so code contributions likely won't be accepted, but suggestions and advice are welcome.
