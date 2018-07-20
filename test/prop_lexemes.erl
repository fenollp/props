%% Copyright © 2018 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(prop_lexemes).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-export([prop_lexemes/1]).

prop_lexemes(doc) ->
    "Sooo string:lexemes/2 is broken on OTP21.0?";
prop_lexemes(opts) ->
    [{numtests, 500}].

prop_lexemes() ->
    Char = $\n,
    ?FORALL({Count,Str}, interspersed_string(Char), verify(Char,Count,Str)).

verify(Char, Count, Str) ->
    Split = [_|_] = string:lexemes(Str, [Char]),
    OK = Count == length(Split),
    %% OK orelse io:format(user, "\n>>> ~p -~p-> ~p\n", [Str,length(Split),Split]),
    OK.

verify_test_() ->
    Char = $\r,
    [?_assert(verify(Char, 2, "a\rb"))
    ,?_assert(verify(Char, 3, "a\rb\rc"))
    ,?_assert(not verify(Char, 3, "a\rb\rc\rd"))
    ].

interspersed_string(Char) ->
    ?LET(Count, integer(2, inf)
        ,?LET(Str, nonempty_string()
             ,begin
                  Strs = lists:duplicate(Count, Str),
                  IOList = lists:join(Char, Strs),
                  %% io:format(user, "\n>> ~p ~p\n", [Count, IOList]),
                  {Count, lists:flatten(IOList)}
              end
             )
        ).
