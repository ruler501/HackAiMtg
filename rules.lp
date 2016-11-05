#include 'cards.lp'.

_name(X) :- name(X, _).
_cost(X) :- cost(X, _).
_type(X) :- type(X, _).
_abilities(X) :- abilities(X, _).
_lifecount(X) :- lifecount(X, _).
_manapool(X) :- manapool(X, _).
_controller(X) :- controller(X, _).
%Eventually need to add owners
%Eventually need to add tapped

_bcounters(X) :- counters(X, []).
_bcounters(X) :- counters(X, L), _bcounter_list(L).

_bcounter_list([]).
_bcounter_list([H|T]) :- _bcounter(H), _bcounter_list(T).

_pcounters(X) :- counters(X, []).
_pcounters(X) :- counters(X, L), _pcounter_list(L).

_pcounter_list([]).
_pcounter_list([H|T]) :- _pcounter(H), _pcounter_list(T).

_card(X) :-
    _name(X),
    _cost(X),
    _type(X),
    _abilities(X).

_card(X) :- morph(X).

_token(X) :-
    _name(X),
    _cost(X),
    _type(X),
    _abilities(X),
    not _card(X).

_permanent(X) :- _card(X), type(X, artifact).
_permanent(X) :- _card(X), type(X, creature).
_permanent(X) :- _card(X), type(X, enchantment).
_permanent(X) :- _card(X), type(X, land).
_permanent(X) :- _card(X), type(X, planeswalker).
_permanent(X) :- morph(X).

_spell(X) :- 
    _card(X),
    _controller(X).

_ability(X) :-
    _abilities(X),
    _controller(X),
    not _name(X).

_emblem(X) :-
    _abilities(X),
    _controller(X),
    not _name(X).

_hand([]).
_hand([H|T]) :- _card(H), _hand(T).

_library([]).
_library([H|T]) :- _card(H), _library(T).

_graveyard([]).
_graveyard([H|T]) :- _card(H), _graveyard(T).

_stack([]).
_stack([H|T]) :- _spell(X), _stack(T).
_stack([H|T]) :- _ability(X), _stack(T).

_exile([]).
_exile([H|T]) :- _card(H), _exile(T).

_command([]).
_command([H|T]) :- _card(H), _command(T).
_command([H|T]) :- _emblem(H), _command(T).

_battlefield([]).
_battlefield([H|T]) :- _permanent(H), _bcounters(H), _controller(H), _battlefield(T).

_ante([]).
_ante([H|T]) :- _card(H), _ante(T).

_player(X) :-
    player_hand(X, H),
    player_library(X, L),
    player_graveyard(X, G),
    _hand(H),
    _library(L),
    _graveyard(G),
    _lifecount(X),
    _manapool(X),
    _pcounters(X).

_players([X]) :- _player(X).
_players([H|T]) :- _player(H), _players(T).

_state(S, E, C, B, A, P) :- 
    _stack(S),
    _exile(E),
    _command(C),
    _battlefield(B),
    _ante(A),
    _players(P).



