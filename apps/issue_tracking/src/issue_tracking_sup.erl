%%%-------------------------------------------------------------------
%% @doc issue_tracking top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(issue_tracking_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).



%%====================================================================
%% Supervisor callbacks
%%====================================================================
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_one, 100, 60}, [

        #{ id => issue_tracking_api,
            start => {issue_tracking_api, start_link, []},
            restart => permanent,
            shutdown => 1000,
            type => worker }

    ]} }.
%%====================================================================
%% Internal functions
%%====================================================================
