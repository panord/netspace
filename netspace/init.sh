#!/bin/bash

export START="sudo ip netns exec $NAME"
for i in $(find $(dirname $0)/init.d -type f); do
	$i
done
