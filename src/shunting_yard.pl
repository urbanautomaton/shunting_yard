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

function("sin").
function("max").
function("min").

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

% First token is an operator, head of opstack isn't op (parenthesis?)
shunt_([Op1|T], Acc, [HStack|TStack], OutTokens) :-
  operator(Op1),
  \+ operator(HStack),
  shunt_(T, Acc, [Op1,HStack|TStack], OutTokens).

% First token is an operator, head of stack is operator
shunt_([Op1|T], Acc, [Op2|TStack], OutTokens) :-
  operator(Op1),
  operator(Op2),
  associativity(Op1, Assoc),
  precedence(Op1, POp1),
  precedence(Op2, POp2),
  shunt_ops_([Op1|T], Assoc, POp1, POp2, Acc, [Op2|TStack], OutTokens).

% First token is a left parenthesis
shunt_(["("|T], Acc, Stack, OutTokens) :-
  !,
  shunt_(T, Acc, ["("|Stack], OutTokens).

% First token is a right parenthesis, head of opstack is left parenthesis
shunt_([")"|T], Acc, ["("|TStack], OutTokens) :-
  !,
  shunt_(T, Acc, TStack, OutTokens).

% First token is a right parenthesis, head of opstack not left parenthesis
shunt_([")"|T], Acc, [Op|TStack], OutTokens) :-
  !,
  shunt_([")"|T], [Op|Acc], TStack, OutTokens).

% First token is a function
shunt_([F|T], Acc, Stack, OutTokens) :-
  function(F),
  !,
  shunt_(T, Acc, [F|Stack], OutTokens).

% First token is a function separator, top of stack is left paren
shunt_([","|T], Acc, ["("|TStack], OutTokens) :-
  !,
  shunt_(T, Acc, ["("|TStack], OutTokens).

% First token is a function separator, top of stack is not left paren
shunt_([","|T], Acc, [HStack|TStack], OutTokens) :-
  HStack \= "(",
  !,
  shunt_([","|T], [HStack|Acc], TStack, OutTokens).

% first token is left-associative, lower or equal precedence
shunt_ops_([Op1|T], left, POp1, POp2, Acc, [Op2|TStack], OutTokens) :-
  POp1 =< POp2,
  !,
  shunt_([Op1|T], [Op2|Acc], TStack, OutTokens).

% first token is left-associative, higher precedence
shunt_ops_([Op1|T], left, POp1, POp2, Acc, [Op2|TStack], OutTokens) :-
  POp1 > POp2,
  !,
  shunt_(T, Acc, [Op1,Op2|TStack], OutTokens).

% first token is right-associative, lower precedence
shunt_ops_([Op1|T], right, POp1, POp2, Acc, [Op2|TStack], OutTokens) :-
  POp1 < POp2,
  !,
  shunt_([Op1|T], [Op2|Acc], TStack, OutTokens).

% first token is right-associative, greater or equal precedence
shunt_ops_([Op1|T], right, POp1, POp2, Acc, [Op2|TStack], OutTokens) :-
  POp1 >= POp2,
  !,
  shunt_(T, Acc, [Op1,Op2|TStack], OutTokens).
