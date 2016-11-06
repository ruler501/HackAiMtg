% Eventually need to add owners
% Eventually need to add tapped

#include 'cards.lp'.

% Non checked accessors
_name(X) :- name(X, _).
_lifecount(X) :- lifecount(X, _).
% Need type checking
_type(X) :- type(X, _).
% What are these?
_effects(X) :- effects(X, _).

% Controller Member
_controller(X) :- controller(X, P), _player_type(P).

% Owner Member(Not currently type checked)
_owner(X) :- owner(X, _).
owner(X, P) :- library(P, L), member(X, L).
owner(X, P) :- graveyard(P, G), member(X, G).
owner(X, P) :- hand(P, H), member(X, H).

% Battlefield Counters
_bcounters(X) :- bcounters(X, L), _bcounter_list(L).
_bcounter_list([]).
_bcounter_list([H|T]) :- _bcounter_type(H), _bcounter_list(T).

% Player Counters
_pcounters(X) :- pcounters(X, L), _pcounter_list(L).
_pcounter_list([]).
_pcounter_list([H|T]) :- _pcounter_type(H), _pcounter_list(T).

% Mana Pool and Costs
% Manapool should not have generic mana in it
_manapool(X) :- manapool(X, L), _mana_list(L).
_cost(X) :- cost(X, L), _mana_list(L).
_mana_list([]).
_mana_list([H|T]) :- _mana_type(H), _mana_list(T).
_mana_type(1).
_mana_type(w).
_mana_type(u).
_mana_type(b).
_mana_type(r).
_mana_type(g).
_mana_type(c).

% Card
_card_type(X) :-
    _owner(X),
    _name(X),
    _cost(X),
    _type(X),
    _effects(X).
_card_list([]).
_card_list([H|T]) :- _card_type(H), _card_list(T).

% Token
_token_type(X) :-
    _owner(X),
    _name(X),
    _cost(X),
    _type(X),
    _effects(X),
    not _card_type(X).

% PermanentCard
_permanent_card_type(X) :- _card_type(X), type(X, artifact).
_permanent_card_type(X) :- _card_type(X), type(X, creature).
_permanent_card_type(X) :- _card_type(X), type(X, enchantment).
_permanent_card_type(X) :- _card_type(X), type(X, land).
_permanent_card_type(X) :- _card_type(X), type(X, planeswalker).

% Spell
_spell_type(X) :- 
    _card_type(X),
    _controller(X).

% Ability
_ability_type(X) :-
    _effects(X),
    _controller(X),
    not _owner(X),
    not _name(X).

% Emblem
_emblem_type(X) :-
    _owner(X),
    _effects(X),
    _controller(X),
    not _name(X).

% Hand member
_hand(X) :- hand(X, H), _card_list(H).

% Library member
_library(X) :- library(X, L), _card_list(L).

% Graveyard member
_graveyard(X) :- graveyard(X, G), _card_list(G).

% Stack member
_stack(X) :- stack(X, S), _stack_elem_list(S).
_stack_elem_type(X) :- _spell_type(X).
_stack_elem_type(X) :- _ability_type(X).
_stack_elem_list([]).
_stack_elem_list([H|T]) :- _stack_elem_type(H), _stack_elem_list(T).

% Exile member
_exile(X) :- exile(X, E), _card_list(E).

% Command member
_command(X) :- command(X, C), _command_elem_list(C).
_command_elem_type(X) :- _card_type(X).
_command_elem_type(X) :- _emblem_type(X).
_command_elem_list([]).
_command_elem_list([H|T]) :- _command_elem_type(H), _command_elem_list(T).

% Permanent
_permanent_type(X) :- _permanent_card_type(X), _bcounters(X), _controller(X).
_permanent_type(X) :- _token_type(X), _bcounters(X), _controller(X).
_permanent_list([]).
_permanent_list([H|T]) :- _permanent_type(H), _permanent_list(T).

% Battlefield
_battlefield(X) :- battlefield(X, B), _permanent_list(B).

% Ante
_ante(X) :- ante(X, A), _card_list(A).

% Player
_player_type(X) :-
    _hand(X),
    _library(X),
    _graveyard(X),
    _lifecount(X),
    _manapool(X),
    _pcounters(X).
_player_list_ne([X]) :- _player_type(X).
_player_list_ne([H|T]) :- _player_type(H), _player_list_ne(T).
_players(X) :- players(X, P), _player_list_ne(P).

% State
_state_type(X) :- 
    _stack(X),
    _exile(X),
    _command(X),
    _battlefield(X),
    _ante(X),
    _players(X).

% Utility Functions
_snoc([], H, [H]).
_snoc([H|T], X, [H|R]) :- _snoc(T, X, R).

member(X, [X|T]).
member(X, [Y|T]) :- member(X, T).
