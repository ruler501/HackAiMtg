struct State
{
    Stack_Elem Stack;
    Card[] Exile;
    Command_Elem[] Command;
    Permanent[] Battlefield;
    Card[] Ante;
    // Nonempty
    Player[] Players;
    // Nonempty
    Phase[] Phases;
    Player ActivePlayer;
};

union Stack_Elem {
    Spell spell;
    Ability ability;
};

union Command_Elem {
    Card card;
    Emblem emblem;
};

struct Player
{
    Card[] Hand;
    Card[] Library;
    Card[] Graveyard;
    Any lifecount;
    // Nonempty
    Mana[] ManaPool;
    Player_Counter[] Counters;
};

enum Player_Counter {
    Experience;
    Poison;
    Energy;
};

enum Battlefield_Counter {
    PoPo;
    MoMo;
    Charge;
};

enum Mana {
    1;
    C;
    W;
    U;
    B;
    R;
    G;
};

enum Type {
    Artifact;
    Creature;
    Enchantment;
    Land;
    Planeswalker;
    Instant;
    Sorcery;
    Tribal;
};

enum SuperType {
    Legendary;
    Basic;
    Snow;
    World;
};

enum SubType {
    Equipment;
    Aura;
    Swamp;
    Elf;
    Jace;
    Arcane;
    Trap;
    Wizard;
    Saproling;
};

enum Phase {
    Untap;
    Upkeep;
    Draw;
    Premain;
    Begcombat;
    DeclareAttack;
    DeclareBlock;
    CombatDamage;
    EndCombat;
    PostMain;
    End;
    Cleanup;
};

enum Effect {
    draw;
    discard;
};

struct Spell
{
    Card Card;
    Player Controller;
    Player Owner;
    Any[] Targets;
};

struct Ability     // Object on the stack
{
    //Has no name
    Effect[] Effects;
    Player Controller;
};

struct Card
{
    any name;
    Mana[] Cost;
    Supertype[] Supertypes;
    // Nonempty
    Type[] Types; //Has multiple values in some cases
    Subtype[] Subtypes
    Effect[] Effects;
};

struct Emblem
{
    //Has no name
    Effect[] effects;
    Player controller;
    Player Owner;
};

struct Permanent
{
    Permanent_Type PermanentType;
    Battlefield_Counter[] counters;
    Player controller;
};

union Permanent_Type {
    Permanent_Card PermanentCard;
    Token Token;
};

struct Token
{
    //Not a card
    Mana[] Cost;
    Type[] Types;
    Effect[] Effects;
};
