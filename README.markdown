# shunting yard algorithm

Prolog implementation of the [shunting yard
algorithm](https://en.wikipedia.org/wiki/Shunting-yard_algorithm) for
[computation
club](https://groups.google.com/d/msg/london-computation-club/8-cfsPjg-ck/jb1l9jALAgAJ).

## To run

You'll need swi-prolog installed. On Mac using homebrew:

    $ brew install swi-prolog

On other systems I think there's someone you can telephone.

Then to run the tests:

    $ make test

And to run it interactively:

    $ make console
    ?- to_postfix("3 + 4", I).
    I = "3 4 +".
