%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2018 10:45 AM
%%%-------------------------------------------------------------------
-module(issue_handler).
-author("wan").


%% API
-export([init/2]).

-record(state, {op, response}).


init(Req, Opts) ->
  [{op, Op} | _] = Opts,
  State = #state{op=Op, response=none},
  {cowboy_rest, Req, State}.
