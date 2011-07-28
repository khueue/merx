-module(merx_sup).

-behaviour(supervisor).

%% API.
-export([
    start_link/0]).

%% Callbacks.
-export([
    init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local,?SERVER}, ?MODULE, []).

init([]) ->
    Server = {
        _Id = tr_server,
        _Start = {tr_server, start_link, []},
        _Restart = permanent,
        _Shutdown = 2000,
        _Type = worker,
        _Deps = [tr_server]},
    Children = [Server],
    RestartStrategy = {one_for_one, _Max=1, _Within=1},
    {ok, {RestartStrategy, Children}}.
