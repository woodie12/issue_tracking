issue_tracking
=====

erlang restapi + mnesia database + vue.js front end => issue tracking system

Build
-----

    $ rebar3 compile

# how to build vue into erlang cowboy's production:

npm run build // vue generate a dist file

copy dir to rebar's src and set static handler in app.erl
