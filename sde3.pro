/*
Marshall Clyburn
CPSC 3520
SDE #3
*/

/* (1) calcNet(+Input, +Weights, -Net)
       single unit net activation computation */
calcNet([], [], X) :- X is 0.
calcNet([Input_head|Input_tail], [Weights_head|Weights_tail], Net) :-
	calcNet(Input_tail, Weights_tail, Tail_net),
	Net is (Input_head * Weights_head) + Tail_net.

/* (2) squash_tanh(+Net, -Output)
       tanh activation or 'squashing' function */
squash_tanh(Net, Output) :-
	Output is (exp(Net) - exp(-1 * Net)) / (exp(Net) + exp(-1 * Net)).

/* (3) unit_tanh(+Inputs, Weights, -Output)
       single unit implementation */
unit_tanh(Input, Weights, Output) :-
	calcNet(Input, Weights, Net),
	squash_tanh(Net, Output).
