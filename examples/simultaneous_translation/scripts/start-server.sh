#!/bin/bash
set -e
config=$1
. $1

config_name=$(basename -- "$config")
config_name="${config%.*}"

echo Config: $(realpath $config)
echo Source: $src
echo Target: $tgt
echo Tokenizer: $tokenizer

user_dir=$(dirname "$0")/..
RANDOM=$$


if [ -z "$2" ]
  then
    port=$(python -c "import socket;s=socket.socket(socket.AF_INET, socket.SOCK_STREAM);s.bind(('', 0));print(s.getsockname()[1]);s.close()")
else
    port=$2
fi
echo Port $port

result_dir=./experiments/results/$config_name
mkdir -p $result_dir

python -u $user_dir/eval/server.py \
    --tokenizer $tokenizer \
    --src-file $src \
    --tgt-file $tgt \
    --scorer-type $scorer_type \
    --output $result_dir/eval \
    --port $port
exit

server_pid=$!

echo Server PID $server_pid
echo Server Port $port
