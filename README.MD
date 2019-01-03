TacoMQTT
=====

This is an example repository containing an Erlang application capable of
* Waiting for RESTful requests
* Forwarding these requests over to an MQTT broker

## Tutorial basis
This tutorial assumes that you have followed Michal's initial tutorial, as described [here](https://gist.github.com/michalpalka/128d055223c043226969968ba6889b6b)!

After running
```zsh
./rebar3 update
./rebar3 upgrade
./rebar3 compile
./rebar3 shell
```
you you should be able to connect to your locally running mosWalktroughquitto broker as described in Michal's text.

Nevertheless, we will start a new project from scratch...

## Initial frame
Lets start and create a new rebar3 project. And we will call it - what a surprise TacoMQTT!
First of all, we will create a nice directory, download rebar3 and make it executable...
```zsh
mkdir TacoMQTT && cd TacoMQTT
wget https://s3.amazonaws.com/rebar3/rebar3
chmod u+x rebar3
```
So far so good.
Now we need to create a new project in rebar3. We need an "OTP Release structure for executable programs".
Therefore we will choose rebar's option "release" to create an OTP release. :smile:
When we do that, it will create a folder "tacomqtt" inside our already existing TacoMQTT folder. That is not too handy, when it comes to handleing the code and the repo. Therefore my team and I always moved the folder structure one level lower.
Important: your release name should be written in small letters only, if you want to avoid using single-quotes all over the place (remember Erlang atoms, etc).
Enogh bla-bla-bla. Let's do it:
```zsh
./rebar3 new release tacomqtt
mv tacomqtt/* ./
rm -r tacomqtt
```
Your folder structure should look like this:
```zsh
jonas@TacoPad test $ tree
.
├── apps
│   └── tacomqtt
│       └── src
│           ├── tacomqtt_app.erl
│           ├── tacomqtt.app.src
│           └── tacomqtt_sup.erl
├── config
│   ├── sys.config
│   └── vm.args
├── LICENSE
├── README.md
├── rebar3
└── rebar.config

4 directories, 9 files
```

## Dependencies
First of all, we need to add the dependencies to our rebar3 config file. In our case this is emqtcc and cowboy. Their subsequent dependencies will be fetched automatically, so we don't have to worry about them. To do so, we have to modify the rebar.config file and change the dependency list so that it looks like this:
```erlang
{deps, [
	{cowboy, ".*", {git,"https://github.com/ninenines/cowboy.git", "master"}},
	{emqttc, ".*", {git, "https://github.com/emqtt/emqttc.git", "master"}}
]}.
```

We can try to fetch them now and compile 'em:
```zsh
./rebar3 update
./rebar3 upgrade
./rebar3 compile
```
Wow - so much fun :turtle:

## A bit of coding...
Now it's time to hack some code together. All code belongs into the apps/tacomqtt/src folder. But one thing before you guys will bash me: I know that my code in this repo is not the prettiest :dog: It's just supposed to show you how to make a simple connection between HTTP and the MQTT broker using a nice rebar3 release structure.

Let's start with a gen_server taking care of the messages send to your MQTT broker. I just called it [emqtcc_srv.erl](https://github.com/TacoVox/TacoMQTT/blob/master/apps/tacomqtt/src/emqtcc_srv.erl). It is a simplified version of an official tutorial by emqtcc. You can find that one [HERE](https://github.com/emqtt/emqttc/tree/master/examples/gen_server).
The second important file is the [request_handler.erl](https://github.com/TacoVox/TacoMQTT/blob/master/apps/tacomqtt/src/request_handler.erl). That one is also a modified version of an official cowboy tutorial. This one you can fine [HERE](https://github.com/ninenines/cowboy/tree/master/examples/echo_get).
I don't want to walk you through that code in detail. Insted you should understand their tutorial code and documentation yourselves.

So far so good. But how will you make them run with a rebar app?

For our application to run, we need to start cowboy and it's dependecies first. Because Cowboy is an OTP-application itself, we can add it ot our [tacomqtt.app.src](https://github.com/TacoVox/TacoMQTT/blob/master/apps/tacomqtt/src/tacomqtt.app.src) file:
```erlang
%% Previous code

{applications,
   [kernel,
    stdlib,
    sasl,
    cowlib,
    ranch,
    cowboy
   ]}

%% Following code
```

Next thing we need to do is to fire up our only OTP supervisor + starting the cowboy server. That is happening in the [tacomqtt_app.erl](https://github.com/TacoVox/TacoMQTT/blob/master/apps/tacomqtt/src/tacomqtt_app.erl) file. This one will start your application (using - what a surprise - the start/2 function).
```erlang
start(_StartType, _StartArgs) ->
    tacomqtt_sup:start_link(),

    {ok, Port} = application:get_env(cowboy_conf, port),
    Dispatch = cowboy_router:compile([{'_', [{"/", request_handler, []}]}]),
    {ok, _} = cowboy:start_clear(http, 100, [{port, Port}], #{env => #{dispatch => Dispatch}}).
```
As you can see here, we are reading out some info from a config file. We get back to that later.

We should have a final look what this [tacomqtt_sup](https://github.com/TacoVox/TacoMQTT/blob/master/apps/tacomqtt/src/tacomqtt_sup.erl) is doin'.
Basically, not much :boar:
It is just starting the emqtcc server and taking care of it ;)

I suggest you go a bit through the code and try to figure out what it is doing...

## Config files
THE FINAL PART :bear:

A thing that is really nice about rebar3 releases are the config files.
As you can see there is currently one: config/sys.config

I am using it for defining the name of the client, the host, as well as the port, where Cowboy is listenin' on :panda_face:

```erlang
[
  {mqtt_conf, [{client_id, "TacoMQTT"}, {host, "localhost"}]},
  {cowboy_conf, [{port, 8080}]}
].
```

As you can see, first, you specify the config name. Then it's basically just a list with key-value-pairs.
To access one of these pairs, just use the application:get_env/2 function and you will get back {ok, VALUE} on success:
```erlang
{ok, Port} = application:get_env(cowboy_conf, port).
```

## End
That's about it :monkey:
I hope this was helpful.
If you want to look at our last-years project, just have a look at the Repo:
https://github.com/TacoVox/HashTux

One last thing. Alway remember: DO NOT put any passwords or access tokens up to GitHub. There are even bots scanning for them! Even in privat repos. Removing them recursively is a pain in the backparts. Trust me... :see_no_evil:

Cheers. Jonas.
