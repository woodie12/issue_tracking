%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Jun 2018 12:38 PM
%%%-------------------------------------------------------------------
-module(issues_db).
-author("wan").

%%% External code
-include_lib ("stdlib/include/qlc.hrl").
-include_lib ("../include/issues.hrl").

%% API
-export([initial_setup/0,
          create_user/1,
          update_user/2,
          get_user/1,
          get_issue/0,
          get_issues/1,
          add_issues/3,
          delete_user/1,
          create_issue/2,
          update_issue/3,
          delete_issues/1
          ]).

%%% issue crud functions
initial_setup() ->
  application:set_env(mnesia,dir,"/db"),
  mnesia:create_schema([node()]),
  mnesia:start(),
  create_tables().


create_tables() ->

  mnesia:create_table(user,
    [{type, ordered_set},
%%      {disc_copies, [node()]},
      {attributes, record_info(fields, user)}]),

%%  mnesia:create_table(issue,
%%    [{type, ordered_set},
%%%%      {disc_copies, [node()]},
%%      {attributes, record_info(fields, issue)}]),
  io:format("created table !!!!! ~p",
    [ mnesia:create_table(issue,
    [{type, ordered_set},
%%      {disc_copies, [node()]},
      {attributes, record_info(fields, issue)}])]),

  mnesia:create_table(connection,
    [{type, bag},
%%      {disc_copies, [node()]},
      {attributes, record_info(fields, connection)}]),
  mnesia:info(),
%%  mnesia:create_table(id,
%%    [{type, ordered_set},
%%      {disc_copies, [node()]},
%%      {attributes, record_info(fields, id)}]),

  ok.





create_user(Username) ->
  User = ensure_list(Username),

  {ok, User} = create_user_aux(Username),
  {ok, user_to_map(User)}.

get_user(Id) ->
  {ok, User} = get_user_aux(Id),
  {ok, user_to_map(User)}.

update_user(Id,Username) ->
  Username= ensure_list(Username),

  {ok, User} = get_user_aux(Id),
  update_user_aux(Id, User, User#user.created).

delete_user(Id) ->
  {ok, User} = get_user_aux(Id),
  mnesia:transaction( fun() ->
    mnesia:delete_object(User)
                      end).

ensure_list(Input) ->
  case Input of
    Val when is_binary(Val) -> binary_to_list(Val);
    Val when is_list(Val) -> Val;
    _ -> erlang:throw("Invalid Type for First Name, must be a string/list")
  end.

get_user_aux(Id) ->
  {atomic, User} = mnesia:transaction( fun() ->
    case mnesia:read( user, Id, read ) of
      [Item] -> Item;
      [] -> []
    end
                                           end),
  {ok, User}.

create_user_aux(Username) ->
  Timestamp = erlang:system_time(),

  {atomic, User} = mnesia:transaction( fun() ->
    NextID = get_issueid(),
    New = #user{  id = NextID,
                  username = Username,
                  created = Timestamp,
                  modified = Timestamp
    },
    mnesia:write( New ),
    New
                                        end),
  {ok, User}.

update_user_aux(Id, Username, Created) ->
  Timestamp = erlang:system_time(),

  {atomic, User} = mnesia:transaction( fun() ->
                                            New = #user{  id = Id,
                                                          username = Username,
                                                          created = Created,
                                                          modified = Timestamp
                                            },
                                            mnesia:write( New ),
                                            New
                                       end),
  {ok, user_to_map(User)}.

%% Convert an employee record to a map object
user_to_map(User) ->
  case User of
    [] -> #{};
    _ -> #{
      <<"id">> => User#user.id,
      <<"username">> => list_to_binary(User#user.username)
    }
  end.




%%
%%TODO: all_keys(issue) return an list of issue ID, but we need to get all the record, see how to do this
%% get the list of the issues.
get_issue() ->
  io:format("hello there"),
  Fun = fun() ->
%%    mnesia:all_keys(issue)

    mnesia:foldl(fun(X, Acc) -> [iss_to_map(X)|Acc] end, [], issue)
        end,
  Lookup = mnesia:transaction(Fun),
  case Lookup of
    {atomic, Issues} ->
      io:format("~p~n",[Issues]);
    _ ->
      io:format("fuck in getting all users~n"),
      Issues=[]
  end,
%%  TODO: ISSUES IS A VALUE, FIND A WAY TO RETURN THE WHOLE MAP TO ISSUE_TRACKING_API
%%  Result = issue_to_list(Issues),
%%  io:format("aaaaaaazhuyilongaaaaa~p",[Result]),
  {ok, Issues}.

%%[(Item)||{Item,Unit}<-Shoppinglist, Item<-[apples,milk]].
%%[apples,milk,apples,milk,apples,milk]
%%
%%issue_to_list(Issues) ->
%%  Res = lists:map(fun({Issue}) -> [#issue{x = X}] = mnesia:dirty_read({issue, Issue}), X end, Issues),
%%  lists:flatten(Res).

%% TODO: add issue id
get_issueid() ->
%%  check wheter write read in the righr way
  [Item] = mnesia:read(id, issue, read),
  N = Item#id.value,
  mnesia:write(Item#id{ value = N + 1}),
  N.

create_issue(Title, Content) ->
  {atomic, Issue} = mnesia:transaction( fun() ->
    NextID = get_issueid(),
    New = #issue{ id = NextID,
                  title= Title,
                  content = Content
      },
    mneisa:write(New),
    New
                                        end
  ),
  {ok, Issue}.


get_issues(Id) ->
  {atomic, Issue} = mnesia:transaction( fun() ->
    case mnesia:read(issue,  Id) of
      [Item] -> Item;
      []->[]
    end
                                           end
  ),
  io:format("1234---enter get issue id , issue is ~p~n", [Issue]),
  {ok, iss_to_map(Issue)}.

update_issue(Id, Title, Content) ->
  Timestamp = erlang:system_time(),
  {atomic, Issue} = mnesia:transaction(
    fun() ->
      New = #issue{
        id = Id,
        title = Title,
        content = Content,
        created = Timestamp
      },
      mnesia:write(New),
      New
    end
  ),
  {ok, Issue}.



delete_issues(Id) ->
%%  =========failed try.==========
%%  {ok, Issue} = get_issues(Id),
%%  io:format("title is ~p, content is ~p", [maps:get(<<"title">>,Issue)],[maps:get(<<"content">>, Issue)]),
%%  Delete=#issue{id = Id, title = maps:get(<<"title">>, Issue), content = maps:get(<<"content">>, Issue)},
%%  io:format("hahahahaha ~p",[mnesia:transaction(fun() -> mnesia:delete_object(issue, Delete)
%%                     end)]),

  Fun = fun() ->
    mnesia:delete({issue,Id})
        end,
  Lookup = mnesia:transaction(Fun),
  case Lookup of
    {atomic,[]} ->
      not_exist;
    {atomic,ok} ->
      deleted;
    _ ->
      nopes
  end,
  {ok,Lookup}.

iss_to_map(I) ->
  case I of
    [] -> #{};
    _ -> #{
      <<"id">> => I#issue.id,
      <<"title">> => I#issue.title,
      <<"content">> => I#issue.content
%%      <<"created">> => E#employee.created,
%%      <<"modified">> => E#employee.modified
    }
  end.


add_issues(Id, Title, Content) ->
  {atomic, Issue} = mnesia:transaction(
%%    io:format("i love zhuyilong", [Id,Title,Content]),
    fun() ->
      New = #issue{
        id = Id,
        title = Title,
        content = Content
      },

      io:format("result~p",[mnesia:write(New)]),
      New
    end
  ),
  io:format("------ issue is ------, ~p", [Issue]),
  {ok, iss_to_map(Issue)}.







