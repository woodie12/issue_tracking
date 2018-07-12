%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Jul 2018 8:01 AM
%%%-------------------------------------------------------------------
-module(handle_delete).
-author("wan").

%% API
-behaviour(cowboy_http_handler).

%% API

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).


init(_Type, Req, _State) ->
  {ok, Req, []}.

handle(Req, _State) ->
  {ID, _Req} = cowboy_req:binding(issueid, Req),
  io:format("enter delete    id is ~p", [binary_to_integer(ID)]),
  {ok, Payload} = gen_server:call(issue_tracking_api, {delete_issues, binary_to_integer(ID)}),
  {ok, Req2} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>},{<<"Access-Control-Allow-Origin">>, <<"*">>}],
    Payload,
    Req
  ),
  io:format("---delete---~p",[Req2]),
  {ok, Req2, []}.





terminate(_Reason, _Req, _State) ->
  ok.
