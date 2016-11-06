#include 'rules.lp'.

_supertype_type(legendary).
_supertype_type(snow).
_supertype_type(basic).
_supertype_type(world).

_type_type(instant).
_type_type(sorcery).
_type_type(creature).
_type_type(enchantment).
_type_type(artifact).
_type_type(land).
_type_type(planeswalker).
_type_type(tribal).

_subtype_type(equipment).
_subtype_type(aura).
_subtype_type(swamp).
_subtype_type(elf).
_subtype_type(jace).
_subtype_type(arcane).
_subtype_type(trap).
_subtype_type(wizard).
_subtype_type('Saproling').

_mana_type(1).
_mana_type(w).
_mana_type(u).
_mana_type(b).
_mana_type(r).
_mana_type(g).
_mana_type(c).

_phase_type(untap).
_phase_type(upkeep).
_phase_type(draw).
_phase_type(premain).
_phase_type(begcombat).
_phase_type(declareattack).
_phase_type(declareblock).
_phase_type(combatdamage).
_phase_type(endcombat).
_phase_type(postmain).
_phase_type(end).
_phase_type(cleanup).

_pcounter_type(poison).
_pcounter_type(energy).
_pcounter_type(experience).

_bcounter_type(popo).

?- V = _card('Ornithopter', [], [], [creature], [], []),
     C3 = _card('Ancestral Recall', [u], [], [instant], [], [draw, draw, draw]),
     Sp = _spell(C3, P, P, [P, P, P]),
     P = _player([], [V,V,V], [], 40, [], []),
     P2 = _player([], [], [], 40, [], []),
     S = _state([Sp], [], [], [], [], [P], [end], P),
     _state_type(S),
     
     % _player_list_ne
     % _deepswap(P, P2, S, SN).
     % _player_list_ne([P]),
     % _equal_change(P, P2, P, NP),
     % _deepswap(X, Y, [], []),
     % _player_list_ne([NP|[]]).
     % _deepcopy(P, P2, [P,P2], SN).
     _transition(S, resolve, [], SN).
    

% # % ?-     C3 = _card_type('Ancestral Recall', [u], [], [instant], [], [draw, draw, draw], nil),
% # %      S = _spell_type(C3, P, P, [P, P, P]),
% # %      P = _player_type([], [C3, C3, C3], [], 40, [], []).
