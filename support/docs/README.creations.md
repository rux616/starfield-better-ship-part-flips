Version: 1.3.1


Summary
-----
NOTE: Now requires the Ship Builder Categories (https://creations.bethesda.net/en/starfield/details/f4c658c4-77f0-4362-af7e-4aa07072598e/Ship_Builder_Categories) mod!

Adds additional flips of vanilla parts, thus far including shields, cargo holds, fuel tanks, grav drives, reactors, and structural parts. A pure ESM mod, the flips are done using the vanilla data, no additional meshes are added. Largely stays within the grid established so far. Also includes "decorative" versions of shields, cargo holds, fuel tanks, grav drives, reactors, and weapons.

There are a few options patches available to prevent the decorative items from showing, increase cargo hold capacity by 3x, and increase cargo hold capacity by 10x; search for "BSPF Option" to find them. Additionally, a number of compatibility patches are available for various mods, which can be found by searching for "BSPF Patch".

Better Ship Part Flips is fully compatible with Better Ship Part Snaps (https://creations.bethesda.net/en/starfield/details/81dc21ae-e497-441b-aaf9-b44b923d1401/Better_Ship_Part_Snaps) and they can be used together.

This is a limited version of the readme. The full version can be found at the mod's page on Nexus Mods (https://www.nexusmods.com/starfield/mods/5953), or in the GitHub repository (https://github.com/rux616/starfield-better-ship-part-flips).


Load Order
-----
For best results, put this mod lower in your load order, followed by any patches.


Compatibility
-----
General mod compatibility is limited as Better Ship Part Flips has to modify some of the data that also contains properties such as hull, mass, etc. There are some patches available, either included in the installation archive if you're downloading from Nexus Mods, or as separate mods if you're using Bethesda.net Creations.

- "All ship parts unlevelled at all vendors (ESM)" by SKK50 [Nexus (https://www.nexusmods.com/starfield/mods/6060)]: [Patch Required] Depending on whether BSPF or this mod is set to higher priority, either some parts simply won't show up or will still have level or vendor requirements. Use the included compatibility patch. (checked 2024-08-12; version 002)
- "Avontech Shipyards" by kaosnyrb [Creations (https://creations.bethesda.net/en/starfield/details/32b36186-7136-41eb-8522-cba41fa271e2/Avontech_Shipyards) / Nexus (https://www.nexusmods.com/starfield/mods/8057)]: Fully compatible. (checked 2024-08-12; version 1.2.0)
- "Better Ship Part Snaps" by freschu/rux616 [Creations (https://creations.bethesda.net/en/starfield/details/81dc21ae-e497-441b-aaf9-b44b923d1401/Better_Ship_Part_Snaps) / Nexus (https://www.nexusmods.com/starfield/mods/5698)]: If using the Ship Colorize compatibility patch, there is an additional patch (included) that should be used to restore feature parity with Better Ship Part Snaps. Note the flips added by Better Ship Part Snaps don't all have any particularly enhanced snaps. (checked 2024-08-12; version 1.0.0)
- "DarkStar Astrodynamics" by WykkydGaming [Creations (https://creations.bethesda.net/en/starfield/details/cfca357a-7226-4cae-bd16-3575069dcf2e/DarkStar_Astrodynamics) / Nexus (https://www.nexusmods.com/starfield/mods/9458)]: Fully compatible. (checked 2024-08-12; version 4.1.1)
- "DerreTech" (NOT DerreTech Legacy!) by DerekM17x [Creations (https://creations.bethesda.net/en/starfield/details/d76f29e6-528a-4024-9099-14f445ee9fb6/DerreTech) / Nexus (https://www.nexusmods.com/starfield/mods/9185)]: Fully compatible. (checked 2024-09-06; version 2.0.1)
- "Matilija's Aerospace" by matilija [Creations (https://creations.bethesda.net/en/starfield/details/df3bc774-c92c-4051-a51a-e2573f7175ed/Matilija_Aerospace_V3) / Nexus (https://www.nexusmods.com/starfield/mods/9293)]: Fully compatible. (checked 2024-09-06; version 4.0)
- "Ship Colorize" by DerekM17x [Creations (https://creations.bethesda.net/en/starfield/details/c6fcfa3e-3960-4361-91b0-a757b7d3b560/Ship_Colorize) / Nexus (https://www.nexusmods.com/starfield/mods/7003)]: [Patch Optional] The patch just includes Ship Colorize's enhancements for a few of the additional flips for things like the Reladyne J-series Gamma Grav Drives, Amun Dunn Theta Pinch-style reactors, etc. The additional flips for DogStar StorMax cargo holds do _not_ support enhancement. I got tired of trying to make it work, and so just ripped out support for them. (checked 2024-08-12; version 1.1)
- "Ship Combat Revised" by Itheral [Creations - Habs (https://creations.bethesda.net/en/starfield/details/ec60f892-72e7-4bb7-88b0-61ccb904c397/Ship_Combat_Revised___Modules__amp__Habs) / Creations - Reactors (https://creations.bethesda.net/en/starfield/details/622c19d9-491f-4fcf-94fd-3ce20fa2e3c0/Ship_Combat_Revised___Reactors) / Creations - Thrusters (https://creations.bethesda.net/en/starfield/details/da6174c5-66a5-459c-bc38-f337adaddf3b/Ship_Thrusters_Empowered) / Creations - Weapons (https://creations.bethesda.net/en/starfield/details/3132cd66-68df-4a59-92f4-ee8769364cef/Ship_Combat_Revised___Weapons__amp__Shields) / Nexus (https://www.nexusmods.com/starfield/mods/9371)]: [Patch Required] Patches needed if you use the "Habs", "Reactors", "Weapons", or "Ship Thrusters Empowered" files. (checked 2024-08-15; version 1.42)
- "Ship Module Snap Expansion" by Gilibran [Nexus (https://www.nexusmods.com/starfield/mods/6029)]: Not compatible at all. (checked 2024-08-12; version 1.0.1)
- "Starfield Extended - Shields Rebalanced" by Gambit77 [Creations (https://creations.bethesda.net/en/starfield/details/fd87aa76-53ce-46ce-9825-9ec208dafce2/Starfield_Extended___Shields_Rebalanced) / Nexus (https://www.nexusmods.com/starfield/mods/6238)]: [Patch Required] Shields will either be missing flips or not have higher health, depending on which mod wins the conflict. Use the included compatibility patch. (checked 2024-08-12; version 1.00-ESL)
- "Tiger Shipyards Overhaul" by LJTIGER69 [Creations (https://creations.bethesda.net/en/starfield/details/1b733e93-c0f2-4e07-a28b-5413672da978/TIGER_SHIPYARDS_OVERHAUL) / Nexus (https://www.nexusmods.com/starfield/mods/8868)]: Fully compatible. (checked 2024-08-12; version 2.0.6)
- "TN's Expanded Cargo Holds" by TheOGTennessee [Nexus (https://www.nexusmods.com/starfield/mods/5957)]: [Patch Required] Cargo holds won't be at their advertised capacity otherwise. (checked 2024-08-12; version 1.1)
- "TN's Separated Categories" by TheOGTennessee [Creations (https://creations.bethesda.net/en/starfield/details/dd306a75-12bc-4829-bf32-ae50314889b1/TN__39_s_Separated_Categories) / Nexus (https://www.nexusmods.com/starfield/mods/7467)]: [Patch Optional] Places HopeTech thrusters into the "Thrusters" category. (checked 2024-09-05; version 1.1)
- "TN's Ship Modifications All In One" by TheOGTennessee [Creations (https://creations.bethesda.net/en/starfield/details/08ed4d34-95f0-42a3-b654-5ade11a1af1e/TN__39_s_Ship_Modifications_All_in_One) / Nexus (https://www.nexusmods.com/starfield/mods/6376)]: [Patch Required] Decoratives may conflict, and also some structure pieces might not add the correct amount of hull or might not have the appropriate flips available, depending on which mod wins the conflict. Use the compatibility patch. (checked 2024-09-03; version 3.0.1)
- "TN's Useful Ship Structure (Hull Buffs)" by TheOGTennessee [Nexus (https://www.nexusmods.com/starfield/mods/5836)]: [Patch Required] The patch makes sure that the new flips added have the matching amount of health (and/or other effects) as specified by the mod. (checked 2024-08-12; version 1.1)
- "Ultimate Shipyards Unlocked" by JustAnOrdinaryGuy [Nexus (https://www.nexusmods.com/starfield/mods/4723)]: [Patch Required] Incompatibilities with the All In One plugin, and the "No Level Requirements" and "Quest Rewards" modules from the modular version. Use the included compatibility patch/patches. (checked 2024-08-12; version 1.4)


Known Issues
-----
- Sometimes one or more ship modules will appear randomly rotated on your ship. This is purely cosmetic and a save/reload almost always fixes it.


Credits and Acknowledgements
-----
freschu: For initially creating this mod
ElminsterAU: For xEdit and BSArch
Mod Organizer 2 team: For getting Mod Organizer 2 with Starfield support out the door so quickly
Nexus Mods: For mod hosting and for the Vortex Mod Manager
Noggog: For Spriggit


Contact
-----
If you find a bug or have a question about the mod, please post it on the mod's page at Nexus Mods (https://www.nexusmods.com/starfield/mods/5953), or in the GitHub repository (https://github.com/rux616/starfield-better-ship-part-flips).

If you need to contact me personally, I can be reached through one of the following means:
- **Nexus Mods**: rux616 (https://www.nexusmods.com/users/124191) (Send a message via the "CONTACT" button.)
- **Email**: rux616-at-pm-dot-me (replace `-at-` with `@` and `-dot-` with `.`)
- **Discord**: rux616 (user ID 234489279991119873) - make sure to "@" me
    - Lively's Modding Hub (https://discord.gg/livelymods)
    - Nexus Mods (https://discord.gg/nexusmods)
    - Collective Modding (https://discord.gg/pF9U5FmD6w) ("🔧-chaotic-cognitions" channel)
    - Starfield Modding (https://discord.gg/6R4Yq5KjW2)
