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
            {"/", top_handler, []},
            {"/issues", handle_list, []},
            {"/issues/:issueid", handler_emp_get, []},
            {"/issues/add", handler_emp_add, []},
            {"/issues_delete/:issueid", handler_emp_delete, []}
        ]}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    'issue_tracking_sup':start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.
%%====================================================================
%% Internal functions
%%====================================================================
