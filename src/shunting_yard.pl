% vim: set ft=prolog:

to_postfix(In, Out) :-
  tokenize(In, InTokens),
  shunt(InTokens, OutTokens),
  detokenize(OutTokens, Out).

tokenize(String, Tokens) :-
  split_string(String, " ", " ", Tokens).

detokenize([], "").
detokenize([X], X) :- !.
detokenize([HToken|TTokens], String) :-
  detokenize(TTokens, TString),
  string_concat(HToken, " ", HString),
  string_concat(HString, TString, String).

operator("^").
operator("*").
operator("/").
operator("+").
operator("-").

precedence("^", 4).
precedence("*", 3).
precedence("/", 3).
precedence("+", 2).
precedence("-", 2).

associativity("^", right).
associativity("*", left).
associativity("/", left).
associativity("+", left).
associativity("-", left).

shunt(Tokens, OutTokens) :-
  shunt_(Tokens, [], [], OutTokens), !.

% the output queue gets built reversed cos it's easier to use [H|T], so
% reverse it once done
shunt_([], OutTokensRev, [], OutTokens) :-
  reverse(OutTokensRev, OutTokens).

% Input finished - pop the opstack onto the output queue
shunt_([], Acc, [H|T], OutTokens) :-
  shunt_([], [H|Acc], T, OutTokens).

% First token is a number - place on the output queue
shunt_([NA|T], Acc, Stack, OutTokens) :-
  atom_number(NA, _),
  shunt_(T, [NA|Acc], Stack, OutTokens).

% First token is an operator, opstack is empty
shunt_([Op1|T], Acc, [], OutTokens) :-
  operator(Op1),
  shunt_(T, Acc, [Op1], OutTokens).

% First token is an operator, left associative with lower or equal precedence
% to head of opstack
shunt_([Op1|T], Acc, [Op2|TStack], OutTokens) :-
  associativity(Op1, left),
  precedence(Op1, POp1),
  precedence(Op2, POp2),
  POp1 =< POp2,
  shunt_([Op1|T], [Op2|Acc], TStack, OutTokens).

% First token is an operator, right associative with lower precedence than
% head of opstack
shunt_([Op1|T], Acc, [Op2|TStack], OutTokens) :-
  associativity(Op1, right),
  precedence(Op1, POp1),
  precedence(Op2, POp2),
  POp1 < POp2,
  shunt_([Op1|T], [Op2|Acc], TStack, OutTokens).

% First token is an operator with greater precedence than head of opstack
shunt_([Op1|T], Acc, [Op2|TStack], OutTokens) :-
  precedence(Op1, POp1),
  precedence(Op2, POp2),
  POp1 > POp2,
  shunt_(T, Acc, [Op1,Op2|TStack], OutTokens).
