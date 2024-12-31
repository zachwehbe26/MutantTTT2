You have to use TTT2 in order to use this role. Additionally using ULX for TTT2 is recommended. Report bugs concerning this role [url=https://github.com/zaqlul9595/MutantTTT2/issues]here[/url]. A list of all currently available roles can be found [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1737053146]here[/url].

Discord: https://discord.gg/9njYXGY
Source: https://github.com/zaqlul9595/MutantTTT2

## How to Play ##

The Mutant is a new innocent role for TTT2

You are a lab experiment gone... Right? The mutant gets regenerative healing and buffs that come with taking increasing damage. At 50 damage taken, you receive a radar, to guide your painful journey. At 75 damage taken, your max health is increased to 150 (no extra health is gained, just max health). At 100 damage, your movement speed is increased by 20%!
 
As a bonus, for every 10 damage taken after 100, you gain 1 max health point. For example, if you go from 100 damage taken to 120 damage taken, your new max health is now 152!

The mutant also receives no prop damage by default. Unfortunately, the damage system does not favor damage in the form of physics objects. So think of it as the mutant having tough skin or something like that

[img]https://i.imgur.com/jIBWtbM.png[/img]
Convars are variables that are introduced to allow server owners to customize the gameplay without changing the code. There are always a handful of convars automatically created by TTT2, that define the spawn parameters of this role and are found in ULX. Additionally there might be some role specific convars, which have to be set in the server config file.

## Normal Role Convars (also found in ULX) ##

enable or disable this role 
  ttt_mutant_enabled [0/1] (default 1) <br><br>
the percentage of players that are spawned as this role
  ttt_mutant_pct [0.0..1.0] (default 0.17)<br><br>
the limit of players that spawn as this role each round, this overwrites the percentage
  ttt_mutant_max [0..n] (default 1) <br><br>
the probability each round of this role being spawned at all
  ttt_mutant_random [0..100] (default 33) <br><br>
the amount of players needed for this role to spawn
  ttt_mutant_min_players [0..n] (default 6) <br><br>


## Mutant Specific Convars (found in F1 menu) ##

How often the mutant heals(in seconds)
  ttt2_mut_healing_interval [1...10] (default 1) <br><br>
How much the mutant heals for
  ttt2_mut_healing_amount [1...10] (default 1) <br><br>
Speed multiplier after taking 100 damage
  ttt2_mut_speed_multiplier [1.0...2.0] (default 1.2) <br><br>
Mutant receives fire damage
  ttt2_mut_firedmg [0-1] (default 1) <br><br>
Mutant receives explosive damage
  ttt2_mut_explosivedmg [0-1] (default 1) <br><br>
Mutant receives fall damage
  ttt2_mut_falldmg [0-1] (default 1) <br><br>


--
Credits <br>
cheezbawlz: Coding <br>
milkwater: Icons
