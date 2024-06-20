Better Ship Part Flips
======================
created by Freschu, maintained and updated by rux616

Version: 1.0.0

Table Of Contents
-----------------
- Better Ship Part Flips
    - Table Of Contents
- Overview
    - Summary
    - Compatibility
    - Known Issues
- Installation
    - Archive Invalidation
    - Requirements
    - Recommendations
    - Upgrading
    - Mod Manager
    - Manual (NOT RECOMMENDED)
- License
- Credits and Acknowledgements
- Contact


Overview
========

Summary
-------
(Additional flips of vanilla parts that seemed missing. Mostly conforms to vanilla ship builder grid.)

Adds additional flips of vanilla parts. A pure ESM mod, the flips are done using the vanilla data, no additional meshes are added. Largely stays within the grid established so far.

Better Ship Part Flips is fully compatible with Better Ship Part Snaps (https://www.nexusmods.com/starfield/mods/5698) and they can be used together.

I plan on updating Better Ship Part Flips as often as I can, but making flips is tedious and requires care and lots of testing to ensure a good result. Be sure to check the CHANGELOG above for more info about parts changed and added.

(For mod authors): Data structures modified or added: COBJ, GBFM, FLST, PKIN, CELL, MSTT, STMP

Compatibility
-------------
General mod compatibility is limited, Better Ship Part Flips has to modify some of the data that also contains properties such as hull, mass, etc.

Known Issues
------------
None.


Installation
============

Archive Invalidation
--------------------
Make sure your `StarfieldCustom.ini` file in the "Documents\My Games\Starfield" folder (or your profile folder if using a mod manager and profiles) contains the following:

    [Archive]
    bInvalidateOlderFiles=1
    sResourceDataDirsFinal=

Requirements
------------
None, if using Starfield v1.12.32.0 or above.

Recommendations
---------------
NOTE: StarUI Ship Builder v1.2 doesn't work with Starfield v1.11.36+, so if you're running that version of the mod with that version of Starfield, you'll have to go without for the moment.

- StarUI Ship Builder (https://www.nexusmods.com/starfield/mods/6402): This mod arranges the categories in a vertical list and adds some filtering options, both of which greatly enhance usability.

Upgrading
---------
When upgrading non-major versions (for example v2.something to v2.something-else), you don't need to do anything except replace the installed mod files.

When upgrading major versions (for example v1.whatever to v2.whatever), you need to do a clean install:
- Open the game and load your latest save
- Save your game, then quit
- Uninstall the previous version of the plugin and all its files
- Open the game and load your last save
- You will see a warning about missing the plugin you just uninstalled, choose to continue
- Save your game again, then quit
- Install the new version of the plugin

Mod Manager
-----------
Download and install the archive with either Mod Organizer 2 (https://github.com/ModOrganizer2/modorganizer/releases) (version 2.5.0 or later) or Vortex (https://www.nexusmods.com/site/mods/1). I personally recommend Mod Organizer 2 (with the optional Root Builder (https://kezyma.github.io/?p=rootbuilder) plugin to use with SFSE or any other mod that requires files be put directly in the game's installation folder).

Manual (NOT RECOMMENDED)
------------------------
Extract the archive to your Starfield installation's "Data" folder (typically something like "C:\Games\SteamLibrary\steamapps\common\Starfield\Data"). Add the plugin file names to your plugins.txt file if they aren't already there, making sure the ones you want enabled are preceded with `*`.


License
=======
- All code files are copyright 2023, 2024 Dan Cassidy, and are licensed under the GPL v3.0 or later (https://www.gnu.org/licenses/gpl-3.0.en.html).
- All non-code files are copyright 2023, 2024 Dan Cassidy, and are licensed under the CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/) license.
- Original ESM file copyright 2023 Freschu.


Credits and Acknowledgements
============================
Freschu: For initially creating this mod
ElminsterAU: For xEdit and BSArch
Mod Organizer 2 team: For getting Mod Organizer 2 with Starfield support out the door so quickly
Nexus Mods: For mod hosting and for the Vortex Mod Manager
Noggog: For Spriggit


Contact
=======
If you find a bug or have a question about the mod, please post it on the mod page at Nexus Mods (https://www.nexusmods.com/starfield/mods/5953), or in the GitHub project (https://github.com/rux616/starfield-better-ship-part-flips).

If you need to contact me personally, I can be reached through one of the following means:
- Nexus Mods: rux616 (https://www.nexusmods.com/users/124191) (Send a message via the "CONTACT" button.)
- Email: rux616-at-pm-dot-me (replace `-at-` with `@` and `-dot-` with `.`)
- Discord: rux616 (user ID 234489279991119873) - make sure to "@" me
    - Lively's Modding Hub (https://discord.gg/livelymods)
    - Nexus Mods (https://discord.gg/nexusmods)
    - Collective Modding (https://discord.gg/pF9U5FmD6w) ("🔧-chaotic-cognitions" channel)
    - Starfield Modding (https://discord.gg/6R4Yq5KjW2)
