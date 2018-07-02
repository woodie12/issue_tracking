%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Jun 2018 11:08 AM
%%%-------------------------------------------------------------------
-module(handle_get).
-behaviour(cowboy_http_handler).

%% API

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).


init(_Type, Req, _State) ->
  {ok, Req, []}.

handle(Req, _State) ->
  {ID, _Req} = cowboy_req:binding(issueid, Req),
  {ok, Payload} = gen_server:call(issue_tracking_api, {get_issue, binary_to_integer(ID)}),
  {ok, Req2} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>}],
    Payload,
    Req
  ),
  {ok, Req2, []}.

terminate(_Reason, _Req, _State) ->
  ok.