#!/bin/bash
mkdir -p ebin

\cp ../../../data/erlang/* src/pb/
\cp ../../../data/erlang.common/* include/

erl -noshell -s make all -s init stop

if [ ${MSYSTEM} ]
then
	werl -pa ebin -s server &
else
	erl -pa ebin -s server
fi
