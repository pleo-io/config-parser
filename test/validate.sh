#!/bin/bash

result="$WORKDIR/application.properties"
expected="/expectation/.expected"

if cmp -s "$result" "$expected"; then
    printf 'The file "%s" is the same as "%s"\n' "$result" "$expected"
else
    printf 'The file "%s" is different from "%s"\n' "$result" "$expected"
    printf '\n'
    echo $(diff $result $expected)
    printf '\n'
    printf 'Expected:\n'
    cat "$expected"
    printf '\n'
    printf 'Result:\n'
    cat "$result"

    exit 1
fi
