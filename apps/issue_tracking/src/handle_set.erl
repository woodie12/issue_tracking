%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Jun 2018 11:14 AM
%%%-------------------------------------------------------------------
-module(handle_set).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

%% API
init(_Type, Req, _State) ->
  {ok, Req, []}.

handle(Req, _State) ->
  {ID, _Req} = cowboy_req:binding(issuepid, Req),
  respond(Req, ID, cowboy_req:has_body(Req)).

respond(Req, ID, true) ->
  {ok, Body, _Req} = cowboy_req:body(Req),
  io:format("BODY: ~p~n", [Body]),
  {ok, Payload} = gen_server:call(rest_api, {update_issue, binary_to_integer(ID), Body}),
  {ok, ReqNew} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>},
      {<<"Access-Control-Allow-Origin">>, <<"*">>}], % chrome security
    Payload,
    Req
  ),
  {ok, ReqNew, []};

respond(Req, ID, false) ->
  {ok, Payload} = gen_server:call(rest_api, {get_issue, binary_to_integer(ID)}),
  {ok, ReqNew} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>}],
    Payload,
    Req
  ),
  {ok, ReqNew, []}.

terminate(_Reason, _Req, _State) ->
  ok.