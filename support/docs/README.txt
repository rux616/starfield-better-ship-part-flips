Better Ship Part Flips
======================
created by freschu, maintained and updated by rux616

Version: 1.2.0

Table Of Contents
-----------------
- Better Ship Part Flips
    - Table Of Contents
- Overview
    - Summary
    - Compatibility
    - Known Issues
- Installation
    - Load Order
    - Requirements
    - Recommendations
    - Upgrading
    - Mod Manager
    - Manual
    - Archive Invalidation
- License
- Credits and Acknowledgements
- Contact
- List of Modules
    - Cargo Holds
    - Fuel Tanks
    - Grav Drives
    - Reactors
    - Shields
    - Structural
    - Decorative Cargo
    - Decorative Fuel Tanks
    - Decorative Grav Drives
    - Decorative Reactors
    - Decorative Shields
    - Decorative Weapons (Ballistic)
    - Decorative Weapons (EM)
    - Decorative Weapons (Laser)
    - Decorative Weapons (Missile)
    - Decorative Weapons (Particle)


Overview
========

Summary
-------
(Additional flips of vanilla parts that seemed missing. Mostly conforms to vanilla ship builder grid.)

NOTE: Now requires the Ship Builder Categories (https://www.nexusmods.com/starfield/mods/7310) mod!

Adds additional flips of vanilla parts, thus far including shields, cargo holds, fuel tanks, grav drives, reactors, and structural parts. A pure ESM mod, the flips are done using the vanilla data, no additional meshes are added. Largely stays within the grid established so far. Also includes "decorative" versions of shields, cargo holds, fuel tanks, grav drives, reactors, and weapons.

Better Ship Part Flips is fully compatible with Better Ship Part Snaps (https://www.nexusmods.com/starfield/mods/5698) and they can be used together.

For a complete listing of all modules provided, please see the "List of Modules" section at the bottom of this document.

Compatibility
-------------
General mod compatibility is limited as Better Ship Part Flips has to modify some of the data that also contains properties such as hull, mass, etc. There are some patches available, either included in the installation archive if you're downloading from Nexus Mods, or as separate mods if you're using Bethesda.net Creations.

- "All ship parts unlevelled at all vendors (ESM)" by SKK50 [Nexus (https://www.nexusmods.com/starfield/mods/6060)]: [Patch Required] Depending on whether BSPF or this mod is set to higher priority, either some parts simply won't show up or will still have level or vendor requirements. Use the included compatibility patch. (checked 2024-08-12; version 002)
- "Avontech Shipyards" by kaosnyrb [Creations (https://creations.bethesda.net/en/starfield/details/32b36186-7136-41eb-8522-cba41fa271e2/Avontech_Shipyards) / Nexus (https://www.nexusmods.com/starfield/mods/8057)]: Fully compatible. (checked 2024-08-12; version 1.2.0)
- "Better Ship Part Snaps" by freschu/rux616 [Creations (https://creations.bethesda.net/en/starfield/details/81dc21ae-e497-441b-aaf9-b44b923d1401/Better_Ship_Part_Snaps) / Nexus (https://www.nexusmods.com/starfield/mods/5698)]: If using the Ship Colorize compatibility patch, there is an additional patch (included) that should be used to restore feature parity with Better Ship Part Snaps. Note the flips added by Better Ship Part Snaps don't all have any particularly enhanced snaps. (checked 2024-08-12; version 1.0.0)
- "DarkStar Astrodynamics" by WykkydGaming [Creations (https://creations.bethesda.net/en/starfield/details/cfca357a-7226-4cae-bd16-3575069dcf2e/DarkStar_Astrodynamics) / Nexus (https://www.nexusmods.com/starfield/mods/9458)]: Fully compatible. (checked 2024-08-12; version 4.1.1)
- "DerreTech" (NOT DerreTech Legacy!) by DerekM17x [Creations (https://creations.bethesda.net/en/starfield/details/d76f29e6-528a-4024-9099-14f445ee9fb6/DerreTech) / Nexus (https://www.nexusmods.com/starfield/mods/9185)]: Fully compatible. (checked 2024-08-12; version 1.9.5b)
- "Matilija's Aerospace" by matilija [Creations (https://creations.bethesda.net/en/starfield/details/df3bc774-c92c-4051-a51a-e2573f7175ed/Matilija_Aerospace_V3) / Nexus (https://www.nexusmods.com/starfield/mods/9293)]: Fully compatible. (checked 2024-08-12; version 3.0)
- "Ship Colorize" by DerekM17x [Creations (https://creations.bethesda.net/en/starfield/details/c6fcfa3e-3960-4361-91b0-a757b7d3b560/Ship_Colorize) / Nexus (https://www.nexusmods.com/starfield/mods/7003)]: [Patch Required] Changes made by Ship Colorize to the Dogstar StorMax 40/60 Cargo Holds won't show up or the flips will be weird, depending on which mod wins the conflict. Additionally, there are several modules that won't have their modified color changes available. Use the included compatibility patch. (checked 2024-08-12; version 1.1)
- "Ship Combat Revised" by Itheral [Creations - Habs (https://creations.bethesda.net/en/starfield/details/ec60f892-72e7-4bb7-88b0-61ccb904c397/Ship_Combat_Revised___Modules__amp__Habs) / Creations - Reactors (https://creations.bethesda.net/en/starfield/details/622c19d9-491f-4fcf-94fd-3ce20fa2e3c0/Ship_Combat_Revised___Reactors) / Creations - Thrusters (https://creations.bethesda.net/en/starfield/details/da6174c5-66a5-459c-bc38-f337adaddf3b/Ship_Thrusters_Empowered) / Creations - Weapons (https://creations.bethesda.net/en/starfield/details/3132cd66-68df-4a59-92f4-ee8769364cef/Ship_Combat_Revised___Weapons__amp__Shields) / Nexus (https://www.nexusmods.com/starfield/mods/9371)]: [Patch Required] Patches needed if you use the "Habs", "Reactors", "Weapons", or "Ship Thrusters Empowered" files. (checked 2024-08-15; version 1.42)
- "Ship Module Snap Expansion" by Gilibran [Nexus (https://www.nexusmods.com/starfield/mods/6029)]: Not compatible at all. (checked 2024-08-12; version 1.0.1)
- "Starfield Extended - Shields Rebalanced" by Gambit77 [Creations (https://creations.bethesda.net/en/starfield/details/fd87aa76-53ce-46ce-9825-9ec208dafce2/Starfield_Extended___Shields_Rebalanced) / Nexus (https://www.nexusmods.com/starfield/mods/6238)]: [Patch Required] Shields will either be missing flips or not have higher health, depending on which mod wins the conflict. Use the included compatibility patch. (checked 2024-08-12; version 1.00-ESL)
- "Tiger Shipyards Overhaul" by LJTIGER69 [Creations (https://creations.bethesda.net/en/starfield/details/1b733e93-c0f2-4e07-a28b-5413672da978/TIGER_SHIPYARDS_OVERHAUL) / Nexus (https://www.nexusmods.com/starfield/mods/8868)]: Fully compatible. (checked 2024-08-12; version 2.0.6)
- "TN's Expanded Cargo Holds" by TheOGTennessee [Nexus (https://www.nexusmods.com/starfield/mods/5957)]: [Patch Required] Cargo holds won't be at their advertised capacity otherwise. (checked 2024-08-12; version 1.1)
- "TN's Separated Categories" by TheOGTennessee [Creations (https://creations.bethesda.net/en/starfield/details/dd306a75-12bc-4829-bf32-ae50314889b1/TN__39_s_Separated_Categories) / Nexus (https://www.nexusmods.com/starfield/mods/7467)]: [Patch Required] Some of the enhanced structure pieces (radiators, specifically), won't be available without the included compatibility patch. (checked 2024-08-12; version 1.1)
- "TN's Ship Modifications All In One" by TheOGTennessee [Creations (https://creations.bethesda.net/en/starfield/details/08ed4d34-95f0-42a3-b654-5ade11a1af1e/TN__39_s_Ship_Modifications_All_in_One) / Nexus (https://www.nexusmods.com/starfield/mods/6376)]: [Patch Required] Decoratives will conflict, and also some cargo hold capacity will be different, depending on which mod wins the conflicts. There should be a compatibility patch. (checked 2024-04-16; version 2.0.2)
- "TN's Useful Ship Structure (Hull Buffs)" by TheOGTennessee [Nexus (https://www.nexusmods.com/starfield/mods/5836)]: [Patch Required] The patch makes sure that the new flips added have the matching amount of health (and/or other effects) as specified by the mod. (checked 2024-08-12; version 1.1)
- "Ultimate Shipyards Unlocked" by JustAnOrdinaryGuy [Nexus (https://www.nexusmods.com/starfield/mods/4723)]: [Patch Required] Incompatibilities with the All In One plugin, and the "No Level Requirements" and "Quest Rewards" modules from the modular version. Use the included compatibility patch/patches. (checked 2024-08-12; version 1.4)

Known Issues
------------
- Sometimes one or more ship modules will appear randomly rotated on your ship. This is purely cosmetic and a save/reload almost always fixes it.


Installation
============

Load Order
----------
For best results, put this mod lower in your load order, followed by any patches.

Requirements
------------
- Ship Builder Categories (https://www.nexusmods.com/starfield/mods/7310)

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
Download and install the archive with either Mod Organizer 2 (https://github.com/ModOrganizer2/modorganizer/releases) (version 2.5.2 or later) or Vortex (https://www.nexusmods.com/site/mods/1). I personally recommend Mod Organizer 2 (with the optional Root Builder (https://kezyma.github.io/?p=rootbuilder) plugin to use with Starfield Script Extender or any other mod that requires files be put directly in the game's installation folder).

Manual
------
Unsupported. If you know what you're doing, you don't need my help. And if you don't know what you're doing, I want nothing to do with your hand-crafted artisanal dumpster fire of an install. _Use a mod manager._

Archive Invalidation
--------------------
Make sure your `StarfieldCustom.ini` file in the "Documents\My Games\Starfield" folder (or your profile folder if using a mod manager and profiles) contains the following:

    [Archive]
    bInvalidateOlderFiles=1
    sResourceDataDirsFinal=


License
=======
- All code files are copyright 2023, 2024 Dan Cassidy, and are licensed under the GPL v3.0 or later (https://www.gnu.org/licenses/gpl-3.0.en.html).
- All non-code files are copyright 2023, 2024 Dan Cassidy, and are licensed under the CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/) license.
- Original ESM file copyright 2023 freschu.


Credits and Acknowledgements
============================
freschu: For initially creating this mod
ElminsterAU: For xEdit and BSArch
Mod Organizer 2 team: For getting Mod Organizer 2 with Starfield support out the door so quickly
Nexus Mods: For mod hosting and for the Vortex Mod Manager
Noggog: For Spriggit


Contact
=======
If you find a bug or have a question about the mod, please post it on the mod page at Nexus Mods (https://www.nexusmods.com/starfield/mods/5953), or in the GitHub repository (https://github.com/rux616/starfield-better-ship-part-flips).

If you need to contact me personally, I can be reached through one of the following means:
- Nexus Mods: rux616 (https://www.nexusmods.com/users/124191) (Send a message via the "CONTACT" button.)
- Email: rux616-at-pm-dot-me (replace `-at-` with `@` and `-dot-` with `.`)
- Discord: rux616 (user ID 234489279991119873) - make sure to "@" me
    - Lively's Modding Hub (https://discord.gg/livelymods)
    - Nexus Mods (https://discord.gg/nexusmods)
    - Collective Modding (https://discord.gg/pF9U5FmD6w) ("🔧-chaotic-cognitions" channel)
    - Starfield Modding (https://discord.gg/6R4Yq5KjW2)


List of Modules
===============

Cargo Holds
-----------
- Dogstar StorMax 30 Cargo Hold (v1.1.0)
- Dogstar StorMax 40 Cargo Hold (v1.1.0)
- Dogstar StorMax 50 Cargo Hold (v1.1.0)
- Dogstar StorMax 60 Cargo Hold (v1.1.0)
- Panoptes da Gama 1000 Cargo Hold (v1.1.0)
- Panoptes da Gama 1000 Shielded Cargo Hold (v1.1.0)
- Panoptes da Gama 1010 Cargo Hold (v1.1.0)
- Panoptes da Gama 1010 Shielded Cargo Hold (v1.1.0)
- Panoptes da Gama 1020 Cargo Hold (v1.1.0)
- Panoptes Polo 2000 Cargo Hold (v1.1.0)
- Panoptes Polo 2010 Cargo Hold (v1.1.0)
- Panoptes Polo 2020 Cargo Hold (v1.1.0)
- Panoptes Polo 2030 Cargo Hold (v1.1.0)
- Protectorate Caravel V101 Cargo Hold (v1.1.0)
- Protectorate Caravel V101 Shielded Cargo Hold (v1.1.0)
- Protectorate Caravel V102 Cargo Hold (v1.1.0)
- Protectorate Caravel V102 Shielded Cargo Hold (v1.1.0)
- Protectorate Caravel V103 Cargo Hold (v1.1.0)
- Protectorate Caravel V104 Cargo Hold (v1.1.0)
- Protectorate Galleon S201 Cargo Hold (v1.1.0)
- Protectorate Galleon S202 Cargo Hold (v1.1.0)
- Protectorate Galleon S203 Cargo Hold (v1.1.0)
- Protectorate Galleon S204 Cargo Hold (v1.1.0)
- Sextant Ballast 100CM Cargo Hold (v1.1.0)
- Sextant Ballast 100CM Shielded Cargo Hold (v1.1.0)
- Sextant Ballast 200CM Cargo Hold (v1.1.0)
- Sextant Ballast 200CM Shielded Cargo Hold (v1.1.0)
- Sextant Ballast 300CM Cargo Hold (v1.1.0)
- Sextant Ballast 400CM Cargo Hold (v1.1.0)
- Sextant Hauler 10T Cargo Hold (v1.1.0)
- Sextant Hauler 10ST Shielded Cargo Hold (v1.1.0)
- Sextant Hauler 20T Cargo Hold (v1.1.0)
- Sextant Hauler 30T Cargo Hold (v1.1.0)
- Sextant Hauler 40T Cargo Hold (v1.1.0)

Fuel Tanks
----------
- Ballistic 100G Fuel Tank (v1.1.0)
- Ballistic 200G Fuel Tank (v1.1.0)
- Ballistic 300G Fuel Tank (v1.1.0)
- Ballistic 400G Fuel Tank (v1.1.0)
- Ballistic 500T Fuel Tank (v1.1.0)
- Ballistic 600T Fuel Tank (v1.1.0)
- Ballistic 700T Fuel Tank (v1.1.0)
- Ballistic 800T-A Fuel Tank (v1.1.0)
- Ballistic 800T-B Fuel Tank (v1.1.0)
- Ballistic 900T Fuel Tank (v1.1.0)
- Dogstar Ulysses M10 Fuel Tank (v1.1.0)
- Dogstar Ulysses M20 Fuel Tank (v1.1.0)
- Dogstar Ulysses M30 Fuel Tank (v1.1.0)
- Dogstar Ulysses M40 Fuel Tank (v1.1.0)
- Dogstar Ulysses M50 Fuel Tank (v1.1.0)
- Dogstar Atlas H10 Fuel Tank (v1.1.0)
- Dogstar Atlas H20 Fuel Tank (v1.1.0)
- Dogstar Atlas H30 Fuel Tank (v1.1.0)
- Dogstar Atlas H40 Fuel Tank (v1.1.0)
- Nautilus Titan 350 Fuel Tank (v1.1.0)
- Nautilus Titan 450 Fuel Tank (v1.1.0)
- Nautilus Titan 550 Fuel Tank (v1.1.0)

Grav Drives
-----------
- DeepCore Helios 100 Grav Drive (v1.1.0)
- DeepCore Helios 200 Grav Drive (v1.1.0)
- DeepCore Helios 300 Grav Drive (v1.1.0)
- DeepCore Helios 400 Grav Drive (v1.1.0)
- DeepCore Aurora 11G Grav Drive (v1.1.0)
- DeepCore Aurora 12G Grav Drive (v1.1.0)
- DeepCore Aurora 13G Grav Drive (v1.1.0)
- DeepCore Apollo GV100 Grav Drive (v1.1.0)
- DeepCore Apollo GV200 Grav Drive (v1.1.0)
- DeepCore Apollo GV300 Grav Drive (v1.1.0)
- Nova Galactic NG150 Grav Drive (v1.1.0)
- Nova Galactic NG160 Grav Drive (v1.1.0)
- Nova Galactic NG170 Grav Drive (v1.1.0)
- Nova Galactic NG200 Grav Drive (v1.1.0)
- Nova Galactic NG210 Grav Drive (v1.1.0)
- Nova Galactic NG220 Grav Drive (v1.1.0)
- Nova Galactic NG300 Grav Drive (v1.1.0)
- Nova Galactic NG320 Grav Drive (v1.1.0)
- Nova Galactic NG340 Grav Drive (v1.1.0)
- Reladyne R-1000 Alpha Grav Drive (v1.1.0)
- Reladyne R-2000 Alpha Grav Drive (v1.1.0)
- Reladyne R-3000 Alpha Grav Drive (v1.1.0)
- Reladyne R-4000 Alpha Grav Drive (v1.1.0)
- Reladyne RD-1000 Beta Grav Drive (v1.1.0)
- Reladyne RD-2000 Beta Grav Drive (v1.1.0)
- Reladyne RD-3000 Beta Grav Drive (v1.1.0)
- Reladyne J-51 Gamma Grav Drive (v1.1.0)
- Reladyne J-52 Gamma Grav Drive (v1.1.0)
- Reladyne J-53 Gamma Grav Drive (v1.1.0)
- Slayton Aerospace SGD 1100 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 1200 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 1300 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 1400 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 2100 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 2200 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 2300 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 3100 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 3200 Grav Drive (v1.1.0)
- Slayton Aerospace SGD 3300 Grav Drive (v1.1.0)
- Vanguard Recon Grav Drive (v1.1.0)

Reactors
--------
- Amun Dunn 330T Stellarator Reactor (v1.1.0)
- Amun Dunn 340T Stellarator Reactor (v1.1.0)
- Amun Dunn 350T Stellarator Reactor (v1.1.0)
- Amun Dunn 360T Stellarator Reactor (v1.1.0)
- Amun Dunn 370T Stellarator Reactor (v1.1.0)
- Amun Dunn 380T Stellarator Reactor (v1.1.0)
- Amun Dunn Theta Pinch A9 Reactor (v1.1.0)
- Amun Dunn Theta Pinch B9 Reactor (v1.1.0)
- Amun Dunn Theta Pinch C9 Reactor (v1.1.0)
- Amun Dunn Theta Pinch D9 Reactor (v1.1.0)
- Amun Dunn Z-Machine 1000 Reactor (v1.1.0)
- Amun Dunn Z-Machine 2000 Reactor (v1.1.0)
- Amun Dunn Z-Machine 2020 Reactor (v1.1.0)
- Amun Dunn Z-Machine 3000 Reactor (v1.1.0)
- Amun Dunn Z-Machine 4000 Reactor (v1.1.0)
- Deep Core DC301 Fast Ignition Reactor (v1.1.0)
- Deep Core DC302 Fast Ignition Reactor (v1.1.0)
- Deep Core DC303 Fast Ignition Reactor (v1.1.0)
- Deep Core Fusor DC401 Reactor (v1.1.0)
- Deep Core Fusor DC402 Reactor (v1.1.0)
- Deep Core Fusor DC403 Reactor (v1.1.0)
- Deep Core Spheromak DC201 Reactor (v1.1.0)
- Deep Core Spheromak DC202 Reactor (v1.1.0)
- Dogstar 101DS Mag Inertial Reactor (v1.1.0)
- Dogstar 102DS Mag Inertial Reactor (v1.1.0)
- Dogstar 103DS Mag Inertial Reactor (v1.1.0)
- Dogstar 104DS Mag Inertial Reactor (v1.1.0)
- Dogstar 114MM Toroidal Reactor (v1.1.0)
- Dogstar 124MM Toroidal Reactor (v1.1.0)
- Dogstar 134MM Toroidal Reactor (v1.1.0)
- Dogstar 144MM Toroidal Reactor (v1.1.0)
- Dogstar 154MM Toroidal Reactor (v1.1.0)
- Dogstar 164MM Toroidal Reactor (v1.1.0)
- Dogstar SF10 Sheared Flow Reactor (v1.1.0)
- Dogstar SF20 Sheared Flow Reactor (v1.1.0)
- Dogstar SF30 Sheared Flow Reactor (v1.1.0)
- Dogstar SF40 Sheared Flow Reactor (v1.1.0)
- Xiang Ion Beam H-1010 Reactor (v1.1.0)
- Xiang Ion Beam H-1020 Reactor (v1.1.0)
- Xiang Ion Beam H-1030 Reactor (v1.1.0)
- Xiang Pinch 5Z Reactor (v1.1.0)
- Xiang Pinch 6Z Reactor (v1.1.0)
- Xiang Pinch 7Z Reactor (v1.1.0)
- Xiang Pinch 8A Reactor (v1.1.0)
- Xiang Pinch 8Z Reactor (v1.1.0)
- Xiang Tokamak X-050 Reactor (v1.1.0)
- Xiang Tokamak X-100 Reactor (v1.1.0)
- Xiang Tokamak X-120S Reactor (v1.1.0)
- Xiang Tokamak X-150 Reactor (v1.1.0)
- Xiang Tokamak X-200 Reactor (v1.1.0)
- Xiang Tokamak X-250 Reactor (v1.1.0)
- Xiang Tokamak X-300 Reactor (v1.1.0)

Shields
-------
- Dogstar Defender 11T Shield Generator (v1.1.0)
- Dogstar Defender 22T Shield Generator (v1.1.0)
- Dogstar Defender 28T Shield Generator (v1.1.0)
- Dogstar Defender 33T Shield Generator (v1.1.0)
- Dogstar Defender 44T Shield Generator (v1.1.0)
- Dogstar Guardian 101D Shield Generator (v1.1.0)
- Dogstar Guardian 102D Shield Generator (v1.1.0)
- Dogstar Guardian 103D Shield Generator (v1.1.0)
- Dogstar Guardian 104D Shield Generator (v1.1.0)
- Dogstar Protector 10S Shield Generator (v1.1.0)
- Dogstar Protector 20S Shield Generator (v1.1.0)
- Dogstar Protector 30S Shield Generator (v1.1.0)
- Dogstar Protector 40S Shield Generator (v1.1.0)
- Dogstar Protector 50S Shield Generator (v1.1.0)
- Dogstar Protector 60S Shield Generator (v1.1.0)
- Nautilus Bastille S80 Shield Generator (v1.1.0)
- Nautilus Bastille S81 Shield Generator (v1.1.0)
- Nautilus Bastille S82 Shield Generator (v1.1.0)
- Nautilus Bastille S83 Shield Generator (v1.1.0)
- Nautilus Bastille S84 Shield Generator (v1.1.0)
- Nautilus Fortress A1 Shield Generator (v1.1.0)
- Nautilus Fortress A2 Shield Generator (v1.1.0)
- Nautilus Fortress A3 Shield Generator (v1.1.0)
- Nautilus Tower N400 Shield Generator (v1.1.0)
- Nautilus Tower N410 Shield Generator (v1.1.0)
- Nautilus Tower N420 Shield Generator (v1.1.0)
- Protectorate Marduk 1010-A Shield Generator (v1.1.0)
- Protectorate Marduk 1020-A Shield Generator (v1.1.0)
- Protectorate Marduk 1030-A Shield Generator (v1.1.0)
- Protectorate Marduk 1040-A Shield Generator (v1.1.0)
- Protectorate Odin 3030-C Shield Generator (v1.1.0)
- Protectorate Odin 3040-C Shield Generator (v1.1.0)
- Protectorate Odin 3050-C Shield Generator (v1.1.0)
- Protectorate Osiris 2020-B Shield Generator (v1.1.0)
- Protectorate Osiris 2030-B Shield Generator (v1.1.0)
- Protectorate Osiris 2040-B Shield Generator (v1.1.0)
- Sextant Assurance SG-1000 Shield Generator (v1.1.0)
- Sextant Assurance SG-1800 Shield Generator (v1.1.0)
- Sextant Assurance SG-2000 Shield Generator (v1.1.0)
- Sextant Assurance SG-3000 Shield Generator (v1.1.0)
- Sextant Deflector SG-10 Shield Generator (v1.1.0)
- Sextant Deflector SG-20 Shield Generator (v1.1.0)
- Sextant Deflector SG-30 Shield Generator (v1.1.0)
- Sextant Deflector SG-35 Shield Generator (v1.1.0)
- Sextant Deflector SG-40 Shield Generator (v1.1.0)
- Sextant Deflector SG-50 Shield Generator (v1.1.0)
- Sextant Deflector SG-60 Shield Generator (v1.1.0)
- Sextant Warden SG-100 Shield Generator (v1.1.0)
- Sextant Warden SG-200 Shield Generator (v1.1.0)
- Sextant Warden SG-300 Shield Generator (v1.1.0)
- Sextant Warden SG-400 Shield Generator (v1.1.0)
- Vanguard Bulwark Shield Generator (v1.1.0)

Structural
----------
- Deimos Belly (v0.1.0)
- Deimos Brace B (v0.1.0)
- Deimos Bumper (v0.1.0)
- Deimos Cowl A (v0.1.0)
- Deimos Radiator (v0.1.0)
- Deimos Skeg A (v0.1.0)
- Deimos Skeg B (v0.1.0)
- Deimos Spine A (v0.1.0)
- Deimos Spine B (v0.1.0)
- Deimos Spine C (v0.2.0)
- Deimos Spine D (v0.2.0)
- Deimos Spine E (v0.2.0)
- Deimos Spine F (v0.2.0)
- Deimos Spine G (v0.2.0)
- Deimos Tail A (v0.2.0)
- HopeTech Bumper A (v0.2.0)
- HopeTech Cap A Aft (v0.2.0)
- HopeTech Cap A Fore (v0.2.0)
- HopeTech Cap A Mid (v0.2.0)
- HopeTech Marker A (v0.3.0)
- HopeTech Nose A (v0.3.0)
- HopeTech Nose B (v0.3.0)
- HopeTech Pipes A (v0.3.0)
- HopeTech Pipes B (v0.3.0)
- HopeTech Pipes End (v0.3.0)
- HopeTech Radiator A (v0.3.0)
- HopeTech Thruster (v0.3.0)
- Nova Cowling 1L (v0.4.0)
- Nova Cowling 2L (v0.4.0)
- Nova Engine Brace (v0.1.0)
- Nova Mini-Brace (v1.2.0)
- Nova Radiator (flat) (v0.4.0)
- Nova Radiator (large) (v0.4.0)
- Nova Radiator (small) (v0.4.0)
- Nova Weapon Mount (v0.5.0)
- Nova Wing (v0.4.0)
- Stroud Cap AY90 (v0.5.0)
- Stroud Cap AZ90 (v0.5.0)
- Stroud Cap B (v0.5.0)
- Stroud Cap C (v0.5.0)
- Stroud Cowling 3LA (v0.5.0)
- Stroud Nose Cap 2B (v0.5.0)
- Stroud Nose Cap C (v0.5.0)
- Stroud Nose Cap D (v0.5.0)
- Taiyo Equipment Plate Bottom (v0.3.0)

Decorative Cargo
----------------
- Decorative: Dogstar StorMax 30 (v1.1.0)
- Decorative: Dogstar StorMax 40 (v1.1.0)
- Decorative: Dogstar StorMax 50 (v1.1.0)
- Decorative: Dogstar StorMax 60 (v1.1.0)
- Decorative: Dogstar StorMax Empty (v1.1.0)
- Decorative: Panoptes da Gama 1000/1010/1020 (v1.1.0)
- Decorative: Panoptes Polo 2000/2010/2020/2030 (v1.1.0)
- Decorative: Protectorate Caravel V101 (v1.1.0)
- Decorative: Protectorate Caravel V102 (v1.1.0)
- Decorative: Protectorate Caravel V103 (v1.1.0)
- Decorative: Protectorate Caravel V104 (v1.1.0)
- Decorative: Protectorate Galleon S201 (v1.1.0)
- Decorative: Protectorate Galleon S202 (v1.1.0)
- Decorative: Protectorate Galleon S203 (v1.1.0)
- Decorative: Protectorate Galleon S204 (v1.1.0)
- Decorative: Sextant Ballast 100CM (v1.1.0)
- Decorative: Sextant Ballast 200CM (v1.1.0)
- Decorative: Sextant Ballast 300CM/400CM (v1.1.0)
- Decorative: Sextant Hauler 10T (v1.1.0)
- Decorative: Sextant Hauler 20T (v1.1.0)
- Decorative: Sextant Hauler 30T/40T (v1.1.0)

Decorative Fuel Tanks
---------------------
- Decorative: Ballistic 100G/200G (v1.1.0)
- Decorative: Ballistic 300G/400G (v1.1.0)
- Decorative: Ballistic 500T (v1.1.0)
- Decorative: Ballistic 600T/700T/900T (v1.1.0)
- Decorative: Ballistic 800T-A (v1.1.0)
- Decorative: Ballistic 800T-B (v1.1.0)
- Decorative: Dogstar Ulysses M10/M20 (v1.1.0)
- Decorative: Dogstar Ulysses M30 (v1.1.0)
- Decorative: Dogstar Ulysses M40/M50 (v1.1.0)
- Decorative: Dogstar Atlas H10 (v1.1.0)
- Decorative: Dogstar Atlas H20 (v1.1.0)
- Decorative: Dogstar Atlas H30 (v1.1.0)
- Decorative: Dogstar Atlas H40 (v1.1.0)
- Decorative: Nautilus Titan 350/450/550 (v1.1.0)

Decorative Grav Drives
----------------------
- Decorative: DeepCore Helios (v1.1.0)
- Decorative: DeepCore Aurora (v1.1.0)
- Decorative: DeepCore Apollo (v1.1.0)
- Decorative: Nova NG1xx (v1.1.0)
- Decorative: Nova NG2xx (v1.1.0)
- Decorative: Nova NG3xx (v1.1.0)
- Decorative: Reladyne Alpha (v1.1.0)
- Decorative: Reladyne Beta (v1.1.0)
- Decorative: Reladyne Gamma (v1.1.0)
- Decorative: Slayton SGD 1xxx (v1.1.0)
- Decorative: Slayton SGD 2xxx (v1.1.0)
- Decorative: Slayton SGD 3xxx (v1.1.0)
- Decorative: Vanguard Recon (v1.1.0)

Decorative Reactors
-------------------
- Decorative: 101DS Mag Inertial Reactor (v1.1.0)
- Decorative: 114MM Toroidal Reactor (v1.1.0)
- Decorative: 330T Stellarator Reactor (v1.1.0)
- Decorative: DC301 Fast Ignition Reactor (v1.1.0)
- Decorative: Fusor DC401 Reactor (v1.1.0)
- Decorative: Ion Beam H-1010 Reactor (v1.1.0)
- Decorative: Pinch 5Z Reactor (v1.1.0)
- Decorative: SF10 Sheared Flow Reactor (v1.1.0)
- Decorative: Spheromak DC201 Reactor (v1.1.0)
- Decorative: Theta Pinch A9 Reactor (v1.1.0)
- Decorative: Tokamak X-050 Reactor (v1.1.0)
- Decorative: Z-Machine 1000 Reactor (v1.1.0)

Decorative Shields
------------------
- Decorative: Dogstar Defender (v1.1.0)
- Decorative: Dogstar Guardian (v1.1.0)
- Decorative: Dogstar Protector (v1.1.0)
- Decorative: Nautilus Bastille (v1.1.0)
- Decorative: Nautilus Fortress (v1.1.0)
- Decorative: Nautilus Tower (v1.1.0)
- Decorative: Protectorate Marduk (v1.1.0)
- Decorative: Protectorate Odin (v1.1.0)
- Decorative: Protectorate Osiris (v1.1.0)
- Decorative: Sextant Assurance (v1.1.0)
- Decorative: Sextant Deflector (v1.1.0)
- Decorative: Sextant Warden (v1.1.0)
- Decorative: Vanguard Bulwark (v1.1.0)

Decorative Weapons (Ballistic)
------------------------------
- Decorative: Ballistic BLS-A (v1.1.0)
- Decorative: Ballistic BLS-B (v1.1.0)
- Decorative: Ballistic BLS-B Turret (v1.1.0)
- Decorative: Ballistic BLS-C (v1.1.0)
- Decorative: Ballistic BLS-C Turret (v1.1.0)
- Decorative: Horizon BLS-A (v1.1.0)
- Decorative: Horizon BLS-B (v1.1.0)
- Decorative: Horizon BLS-B Turret (v1.1.0)
- Decorative: Horizon BLS-C (v1.1.0)
- Decorative: Horizon BLS-C Turret (v1.1.0)
- Decorative: Shinigami BLS-A (v1.1.0)
- Decorative: Shinigami BLS-B (v1.1.0)
- Decorative: Shinigami BLS-B Turret (v1.1.0)
- Decorative: Shinigami BLS-C (v1.1.0)
- Decorative: Shinigami BLS-C Turret (v1.1.0)
- Decorative: Vanguard BLS-A (v1.1.0)

Decorative Weapons (EM)
-----------------------
- Decorative: Ballistic LCT-A (v1.1.0)
- Decorative: Ballistic LCT-B (v1.1.0)
- Decorative: Ballistic LCT-C (v1.1.0)
- Decorative: Light Scythe LCT-A (v1.1.0)
- Decorative: Light Scythe LCT-B (v1.1.0)
- Decorative: Light Scythe LCT-C (v1.1.0)
- Decorative: Shinigami LCT-A (v1.1.0)
- Decorative: Shinigami LCT-B (v1.1.0)
- Decorative: Shinigami LCT-C (v1.1.0)

Decorative Weapons (Laser)
--------------------------
- Decorative: Horizon LSR-A (v1.1.0)
- Decorative: Horizon LSR-B (v1.1.0)
- Decorative: Horizon LSR-B Turret (v1.1.0)
- Decorative: Horizon LSR-C (v1.1.0)
- Decorative: Horizon LSR-C Turret (v1.1.0)
- Decorative: Light Scythe LSR-A (v1.1.0)
- Decorative: Light Scythe LSR-B (v1.1.0)
- Decorative: Light Scythe LSR-C (v1.1.0)
- Decorative: Light Scythe LSR-C Turret (v1.1.0)
- Decorative: Light Scythe LSR-D (v1.1.0)
- Decorative: Light Scythe LSR-D Turret (v1.1.0)
- Decorative: Shinigami LSR-A (v1.1.0)
- Decorative: Shinigami LSR-B (v1.1.0)
- Decorative: Shinigami LSR-B Turret (v1.1.0)
- Decorative: Shinigami LSR-C (v1.1.0)
- Decorative: Shinigami LSR-C Turret (v1.1.0)
- Decorative: Vanguard LSR-A (v1.1.0)

Decorative Weapons (Missile)
----------------------------
- Decorative: Ballistic MSL-A (v1.1.0)
- Decorative: Ballistic MSL-B (v1.1.0)
- Decorative: Ballistic MSL-C (v1.1.0)
- Decorative: Ballistic MSL-D (v1.1.0)
- Decorative: Horizon MSL-A (v1.1.0)
- Decorative: Horizon MSL-B (v1.1.0)
- Decorative: Horizon MSL-C (v1.1.0)
- Decorative: Light Scythe MSL-A (v1.1.0)
- Decorative: Light Scythe MSL-B (v1.1.0)
- Decorative: Light Scythe MSL-C (v1.1.0)
- Decorative: Shinigami MSL-A (v1.1.0)
- Decorative: Shinigami MSL-B (v1.1.0)
- Decorative: Shinigami MSL-C (v1.1.0)
- Decorative: Vanguard MSL-A (v1.1.0)

Decorative Weapons (Particle)
-----------------------------
- Decorative: Ballistic PRT-A (v1.1.0)
- Decorative: Ballistic PRT-B (v1.1.0)
- Decorative: Ballistic PRT-B Turret (v1.1.0)
- Decorative: Ballistic PRT-C (v1.1.0)
- Decorative: Ballistic PRT-C Turret (v1.1.0)
- Decorative: Horizon PRT-A (v1.1.0)
- Decorative: Horizon PRT-B (v1.1.0)
- Decorative: Horizon PRT-B Turret (v1.1.0)
- Decorative: Horizon PRT-C (v1.1.0)
- Decorative: Horizon PRT-C Turret (v1.1.0)
- Decorative: Light Scythe PRT-A (v1.1.0)
- Decorative: Light Scythe PRT-B (v1.1.0)
- Decorative: Light Scythe PRT-B Turret (v1.1.0)
- Decorative: Light Scythe PRT-C (v1.1.0)
- Decorative: Light Scythe PRT-C Turret (v1.1.0)
- Decorative: Vanguard PRT-A (v1.1.0)
- Decorative: Vanguard PRT-B (v1.1.0)
