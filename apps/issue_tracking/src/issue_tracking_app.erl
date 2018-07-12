%%%-------------------------------------------------------------------
%% @doc issue_tracking public API
%% @end
%%%-------------------------------------------------------------------

-module(issue_tracking_app).

-behaviour(application).

%% Application callbacks


%%====================================================================
%% API
%%====================================================================


%% Application callbacks
-export([start/2
    ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->

    Dispatch = cowboy_router:compile([
        %% {HostMatch, list({PathMatch, Handler, Opts})}
        {'_', [
            {"/issues/list", handle_list, []},
            {"/issues_set/add", handle_set, []},
            {"/issues/:issueid", handle_get, []},
            {"/issues_delete/:issueid", handle_delete, []}
        ]}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    {ok, _} = cowboy:start_http(my_http_listener, 100,
        [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    issues_db:initial_setup(),
    issue_tracking_sup:start_link().


%%--------------------------------------------------------------------
stop(_State) ->

    ok.
%%====================================================================
%% Internal functions
%%====================================================================
