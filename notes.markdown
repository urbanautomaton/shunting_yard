# Ben's BASIC interpreter

* wanted to run old BASIC games like traitor's castle
* started off as regular expressions
* kept hitting new cases that needed to be interpreted

* generates a method per line, needs to handle arbitrary gotos and global state

BUT

monsters of galacticon was super tricky, stopped work for 6 years

hit a line that the existing eval-based strategy (where Ben basically
eval'd each line's expression in a certain context) didn't work for
(abusing > to mean 0 or 1)

=> wrote a proper expression parser

turns arbitrary infix expressions into RPN expressions

[aside: Leo: why are the line numbers multiples of 10?  well, if you
realise you need to insert a line between 10 and 20, you can define a
new line 15 without renumbering everything (then use RENUMBER to print a
rebased listing)]


# RPN then, wtf

Infix notation leads to ambiguities about evaluation order e.g.

10 + 2 * 3 => (10 + 2) * 3 or 10 + (2 * 3) ?

operator precedence is a convention to standardise this without
parentheses

RPN / postfix notation lets you express these unambiguously (given you
know the operator arity)

10 2 3 * +
2 3 * 10 +

both equivalent

discussed stack-based evaluation strategy for RPN expressions

Tom: a kind of VM, with two ops:

1. push a value onto the stack
2. pop values off, perform an operation, push answer

=> RPN expressions are programs for this VM

Matt: how does this vary from lisp-style prefix notation?

Tom: this allows step-by-step evaluation, with a program counter moving
along the expression token by token (stack-based vm vs register-based)

# THE SHUNTING YARD ALGORITHM THEN

Discussed basic algo vs multi precedence levels version. I dunno.

consider

L O L O L O L
2 + 3 - 4 + 5

Tuzz: basic case you simply

1. push operators to the stack
2. push literals to the output, clearing the stack afterwards

This doesn't model precedence at all (or rather, assumes all ops are of
equal precedence)

MULTI PRECEDENCE THEN

consider

L O L O L O L
2 + 3 * 4 + 5

precedences
* 2
+ 1
- 1

we worked through this on the board. choo-choo noises were made.

RIGHT ASSOCIATIVITY THEN

Associativity implies a precedence among equal operators

e.g. 1 + 2 + 3 => (1 + 2) + 3 because + is left-associative
(and it doesn't matter because + is associative, i.e. (1 + 2) + 3 === 1 + (2 + 3)

whereas 1 ^ 2 ^ 3 => 1 ^ (2 ^ 3) because ^ is (conventionally) right-associative

BRACKETS THEN

FUNCTIONS THEN

[WE DECIDED TO SKIP BRACKETS AND FUNCTIONS AND MOB AN IMPLEMENTATION]

# THE MOBBING COMMENCES

[GREAT AMOUNT OF PAUL DOING VIM STUFF CENSORED]

Started with ShuntingYard.shunt, some shade was thrown on this by Tom
and we created (GASP) an OBJECT

[INTERLUDE FOR TRAIN TERMINOLOGY DISCUSSION]

We decided that the stack was in fact a siding, and the whole object was
the yard. This was approved.

We ended the metaphor when Paul tried to call tokens "cars".

Quickly got to the basic implementation and started on precedence

Defined precedence using multiples of 10 as a BASIC callback, not that
BASIC supported callbacks, but never mind that now

[NOISES OF JOEL PLAYING WITH WOODEN TRAINS BROUGHT BY BEN]

[MORE VIM NONSENSE CENSORED]

Chris Z CONTROVERSIALLY converted us from "siding" to "operator_stack",
boo

"Could someone take me through it like I'm a child"

[TOM LIVESTREAMS HIS OWN FEET FOR SEVERAL SECONDS]

Okay, so we've got our stuff to the point where basic precedence works
(no associativity), we decide to do parentheses next to override
precedence in local circumstances

Ben: it's basically like you're creating a new stack - whatever happens
inside the parens, the whole output of the inner expression should end
up in the output, and then it continues as if nothing had ever happened.

Leo: what if we just create a new stack and recurse on the inner
expression?

We talked this through and thought this might be a lot of complexity -
we either need to decide how much of the input to pass down, or have
some mechanism for passing the remainder up from the recursive calls.

Implemented it using the stack approach.

Tuzz: Can we hack the precedence system to implement brackets without a
special case? e.g. '(' has super high prec, ')' super low

Tom: well, they're kinda special cased anyway in that they disappear in
the final output, so maybe we don't get simpler anyway

Tuzz: could we move the special casing into an output filter that just
rejects all paren tokens?

All: MAYBE WE COULD

Mudge: [SOUNDS OF TYPING]

All: OMG THAT ACTUALLY WORKED

Me: but we've set ')' to minus infinity prec, doesn't this clear the
ENTIRE opstack instead of just up until the first '('

Mudge: [SOUNDS OF TYPING]

All: YES IT DOES

Tom: I WANT TO PLAY WITH TRAINS

All: [MURMURED APPROVAL]

# MUDGEROSPECTIVE

This meeting. How was it eh

Joel: purpose of this was to feel less like it's a long book haul, let
more people in. Was this good?

general murmurs of assent. maybe we haven't had loads of extra attendees
but it felt refreshing innit. Takes pressure off the regular TAPL
leaders.

<3 <3 <3 <3 <3 <3 <3

Organisation: next time we should

1. pick an organiser
2. organise it more than 7-10 days in advance so if there's an obvious
   person who's sharing a thing, they can prep

ACTION: identify the next natural break, it might not be part 2 of the
book

## NEXT MEETING

when is it: next tues Gecko can't host and it's right after Easter. Do
we push back, push forward?

All: not forward eh

Mudge: TO THE BAT-DOODLE!

All: nods of assent

Mudge: AN ORGANISER THEN?

All: [UNCOMFORTABLE SILENCE]

Abeer: I WILL DO THIS THING

All: [TUMULTUOUS ACCLAIM]
