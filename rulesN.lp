_state_type(X) :- X = _state_type(_, _, _, _, _, _, _, _).
_state_type(Stack, Exile, Command, Battlefield, Ante, Players, Phases, ActivePlayer) :-
    _stack_elem_list(Stack),
    _card_list(Exile),
    _command_elem_list(Command),
    _permanent_list(Battlefield),
    _card_list(Ante),
    _players_list_ne(Players),
    _phase_list_ne(Phases),
    _player_type(ActivePlayer),
    _member(ActivePlayer, Players).

_phase_list_ne([H]) :- _phase_type(H).
_phase_list_ne([H|T]) :- _phase_type(H), _phase_list_ne(T).

_players_list_ne([H]) :- H = _player_type(_, _, _, _, _, _).
_players_list_ne([H|P]) :- H = _player_type(_, _, _, _, _, _), _players_list_ne(P).

_stack_elem_type(X) :- X = _spell_type(_, _, _).
_stack_elem_type(X) :- X = _ability_type(_, _).
_stack_elem_list([]).
_stack_elem_list([H|T]) :- _stack_elem_type(H), _stack_elem_list(T).

_player_type(X) :- X = _player_type(_, _, _, _, _, _).
_player_type(Hand, Library, Graveyard, Lifecount, ManaPool, PCounters) :-
    _card_list(Hand),
    _card_list(Library),
    _card_list(Graveyard),
    _mana_list(ManaPool),
    _pcounter_list(PCounters).

_pcounter_list([]).
_pcounter_list([H|T]) :- _pcounter_type(H), _pcounter_list(T).

_spell_type(X) :- X = _spell_type(_, _, _, _).
_spell_type(X, Controller, Owner, Targets) :-
    X = _card_type(_, _, _, _, _, E, _),
    _player_type(Controller),
    _player_type(Owner),
    _len(Targets, N),
    _len(E, N).

_ability_type(X) :- X = _ability_type(_, _, _).
_ability_type(Effects, Controller, Targets) :-
    _effect_list(Effects),
    _player_type(Controller),
    _len(Effects, N),
    _len(Targets, N).

_effect_list([]).
_effect_list([H|T]) :- _effect_type(H), _effect_list(T).
_effect_type(draw).
_effect_type(discard).

_card_type(X) :- X = _card_type(_, _, _, _, _, _, _).
_card_type(Name, Cost, Supertypes, Types, Subtypes, Effects, Owner) :-
    _mana_list(Cost),
    _supertype_list(Supertypes),
    _type_list_ne(Type),
    _subtype_list(Subtypes),
    _effect_list(Effects).

_supertype_list([]).
_supertype_list([H|T]) :- _supertype_type(H), _supertype_list(T).

_type_list_ne([H]) :- _type_type(H).
_type_list_ne([H|T]) :- _type_type(H), _type_list_ne(T).

_subtype_list([]).
_subtype_list([H|T]) :- _subtype_type(H), _subtype_list(T).

_emblem_type(X) :- X = _emblem_type(_, _, _).
_emblem_type(Effects, Controller, Owner) :-
    _effect_list(Effects),
    _player_type(Controller),
    _player_type(Owner).

_permanent_type(X) :- X = _permanent_type(_, _, _, _).
_permanent_type(X, BCounters, Controller, Tapped) :-
    _permanent_card_type(X),
    _bcounter_list(BCounters),
    _player_type(Controller),
    _bool_type(Tapped).
_permanent_type(X, BCounters, Controller, Tapped) :-
    _token_type(X),
    _bcounter_list(BCounters),
    _player_type(Controller),
    _bool_type(Tapped).

_bcounter_list([]).
_bcounter_list([H|T]) :- _bcounter_type(H), _bcounter_list(T).
_bool_type(true).
_bool_type(false).

_permanent_card_type(Card) :-
    Card = _card_type(_, _, _, L, _, _, _),
    _contain(L, [artifact, creature, enchantment, land, planeswalker, tribal]).

_token_type(X) :- X = _token_type(_, _, _, _, _, _, _).
_token_type(Name, Cost, Supertypes, Types, Subtypes, Effects, Owner) :-
    _mana_list(Cost),
    _supertype_list(Supertypes),
    _types_list(Types),
    _subtypes_list(Subtypes),
    _effect_list(Effects).

_mana_list([]).
_mana_list([H|T]) :- _mana_type(H), _mana_list(T).

% Utility Functions
_snoc([], H, [H]).
_snoc([H|T], X, [H|R]) :- _snoc(T, X, R).

_member(X, [X|T]).
_member(X, [Y|T]) :- _member(X, T).

_swap(X, Y, [X|T1], [Y|T2]) :- T1 = T2.
_swap(X, Y, [H1|T1], [H1|T2]) :- _swap(X, Y, T1, T2).

_contain([], _).
_contain([H|T], L) :- _member(H, L), _contain(T, L).

_select(X, [X|T], T).
_select(X, [H|T], [H|Y]) :- _select(X, T, Y).

_len([], 0).
_len([H|T], N) :- _len(T, N1), N is N1 + 1.

_equal_change(X, X, Y, Y).
_equal_change(X, Y, Z, Y). 

_transition(S, draw, [P], SN) :-
    S = _state_type(St, E, C, B, A, Ps, Ph, Ap),
    _member(P, Ps),
    P = _player_type(H, [D|L], G, Li, M, Pc),
    PN = _player_type([D|H], L, G, Li, M, Pc),
    _swap(P, PN, Ps, PNs),
    _equal_change(P, Ap, PN, ApN),
    SN = _state_type(St, E, C, B, A, PNs, Ph, ApN).

_transition(S, discard, [P], SN) :-
    _transition(S, discard, [P, _], SN).

_transition(S, discard, [P, C], SN) :-
    S = _state_type(St, E, Cz, B, A, Ps, Ph, Ap),
    _member(P, Ps),
    P = _player_type(H, L, G, Li, M, Pc),
    _member(C, H),
    _select(C, H, HN),
    PN = _player_type(HN, L, [C|G], Li, M, Pc),
    _swap(P, PN, Ps, PNs),
    _equal_change(P, Ap, PN, ApN),
    SN = _state_type(St, E, Cz, B, A, PNs, Ph, ApN).

_transition(S, phase, [], SN) :-
    S = _state_type([], E, C, B, A, [P|Ps], [upkeep], P),
    SS = _state_type([], E, C, B, A, [P|Ps], [draw], P),
    _transition(SS, draw, [P], SN).

_transition(S, phase, [], SN) :-
    S = _state_type([], E, C, B, A, [P1, P2|T], [cleanup], P1),
    _snoc(T, P1, TN),
    SN = _state_type([], E, C, B, A, [P2|TN], [untap], P2).

% Also end EOT effects and remove damage
_transition(S, phase, [], SN) :-
    S = _state_type([], E, C, B, A, [P|Ps], [end], P),
    P = _player_type(H, _, _, _, _, _),
    _len(H, N),
    N < 2,
    SN = _state_type([], E, C, B, A, [P|Ps], [cleanup], P).
_transition(S, phase, [], SN) :-
    S = _state_type([], _, _, _, _, _, [end], P),
    P = _player_type(H, _, _, _, _, _),
    _len(H, N),
    N > 1,
    _select(Cn, H, _),
    _transition(S, discard, [P, Cn], SS),
    _transition(SS, phase, [], SN).
