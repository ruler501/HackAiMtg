% Kokusho, the Evening Star
name(kokusho_the_evening_star, kokusho_the_evening_star).
cost(kokusho_the_evening_star, [1,1,1,1,b,b]).
type(kokusho_the_evening_star, creature).
supertype(kokusho_the_evening_star, legend).
subtype(kokusho_the_evening_star, dragon).
subtype(kokusho_the_evening_star, spirit).
abilities(kokusho_the_evening_star, []).

% Grand Arbiter Augustin IV
name(grand_arbiter_augustin_iv, grand_arbiter_augustin_iv).
cost(grand_arbiter_augustin_iv, [1,1,w,u]).
type(grand_arbiter_augustin_iv, creature).
supertype(grand_arbiter_augustin_iv, legend).
subtype(grand_arbiter_augustin_iv, human).
subtype(grand_arbiter_augustin_iv, advisor).
abilities(grand_arbiter_augustin_iv, []).

% Glissa, the Traitor
name(glissa_the_traitor, glissa_the_traitor).
cost(glissa_the_traitor, [b,g,g]).
type(glissa_the_traitor, creature).
supertype(glissa_the_traitor, legend).
subtype(glissa_the_traitor, zombie).
subtype(glissa_the_traitor, elf).
subtype(glissa_the_traitor).
abilities(glissa_the_traitor, []).

% Memnarch
name(memnarch, memnarch).
cost(memnarch, [1,1,1,1,1,1,1]).
type(memnarch, creature).
type(memnarch, artifact).
supertype(memnarch, legend).
subtype(memnarch, wizard).
abilities(memnarch, []).

% Jaya Ballard, Task Mage
name(jaya_ballard_task_mage, jaya_ballard_task_mage).
cost(jaya_ballard_task_mage, [1,r,r]).
type(jaya_ballard_task_mage, creature).
supertype(jaya_ballard_task_mage, legend).
subtype(jaya_ballard_task_mage, human).
subtype(jaya_ballard_task_mage, spellshaper).
abilities(jaya_ballard_task_mage, []).

% The Mimeoplasm
name(the_mimeoplasm, the_mimeoplasm).
cost(the_mimeoplasm, [1,1,g,u,b]).
type(the_mimeoplasm, creature).
supertype(the_mimeoplasm, legend).
subtype(the_mimeoplasm, ooze).
abilities(the_mimeoplasm, []).

% Visara the Dreadful
name(visara_the_dreadful, visara_the_dreadful).
cost(visara_the_dreadful, [1,1,1,b,b,b]).
type(visara_the_dreadful, creature).
supertype(visara_the_dreadful, legend).
subtype(visara_the_dreadful, gorgon).
abilities(visara_the_dreadful, []).

% Arcanis the Omnipotent
name(arcanis_the_omnipotent, arcanis_the_omnipotent).
cost(arcanis_the_omnipotent, [1,1,1,u,u,u]).
type(arcanis_the_omnipotent, creature).
supertype(arcanis_the_omnipotent, legend).
subtype(arcanis_the_omnipotent, wizard).
abilities(arcanis_the_omnipotent, []).

% Akroma, Angel of Wrath
name(akroma_angel_of_wrath, akroma_angel_of_wrath).
cost(akroma_angel_of_wrath, [1,1,1,1,1,w,w,w]).
type(akroma_angel_of_wrath, creature).
supertype(akroma_angel_of_wrath, legend).
subtype(akroma_angel_of_wrath, angel).
abilities(akroma_angel_of_wrath, []).

% Sliver Queen
name(sliver_queen, sliver_queen).
cost(sliver_queen, [w,u,b,r,g]).
type(sliver_queen, creature).
supertype(sliver_queen, legend).
subtype(sliver_queen, sliver).
abilities(sliver_queen, []).

% Twilight Shepherd
name(twilight_shepherd, twilight_shepherd).
cost(twilight_shepherd, [1,1,1,w,w,w]).
type(twilight_shepherd, creature).
subtype(twilight_shepherd, angel).
abilities(twilight_shepherd, abilities).

% Exquisite Firecraft
name(exquisite_firecraft, exquisite_firecraft).
cost(exquisite_firecraft, [1,r,r]).
type(exquisite_firecraft, sorcery).
abilities(exquisite_firecraft, []).

% Rise from the Grave
name(rise_from_the_grave, rise_from_the_grave).
cost(rise_from_the_grave, [1,1,1,1,b]).
type(rise_from_the_grave, sorcery).
abilities(rise_from_the_grave, []).

% Rout
name(rout, rout).
cost(rout, [1,1,1,w,w]).
type(rout, sorcery).
abilities(rout, []).

% Abolish
name(abolish, abolish).
cost(abolish, [1,w,w]).
type(abolish, instant).
abilities(abolish, []).

% Capsize
name(capsize, capsize).
cost(capsize, [1,u,u]).
type(capsize, instant).
abilities(capsize, []).

% Plaxmanta
name(plaxmanta, plaxmanta).
cost(plaxmanta, [1,u]).
type(plaxmanta, creature).
subtype(plaxmanta, beast).
abilities(plaxmanta, []).

% Jace, the Living Guildpact
name(jace_the_living_guildpact, jace_the_living_guildpact).
cost(jace_the_living_guildpact, [1,1,u,u]).
type(jace_the_living_guildpact, planeswalker).
subtype(jace_the_living_guildpact, jace).
abilities(jace_the_living_guildpact, []).

% Dictate of Erebos
name(dictate_of_erebos, dictate_of_erebos).
cost(dictate_of_erebos, [1,1,1,b,b]).
type(dictate_of_erebos, enchantment).
abilities(dictate_of_erebos, []).

controller(capsize, jim).
controller(abolish, jim).
controller(memnarch, jim).
counters(memnarch, []).

player_hand(jim, []).
player_library(jim, [jace_the_living_guildpact]).
player_graveyard(jim, [dictate_of_erebos]).
lifecount(jim, 200).
counters(jim, []).
manapool(jim, [C,C,C,C,C,C,C,C,C]).

?- S = [capsize, abolish],
E = [],
C = [arcanis_the_omnipotent],
B = [memnarch],
A = [],
P = [jim],
_state(S, E, C, B, A, P).
