/*
    ANU - An artificial neuron unit.
    Copyright (C) 2016  Marshall Clyburn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/* (1) calcNet(+Input, +Weights, -Net)
       single unit net activation computation */
calcNet([], [], X) :- X is 0.
calcNet([Input_head | Input_tail], [Weights_head | Weights_tail], Net) :-
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

/* (4) compute_tanh_outputs(+H, +Weights, -OutputList)
       Using tanh squasher OutputList is a list of the outputs of the trained unit
       over H */
compute_tanh_outputs([], _, []).
compute_tanh_outputs([[H_head_head | _] | H_tail], Weights, OutputList) :-
	unit_tanh(H_head_head, Weights, Output),
	compute_tanh_outputs(H_tail, Weights, Output_tail),
	append([Output], Output_tail, OutputList).

/* (5) compute_TSS(+T, +O, -TSS)
       TSS of a vector T-O
       2 x E^p in Equation (3). */
compute_TSS([], [], 0).
compute_TSS([T_head | T_tail], [O_head | O_tail], TSS) :-
	compute_TSS(T_tail, O_tail, Tail_TSS),
	TSS is ((T_head - O_head) ** 2) + Tail_TSS.

/*    generate_T_list(+H, -T)
      Extract the T values from H into T. */
generate_T_list([], []).
generate_T_list([[_ | [[H_head_tail_head_head | _] | _]] | H_tail], T) :-
	generate_T_list(H_tail, T_tail),
	append([H_head_tail_head_head], T_tail, T).

/* (6) tss_tanh(+H, +Weights, -TSS)
       compute TSS of tanh Unit Error over H, given unit weights.
       See Equation (4). build list for output from squasher and lone value, pass to compute_TSS*/
tss_tanh(H, Weights, TSS) :-
	compute_tanh_outputs(H, Weights, Output_list),
	generate_T_list(H, T_list),
	compute_TSS(T_list, Output_list, TSS).

/* (7) validate_tanh(+H, +FW, -E)
       tanh squasher VALIDATION
       Given unit weights in list FW, computes list, E, of output errors
       with elements e = t - o
       corresp. to each element of H.
       No printing in this version. */
validate_tanh([], _, []).
validate_tanh([[H_head_head | [[H_head_tail_head_head | _] | _]] | H_tail], FW, E) :-
	unit_tanh(H_head_head, FW, Output),
	validate_tanh(H_tail, FW, E_tail),
	Error is (H_head_tail_head_head - Output),
	append([Error], E_tail, E).

/*     print_list(+List)
       Print out the contents of a list with each member followed
       with a newline. */
print_list([]).
print_list([List_head | List_tail]) :-
	write_term(List_head, []),
	nl,
	print_list(List_tail).

/* (8) validate_tanh_print(+H, +FW)
       validate version with printing */
validate_tanh_print(H, W) :-
	validate_tanh(H, W, E),
	print_list(E).
