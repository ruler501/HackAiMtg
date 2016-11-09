#include 'types.lp'.

_permanent_card_type(Card) :-
    _card_type(Card),
    Card = _card(_, _, _, L, _, _),
    _contain(L, [artifact, creature, enchantment, land, planeswalker, tribal]).

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
    N < 8,
    SN = _state([], E, C, B, A, [P|Ps], [cleanup], P),
    _state_type(SN).
_transition(S, phase, [], SN) :-
    _state_type(S),
    S = _state([], _, _, _, _, _, [end], P),
    P = _player(H, _, _, _, _, _),
    _len(H, N),
    N > 7,
    _select(Cn, H, _),
    _transition(S, discard, [P, Cn], SS),
    _transition(SS, phase, [], SN),
    _state_type(SN).

_transition(S, resolve, [], SN) :-
    _state_type(S),
    S = _state([Sp|St], E, C, B, A, P, Ph, Ap),
    _spell_type(Sp),
    Sp = _spell(Cd, _, O, []),
    _player_type(O),
    _card_type(Cd),
    O = _player(H, L, G, Lc, M, Pc),
    ON = _player(H, L, [Cd|G], Lc, M, Pc), 
    SS = _state(St, E, C, B, A, P, Ph, Ap),
    _state_type(SS),
    _deepswap(O, ON, SS, SN),
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


?- V = _card('Ornithopter', [], [], ['Creature'], [], []),
     C3 = _card('Ancestral Recall', ['U'], [], ['Instant'], [], [draw, draw, draw]),
     Sp = _spell(C3, P, P, [P, P, P]),
     P = _player([], [V,V,V], [], 40, [], []),
     P2 = _player([], [], [], 40, [], []),
     S = _state([Sp], [], [], [], [], [P], ['End'], P),
     _card_type(V),
     _card_type(C3),
     _card_list([V,V,V]),
     _player_type(P),
     _spell_type(Sp),
     _player_type(P2),
     _stack_elem_list([Sp]),
     _player_list_ne([P]),
     _phase_list_ne(['End']),
     _member(P, [P]),
     _state_type(S),
     _transition(S, resolve, [], SN).
