%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Jun 2018 10:13 AM
%%%-------------------------------------------------------------------
-module(issue_tracking_api).
-author("wan").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).
-define(IMPLEMENTATION_MODULE, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> {ok, pid()}.

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?IMPLEMENTATION_MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------

%%-spec(init(Args :: term()) ->
%%  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
%%  {stop, Reason :: term()} | ignore).

init([]) ->
  {ok, []}.

%%  {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).

%%handle_call(_Request, _From, State) ->
%%  {reply, ok, State}.

handle_call({get_issues, ID}, _From, State) ->
  {ok, Issues} = issues_db:get_issues(ID),
  Reply = {ok, jsx:encode(Issues)},
  {reply, Reply, State};


handle_call({update_issues, ID, Issue}, _From, State) ->
  IssDecoded = jsx:decode(Issue, [return_maps]),
  Title = maps:get(<<"title">>, IssDecoded),
  Content = maps:get(<<"content">>, IssDecoded),
  {ok, IssNew} = issues_db:update_issues(ID, Title, Content),
  Reply = {ok, jsx:encode(IssNew)},
  {reply, Reply, State};



handle_call({add_issues, Id, Issue}, _From, State) ->
%%  TODO: add create time and modified time in post and update!!!!!
  io:format("Issue is ~p", [binary_to_list(Issue)]),
  IssDecoded = jsx:decode(Issue, [return_maps]),
  Title = maps:get(<<"title">>, IssDecoded),
  io:format("title is ~p",[Title]),

  Content = maps:get(<<"content">>, IssDecoded),
  {ok, IssNew} = issues_db:add_issues(Id, Title, Content),
  io:format("-----000----issnew is ~p",[jsx:encode(IssNew)]),
  Reply = {ok, jsx:encode(IssNew)},
  {reply, Reply, State};

%%get list for database
handle_call({get_list},_From, State) ->
  {ok, List} = issues_db:get_issue(),
  io:format("===List1 is ==~p",[List]),
  List2 = lists:map(fun erlang:tuple_to_list/1, List),
  io:format("===List 2is ==~p",[List2]),
  Reply = {ok, jsx:encode(List2)},
  {reply, Reply, State};


handle_call(_Request, _From, State) ->
  Reply = unknown,
  {reply, Reply, State}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
  ok.



%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

