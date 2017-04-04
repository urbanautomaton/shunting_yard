% vim: set ft=prolog:

:- [src(shunting_yard)].

:- begin_tests(to_postfix).

test(to_postfix_addition) :-
  to_postfix("3 + 4", "3 4 +").

test(to_postfix_addition_with_multiplication) :-
  to_postfix("3 + 4 * 5", "3 4 5 * +").

test(to_postfix_addition_and_mult_with_parens) :-
  to_postfix("( 3 + 4 ) * 5", "3 4 + 5 *").

test(to_postfix_with_all_the_math) :-
  to_postfix("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3", "3 4 2 * 1 5 - 2 3 ^ ^ / +").

test(to_postfix_simple_function) :-
  to_postfix("max ( 2 , 3 )", "2 3 max").

test(to_postfix_with_nested_functions) :-
  to_postfix("max ( 2 , min ( 3 , 4 ) )", "2 3 4 min max").

test(to_postfix_with_all_sorts) :-
  to_postfix("sin ( max ( 2 , 3 ) / 3 * 3.1415 )", "2 3 max 3 / 3.1415 * sin").

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
