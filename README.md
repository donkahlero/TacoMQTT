tacobroker
=====

This is an example repository containing an Erlang application capable of
* Waiting for RESTful requests
* Forwarding these requests over to an MQTT broker

## Step-By-Step Tutorial
This tutorial assumes that you have followed Michal's initial tutorial, as described [here](https://gist.github.com/michalpalka/128d055223c043226969968ba6889b6b)!

By now, you should have a rebar3 shell running, the emqtcc code fully compiled. Furthermore you should be able to connect to your locally running mosquitto broker.

If you can confirm that this is the case, you are ready to continue ;)

## Build
-----

    $ rebar3 compile
