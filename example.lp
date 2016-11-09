#include 'rules.lp'.

?- V = _card('Ornithopter', [], [], [creature], [], []),
     C3 = _card('Ancestral Recall', [u], [], [instant], [], [draw, draw, draw]),
     Sp = _spell(C3, P, P, [P, P, P]),
     P = _player([], [V,V,V], [], 40, [], []),
     P2 = _player([], [], [], 40, [], []),
     S = _state([Sp], [], [], [], [], [P], [end], P),
     _state_type(S),
     _transition(S, resolve, [], SN),
     _transition(SN, phase, [], SNN).
    

