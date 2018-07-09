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
%%            {"/issues", issue_handler, [list]},
%%            {"/issues/add", issue_handler, [add]},
%%            {"/get/:issueid", issue_handler,[get]},
%%            {"/update/:issueid", issue_handler, [update]},
%%            {"/delete/:issueid", issue_handler,[delete]},

            {"/issues/list", handle_list, []},
            {"/issues/:issueid", handle_get, []},
            {"/issues/add", handle_set, []},
            {"/issues_delete/:issueid", handler_delete, []}
        ]}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    {ok, _} = cowboy:start_http(my_http_listener, 100,
        [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    'issue_tracking_sup':start_link().


%%--------------------------------------------------------------------
stop(_State) ->
    ok.
%%====================================================================
%% Internal functions
%%====================================================================
