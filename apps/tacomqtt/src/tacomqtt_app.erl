%%%-------------------------------------------------------------------
%% @doc tacobroker public API
%% @end
%%%-------------------------------------------------------------------

-module(tacomqtt_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    %%ok = application:start(cowlib),
    %%ok = application:start(ranch),
    %%ok = application:start(cowboy),

    {ok, Port} = application:get_env(cowboy_conf, port),
    Dispatch = cowboy_router:compile([{'_', [{"/", request_handler, []}]}]),
    {ok, _} = cowboy:start_clear(http, 100, [{port, Port}], #{env => #{dispatch => Dispatch}}),

    tacomqtt_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
