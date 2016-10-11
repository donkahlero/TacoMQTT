%%%-------------------------------------------------------------------
%% @doc tacobroker top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(tacomqtt_sup).

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
    MsgServ = {emqtcc_srv, {emqtcc_srv, start_link, []}, permanent, 10000, worker, [emqtcc_srv]},
    {ok, { {one_for_one, 0, 1}, [MsgServ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
