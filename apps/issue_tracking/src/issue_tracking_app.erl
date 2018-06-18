%%%-------------------------------------------------------------------
%% @doc issue_tracking public API
%% @end
%%%-------------------------------------------------------------------

-module(issue_tracking_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================
start() ->
    application:start(cowboy),
    application:start(issue_tracking).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_',
            [
                {"/issue/list", issue_handler, [{op,list}]},
                {"/issue/:issue_id", issue_handler, [{op,get}]},
                {"/issue/create", issue_handler, [{op, create}]},
                {"/issue/update/:issue_id", issue_handler, [{op, update}]},
                {"/issue/delete/:issue_id", issue_handler, [{op, delete}]}
            ]}
    ]),
    cowboy:start_listener(my_http_listener, 1,
        cowboy_tcp_transport, [{port, 8080}],
        cowboy_http_protocol, [{dispatch, Dispatch}]
    ).


%%--------------------------------------------------------------------
stop(_State) ->
    application:stop(cowboy).

%%====================================================================
%% Internal functions
%%====================================================================
