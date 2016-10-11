%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(http_srv).

%% API.
-export([start/0]).

%% API.

start() ->
	%% Check the configuration for which port to listen to
%% 	{ok, Port} = application:get_env(listener_conf, listen_port),
%%
%% 		%% Start the http listener	
 			Dispatch = cowboy_router:compile([
			        {'_', [{'_', request_handler, []}]}
			            ]),
			                cowboy:start_clear(my_http_listener, 100, [{port, 8080}],
 			                        [{env, [{dispatch, Dispatch}]}]
 			                            ).
