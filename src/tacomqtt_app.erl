%%%-------------------------------------------------------------------
%% @doc tacobroker public API
%% @end
%%%-------------------------------------------------------------------

-module(tacomqtt_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start() ->
    start("", "").

start(_StartType, _StartArgs) ->
    ok = application:start(cowlib),
    ok = application:start(ranch),
    ok = application:start(cowboy),

    tacomqtt_sup:start_link(),

    Dispatch = cowboy_router:compile([{'_', [{"/", request_handler, []}]}]),
    {ok, _} = cowboy:start_clear(http, 100, [{port, 8080}], #{env => #{dispatch => Dispatch}}).

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
