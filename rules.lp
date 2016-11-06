#include 'cards.lp'.

_name(X) :- name(X, _).
_type(X) :- type(X, _).
_effects(X) :- effects(X, _).
_lifecount(X) :- lifecount(X, _).
% Eventually need to add owners
% Eventually need to add tapped
% Eventually need to define mana pools

_bcounters(X) :- counters(X, L), _bcounter_list(L).

_bcounter_list([]).
_bcounter_list([H|T]) :- _bcounter(H), _bcounter_list(T).

_pcounters(X) :- counters(X, L), _pcounter_list(L).

_pcounter_list([]).
_pcounter_list([H|T]) :- _pcounter(H), _pcounter_list(T).

_manapool(X) :- manapool(X, L), _mana_list(L).

_cost(X) :- cost(X, L), _mana_list(L).

_mana_list([]).
_mana_list([H|T]) :- _mana(H), _mana_list(T).

_controller(X) :- controller(X, P), _player(P).

_card(X) :-
    _name(X),
    _cost(X),
    _type(X),
    _effects(X).

_token(X) :-
    _name(X),
    _cost(X),
    _type(X),
    _effects(X),
    not _card(X).

_permanent_card(X) :- _card(X), type(X, artifact).
_permanent_card(X) :- _card(X), type(X, creature).
_permanent_card(X) :- _card(X), type(X, enchantment).
_permanent_card(X) :- _card(X), type(X, land).
_permanent_card(X) :- _card(X), type(X, planeswalker).

_spell(X) :- 
    _card(X),
    _controller(X).

_ability(X) :-
    _effects(X),
    _controller(X),
    not _name(X).

_emblem(X) :-
    _effects(X),
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

_permanent(X) :- _permanent_card(X), _bcounters(X), _controller(X).
_permanent(X) :- _token(X), _bcounters(X), _controller(X).

_battlefield([]).
_battlefield([H|T]) :- _permanent(X),  _battlefield(T).

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



