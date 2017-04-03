% vim: set ft=prolog:

:- [src(shunting_yard)].

:- begin_tests(to_postfix).

test(to_postfix_addition) :-
  to_postfix("3 + 4", "3 4 +").

test(to_postfix_addition_with_multiplication) :-
  to_postfix("3 + 4 * 5", "3 4 5 * +").

test(to_postfix_addition_and_mult_with_parens) :-
  to_postfix("( 3 + 4 ) * 5", "3 4 + 5 *").

:- end_tests(to_postfix).

:- begin_tests(tokenize).

test(tokenize_addition) :-
  tokenize("3 + 4", ["3", "+", "4"]).

test(tokenize_extra_whitespace) :-
  tokenize(" a + b - sin 5  ", ["a", "+", "b", "-", "sin", "5"]).

:- end_tests(tokenize).

:- begin_tests(detokenize).

test(detokenize_addition) :-
  detokenize(["3", "+", "4"], "3 + 4").

test(detokenize_extra_whitespace) :-
  detokenize(["a", "+", "b", "-", "sin", "5"], "a + b - sin 5").

:- end_tests(detokenize).
