#!/bin/bash

result="$WORKDIR/.env"
expected="/expectation/.expected"

if cmp -s "$result" "$expected"; then
    printf 'The file "%s" is the same as "%s"\n' "$result" "$expected"
else
    printf 'The file "%s" is different from "%s"\n' "$result" "$expected"
    printf '\n'
    echo $(diff $result $expected)
    
    exit 1
fi