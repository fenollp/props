%% Copyright © 2018 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(prop_sets).

-include_lib("proper/include/proper.hrl").
-export([prop_union_is_commutative/1]).

prop_union_is_commutative(doc) ->
    "∀ (p, q) ∊ sets:set(T) × sets:set(T), pq = qp";
prop_union_is_commutative(opts) ->
    [{start_size,2}, {max_size,500}, {numtests,999}].
prop_union_is_commutative() ->
    ?FORALL({SetA,SetB}, {a_sets_generator(),a_sets_generator()}
           ,?WHENFAIL(pp(SetA,SetB), prop(SetA,SetB))
           ).

some_simple_type() -> integer().
some_simple_type_buuuut_more_complex() ->
    T = some_simple_type(),
    ?SIZED(Size, proper_types:resize(Size * 8, T)).

a_sets_generator() ->
    ?LET(SomeList, list(some_simple_type_buuuut_more_complex()), sets:from_list(SomeList)).

%%

another_sets_generator() ->
    ?LET(SomeInt, some_simple_type(), sets:from_list([SomeInt])).

prop_union_is_commutative__shrink_harder() ->
    ?FORALL(SetA, another_sets_generator()
           ,?FORALL(SetB, another_sets_generator()
                   ,?WHENFAIL(pp(SetA,SetB), prop(SetA,SetB))
                   )
           ).

%%%

prop(SetA, SetB) ->
    sets:union(SetA, SetB) =:= sets:union(SetB, SetA).

pp(SetA, SetB) ->
    io:format("\nSetA = ~w\nSetB = ~w\n", [sets:to_list(SetA)
                                          ,sets:to_list(SetB)
                                          ]).
