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
Therefore we will choose rebar's option "release" to create an OTP release. :)
When we do that, it will create a folder "TacoMQTT" inside our already existing TacoMQTT folder. That is not too handy, when it comes to handleing the code and the repo. Therefore my team and I always moved the folder structure one level lower.
Enogh bla-bla-bla. Let's do it:
```zsh
./rebar3 new release TacoMQTT
mv TacoMQTT/* ./
rm -r TacoMQTT
```
Your folder structure should look like:
```zsh
jonas@TacoPad test $ ls
apps  config  LICENSE  README.md  rebar3  rebar.config
```

Now it's time to hack some code together. I know that this code is not the prettiest, but it is working. It's supposed to show you how to make a simple connection between HTTP and the MQTT broker.

Let's start with a gen_server taking care of the messages send to your MQTT broker. I just called it [emqtcc_srv](https://github.com/TacoVox/TacoMQTT/blob/master/src/emqtcc_srv.erl). It is a simplified version of an official tutorial by emqtcc. You can find that one [HERE](https://github.com/emqtt/emqttc/tree/master/examples/gen_server).

After you tried it out a bit, you will notice that you can send

by looking at the [tacomqtt_app.erl](https://github.com/TacoVox/TacoMQTT/blob/master/src/tacomqtt_app.erl).
