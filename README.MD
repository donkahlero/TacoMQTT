TacoMQTT
=====

This is an example repository containing an Erlang application capable of
* Waiting for RESTful requests
* Forwarding these requests over to an MQTT broker

## Tutorial basis
This tutorial assumes that you have followed Michal's initial tutorial, as described [here](https://gist.github.com/michalpalka/128d055223c043226969968ba6889b6b)!

After running
```shell
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
Now we need to create a new project in rebar3. We need a " OTP Release structure for executable programs".
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

## A bit of coding...
Now it's time to hack some code together. Before you guys will bash me: I know that my code in this repo is not the prettiest :P. It's just supposed to show you how to make a simple connection between HTTP and the MQTT broker using a nice rebar3 release structure.

First of all, we need to add the dependencies to our rebar3 config file. In our case this is emqtcc and cowboy. Their subsequent dependencies will be fetched automatically, so we don't have to worry about them. To do so, we have to modify the rebar.config file and change the dependency list so that it looks like this:
```rebar.config
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
Wow - so much fun :smile:.

Let's start with a gen_server taking care of the messages send to your MQTT broker. I just called it [emqtcc_srv.erl](https://github.com/TacoVox/TacoMQTT/blob/master/src/emqtcc_srv.erl). It is a simplified version of an official tutorial by emqtcc. You can find that one [HERE](https://github.com/emqtt/emqttc/tree/master/examples/gen_server).
The second important file is the [request_handler.erl](https://github.com/TacoVox/TacoMQTT/blob/master/src/request_handler.erl). That one is also a modified version of an official cowboy tutorial. This one you can fine [HERE](https://github.com/ninenines/cowboy/tree/master/examples/echo_get).
I don't want to walk you through that code in detail. Insted you should understand their tutorial code and documentation yourselves.

So far so good. But how will you make them run with a rebar app?
Let's start by looking at the TacoMQTT_app.erl file. This one will start your application.

by looking at the [tacomqtt_app.erl](https://github.com/TacoVox/TacoMQTT/blob/master/src/tacomqtt_app.erl).
