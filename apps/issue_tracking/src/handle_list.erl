%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Jul 2018 12:48 PM
%%%-------------------------------------------------------------------
-module(handle_list).
-author("wan").
-behaviour(cowboy_http_handler).

%% API

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).


init(_Type, Req, _Opts) ->
  {ok, Req, []}.



handle(Req, _State) ->
  {ok, Payload} = gen_server:call(issue_tracking_api, {get_list}),
  {ok, Req2} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>}],
    Payload,
    Req
  ),
  io:format("---444---~p",[Req2]),
  {ok, Req2, []}.



terminate(_Reason, _Req, _State) ->
  ok.
%% API
