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



-record(state, {op}).


init(Req, Opts) ->
  [Op | _] = Opts,
  State = #state{op=Op},
  {cowboy_rest, Req, State}.


allowed_methods(Req, State) ->
  Methods = [<<"GET">>, <<"POST">>, <<"DELETE">>],
  {Methods, Req, State}.

content_types_provided(Req, State) ->
  {[
    {<<"application/json">>, db_to_json}
  ], Req, State}.

db_to_json(Req, #state{op=Op} = State) ->
  {Body, Req1, State1} = case Op of
                           list ->
                             get_record_list(Req, State);
                           get ->
                             get_one_record(Req, State);
                           help ->
                             get_help(Req, State)
                         end,
  {Body, Req1, State1}.

