struct State
{
    Stack s;
    Exile e;
    Command c;
    Battlefield b;
    Ante a;

    // Nonempty
    Player[] p;
};

union StackElem {
    Spell spell;
    Ability ability;
};
using Stack = StackElem[];

using Exile = Card[];

union CommandElem {
    Card card;
    Emblem emblem;
};
using Command = CommandElem[];

using Battlefield = Permanent[];

using Ante = Card[];

struct Player
{
    Hand player_hand;
    Library player_library;
    Graveyard player_graveyard;
    int lifecount;
    ManaPool manapool;
    PlayerCounters counters;
};
using Hand = Card[];
using Library = Card[];
using Graveyard = Card[];

using ManaPool = Mana[];
using PlayerCounters = PlayerCounter[];

// TODO Fill
enum PlayerCounter {};

struct Spell : Card
{
    Player controller;
};

struct Ability     // Object on the stack
{
    //Has no name
    Effects effects;
    Player controller;
};

struct Card
{
    string name;
    Cost cost;
    Type type; //Has multiple values in some cases
    Effects effects;
};
using Cost = Mana[];
using Effects = Effect[];

struct Emblem
{
    //Has no name
    Effects effects;
    Player controller;
};

struct Permanent : (PermanentCard || Token)
{
    BattlefieldCounters counters;
    Player controller;
};

//TODO Effect
enum Type {};

struct PermanentCard : Card
{
    Type type; //Artifact, creature, enchantment, land, planeswalker
};

struct Token
{
    //Not a card
    string name;
    Cost cost;
    Type type;
    Effects effects;
};
