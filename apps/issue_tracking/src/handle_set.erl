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


-export([
  allowed_methods/2,
  content_types_accepted/2,
  content_types_provided/2
]).
%% API
init(_Type, Req, _State) ->
  io:format("-----!!-----enter the post-----!!------"),
  {ok, Req, []}.

handle(Req, _State) ->
%%  {ID, _Req} = cowboy_req:binding(issueid, Req),
  io:format("----------enter the post-----------"),
  respond(Req, cowboy_req:has_body(Req)).

%%
%% One example of post (TODO)
%%-export([init/3]).
%%
%%-export([welcome/2, terminate/3, allowed_methods/2]).
%%-export([content_types_accepted/2]).
%%init(_Transport, _Req, []) ->
%%  {upgrade, protocol, cowboy_rest}.
%%allowed_methods(Req, State) ->
%%  {[<<"POST">>], Req, State}.
%%content_types_accepted(Req, State) ->
%%  {[{<<"application/json">>, welcome}], Req, State}.
%%terminate(_Reason, _Req, _State) ->
%%  ok.
%%welcome(Req, State) ->
%%  {ok, ReqBody, Req2} = cowboy_req:body(Req),
%%  Req_Body_decoded = jsx:decode(ReqBody),
%%  [{<<"title">>,Title},{<<"content">>,Content}] = Req_Body_decoded,
%%  Title1 = binary_to_list(Title),
%%  Content1 = binary_to_list(Content),
%%  io:format("Title1 is ~p ~n ", [Title1]),
%%  io:format("Content1 is ~p ~n", [Content1]),
%%  io:format("Title is ~p ~n", [Title]),
%%  io:format("Content is ~p ~n", [Content]),
%%  lager:log(info, [], "Request Body", [Req_Body_decoded]),
%%  Res1 = cowboy_req:set_resp_body(ReqBody, Req2),
%%  Res2 = cowboy_req:delete_resp_header(<<"content-type">>, Res1),
%%  Res3 = cowboy_req:set_resp_header(<<"content-type">>, <<"application/json">>, Res2),
%%  {true, Res3, State}.
%%

%% generate random issue id
new_issue_id() ->
  Initial = rand:uniform(62) - 1,
  new_issue_id(<<Initial>>, 7).

new_issue_id(Bin, 0) ->
  Chars = <<"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890">>,
  << <<(binary_part(Chars, B, 1))/binary>> || <<B>> <= Bin >>;

new_issue_id(Bin, Rem) ->
  Next = rand:uniform(62) - 1,
  new_issue_id(<<Bin/binary, Next>>, Rem - 1).

allowed_methods(Req, State) ->
  lager:debug("allowed_methods"),
  {[<<"GET">>, <<"POST">>], Req, State}.

content_types_accepted(Req, State) ->
  lager:debug("content_types_accepted"),
  {[
    {{<<"application">>, <<"json">>, []}, post_json}
  ], Req, State}.

content_types_provided(Req, State) ->
  lager:debug("content_types_provided"),
  {[
    {{<<"application">>, <<"json">>, []}, get_json}
  ], Req, State}.


respond(Req, true) ->
  ID = rand:uniform(999999),
%%  in:format("ID is ~n",[ID]),
  {ok, Body, _Req} = cowboy_req:body(Req),
  {ok, Payload} = gen_server:call(issue_tracking_api, {add_issues, ID, Body}),
  {ok, ReqNew} = cowboy_req:reply(200,
    [{<<"content-type">>, <<"application/json">>}], % chrome security
    Payload,
    Req
  ),
  io:format("---333----~p",[ReqNew]),

  {ok, ReqNew, []};

respond(Req, false) ->
%%  {ok, Payload} = gen_server:call(issue_tracking_api, {get_issue}),
  {ok, ReqNew} = cowboy_req:reply(404,
    [{<<"content-type">>, <<"application/json">>}],
    Req
  ),
  {ok, ReqNew, []}.

terminate(_Reason, _Req, _State) ->
  ok.
