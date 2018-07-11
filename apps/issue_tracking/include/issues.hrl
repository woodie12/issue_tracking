%%%-------------------------------------------------------------------
%%% @author wan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Jun 2018 12:32 PM
%%%-------------------------------------------------------------------
-author("wan").

-record(user,{
              id,
              username,
              created,	% (epoch UTC) Microseconds
              modified	% (epoch UTC) Microseconds
            }).

-record(issue, {
              id,
              title,
              content
%%              reply
            }).

-record(connection, {
  user_id,
  issue_id
}).

%% ids - used for tracking id numbers
-record(id, {
  type,
  value
}).