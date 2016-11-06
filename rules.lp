_state_type(X) :- X = _state(S, E, C, B, A, P, Ph, Ap), _state(S, E, C, B, A, P, Ph, Ap).
_state(Stack, Exile, Command, Battlefield, Ante, Players, Phases, ActivePlayer) :-
    _stack_elem_list(Stack),
    _card_list(Exile),
    _command_elem_list(Command),
    _permanent_list(Battlefield),
    _card_list(Ante),
    _player_list_ne(Players),
    _phase_list_ne(Phases),
    _player_type(ActivePlayer),
    _member(ActivePlayer, Players).
    

_phase_list_ne([H]) :- _phase_type(H).
_phase_list_ne([H|T]) :- _phase_type(H), _phase_list_ne(T).

_player_list_ne([H]) :- _player_type(H).
_player_list_ne([H|P]) :- _player_type(H), _player_list_ne(P).

_card_list([]).
_card_list([H|T]) :- _card_type(H), _card_list(T).

_stack_elem_type(X) :- _spell_type(X).
_stack_elem_type(X) :- _ability_type(X).
_stack_elem_list([]).
_stack_elem_list([H|T]) :- _stack_elem_type(H), _stack_elem_list(T).

_command_elem_list([]).
_command_elem_list([H|T]) :- _command_elem_type(H), _command_elem_list(T).
_command_elem_type(X) :- _emblem_type(X).
_command_elem_type(X) :- _card_type(X).

_player_type(X) :- X = _player(H, L, G, Lc, M, P), _player(H, L, G, Lc, M, P).
_player(Hand, Library, Graveyard, _, ManaPool, PCounters) :-
    _card_list(Hand),
    _card_list(Library),
    _card_list(Graveyard),
    _mana_list(ManaPool),
    _pcounter_list(PCounters).

_pcounter_list([]).
_pcounter_list([H|T]) :- _pcounter_type(H), _pcounter_list(T).

_spell_type(X) :- X = _spell(C, Co, Ow, T), _spell(C, Co, Ow, T).
_spell(S, Controller, Owner, Targets) :-
    _card_type(S),
    S = _card(_, _, _, _, _, E),
    _player_type(Controller),
    _player_type(Owner),
    _len(Targets, N),
    _len(E, N).

_ability_type(X) :- X = _ability(E, C, T), _ability(E, C, T).
_ability(Effects, Controller, Targets) :-
    _effect_list(Effects),
    _player_type(Controller),
    _len(Effects, N),
    _len(Targets, N).

_effect_list([]).
_effect_list([H|T]) :- _effect_type(H), _effect_list(T).
_effect_type(draw).
_effect_type(discard).

_card_type(X) :- X = _card(N, C, S, T, Su, E), _card(N, C, S, T, Su, E).
_card(_, Cost, Supertypes, Types, Subtypes, Effects) :-
    _mana_list(Cost),
    _supertype_list(Supertypes),
    _type_list_ne(Types),
    _subtype_list(Subtypes),
    _effect_list(Effects).

_supertype_list([]).
_supertype_list([H|T]) :- _supertype_type(H), _supertype_list(T).

_type_list_ne([H]) :- _type_type(H).
_type_list_ne([H|T]) :- _type_type(H), _type_list_ne(T).

_subtype_list([]).
_subtype_list([H|T]) :- _subtype_type(H), _subtype_list(T).

_emblem_type(X) :- X = _emblem(E, C, O), _emblem(E, C, O).
_emblem(Effects, Controller, Owner) :-
    _effect_list(Effects),
    _player_type(Controller),
    _player_type(Owner).

_permanent_type(X) :- X = _permanent(P, B, C, T), _permanent(P, B, C, T).
_permanent_type(P, BCounters, Controller, Tapped) :-
    _permanent_card_type(P),
    _bcounter_list(BCounters),
    _player_type(Controller),
    _bool_type(Tapped).
_permanent_type(X, BCounters, Controller, Tapped) :-
    _token_type(X),
    _bcounter_list(BCounters),
    _player_type(Controller),
    _bool_type(Tapped).
_permanent_list([]).
_permanent_list([H|T]) :- _permanent_type(H), _permanent_list(T).

_bcounter_list([]).
_bcounter_list([H|T]) :- _bcounter_type(H), _bcounter_list(T).
_bool_type(true).
_bool_type(false).

_permanent_card_type(Card) :-
    _card_type(Card),
    Card = _card(_, _, _, L, _, _),
    _contain(L, [artifact, creature, enchantment, land, planeswalker, tribal]).

_token_type(X) :- X = _token(N, C, S, T, Su, E, O), _token(N, C, S, T, Su, E, O).
_token(_, Cost, Supertypes, Types, Subtypes, Effects, _) :-
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

_member(X, [X|_]).
_member(X, [_|T]) :- _member(X, T).

_swap(X, Y, [], []).
_swap(X, Y, [X|T1], [Y|T2]) :- _swap(X, Y, T1, T2).
_swap(X, Y, [H1|T1], [H1|T2]) :- X \= H1, _swap(X, Y, T1, T2).

_deepswap(X, Y, S, SN) :-
    _state_type(S),
    _player_type(X),
    _player_type(Y),
    S = _state(Stack, Exile, Command, Battlefield, Ante, Players, Phases, ActivePlayer),
    _deepswap(X, Y, Stack, StackN),
    _deepswap(X, Y, Players, PlayersN),
    _equal_change(X, ActivePlayer, Y, ActivePlayerN),
    SN = _state(StackN, Exile, Command, Battlefield, Ante, PlayersN, Phases, ActivePlayerN),
    _state_type(SN).

_deepswap(_, _, [], []).

_deepswap(X, Y, [S|Ss], [SN|SNs]) :-
    _stack_elem_list([S|Ss]),
    _deepswap(X, Y, S, SN),
    _deepswap(X, Y, Ss, SNs),
    _stack_elem_list([SN|SNs]).

_deepswap(X, Y, S, SN) :-
    _spell_type(S),
    S = _spell(Cd, C, O, T),
    _equal_change(X, C, Y, CN),
    _equal_change(X, O, Y, ON),
    _swap(X, Y, T, TN),
    SN = _spell(Cd, CN, ON, TN).

_deepswap(X, Y, [S|Ss], [SN|SNs]) :-
    _player_list_ne([S|Ss]),
    _equal_change(X, S, Y, SN),
    _deepswap(X, Y, Ss, SNs),
    _player_list_ne([SN|SNs]).

_contain([], _).
_contain([H|T], L) :- _member(H, L), _contain(T, L).

_select(X, [X|T], T).
_select(X, [H|T], [H|Y]) :- _select(X, T, Y).

_len([], 0).
_len([_|T], N) :- _len(T, N1), N is N1 + 1.

_equal_change(X, X, Y, Y).
_equal_change(X, Y, _, Y) :- X \= Y.

% _transition(S, swap, [X, Y], SN) :-
%     S = _state_type(Stack, Exile, Command, Battlefield, Ante, Players, Phases, ActivePlayer),
%     _swap(X, Y, Stack, StackN),
%     _swap(X, Y, Exile, ExileN),
%     _swap(X, Y, Command, Command)

_transition(S, draw, [P], SN) :-
    _state_type(S),
    _player_type(P),
    S = _state(St, E, C, B, A, Ps, Ph, Ap),
    _member(P, Ps),
    P = _player(H, [D|L], G, Li, M, Pc),
    PN = _player([D|H], L, G, Li, M, Pc),
    _player_type(PN),
    _deepswap(P, PN, S, SN),
    _state_type(SN).

_transition(S, discard, [P], SN) :-
    _transition(S, discard, [P, _], SN).

_transition(S, discard, [P, C], SN) :-
    _state_type(S),
    _player_type(P),
    S = _state(St, E, Cz, B, A, Ps, Ph, Ap),
    _member(P, Ps),
    P = _player(H, L, G, Li, M, Pc),
    _member(C, H),
    _select(C, H, HN),
    PN = _player(HN, L, [C|G], Li, M, Pc),
    _player_type(PN), 
    _deepswap(P, PN, S, SN),
    SN = _state(St, E, Cz, B, A, PNs, Ph, ApN),
    _state_type(SN).

_transition(S, phase, [], SN) :-
    _state_type(S),
    S = _state([], E, C, B, A, [P|Ps], [upkeep], P),
    SS = _state([], E, C, B, A, [P|Ps], [draw], P),
    _state_type(SS),
    _transition(SS, draw, [P], SN),
    _state_type(SN).

_transition(S, phase, [], SN) :-
    _state_type(S),
    S = _state([], E, C, B, A, [P1, P2|T], [cleanup], P1),
    _snoc(T, P1, TN),
    SN = _state([], E, C, B, A, [P2|TN], [untap], P2),
    _state_type(SN).

% Also end EOT effects and remove damage
_transition(S, phase, [], SN) :-
    _state_type(S),
    S = _state([], E, C, B, A, [P|Ps], [end], P),
    P = _player(H, _, _, _, _, _),
    _len(H, N),
    N < 2,
    SN = _state([], E, C, B, A, [P|Ps], [cleanup], P),
    _state_type(SN).
_transition(S, phase, [], SN) :-
    _state_type(S),
    S = _state([], _, _, _, _, _, [end], P),
    P = _player(H, _, _, _, _, _),
    _len(H, N),
    N > 1,
    _select(Cn, H, _),
    _transition(S, discard, [P, Cn], SS),
    _transition(SS, phase, [], SN),
    _state_type(SN).

_transition(S, resolve, [], SN) :-
    _state_type(S),
    S = _state([Sp|St], E, C, B, A, P, Ph, Ap),
    _spell_type(Sp),
    Sp = _spell(_, _, _, []),
    SN = _state(St, E, C, B, A, P, Ph, Ap),
    _state_type(SN).
_transition(S, resolve, [], SN) :-
    _state_type(S),
    S = _state([Sp|_], _, _, _, _, _, _, _),
    _spell_type(Sp),
    Sp = _spell(C, _, _, [T|_]),
    C = _card(N, Co, SupT, Ty, SubT, [Ef|Efs]),
    _transition(S, Ef, [T], SS),
    _state_type(SS),
    SS = _state([SpS|St], E, Cz, B, A, Ps, Ph, Ap),
    _spell_type(SpS),
    SpS = _spell(_, Cn, Ow, [_|Ts]),
    CN = _card(N, Co, SupT, Ty, SubT, Efs),
    _card_type(CN),
    SpN = _spell(CN, Cn, Ow, Ts),
    _spell_type(SpN),
    SSS = _state([SpN|St], E, Cz, B, A, Ps, Ph, Ap),
    _state_type(SSS),
    _transition(SSS, resolve, [], SN).
