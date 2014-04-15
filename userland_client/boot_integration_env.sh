#!/bin/bash

cd ../userland
rm userland.http.*
rm userland.amqp.*

#bundle exec rails s > userland.http.stdout 2> userland.http.stderr &
bundle exec rails s > userland.http.stdout 2>&1 &
httpid=$!
#bundle exec jackalope -quserland -d config.ru > userland.amqp.stdout 2> userland.amqp.stderr &
bundle exec jackalope -quserland -d config.ru > userland.amqp.stdout 2>&1 &
amqpid=$!

sleep 2
trap "kill $httpid; kill $amqpid" INT
tail -400f userland.*
