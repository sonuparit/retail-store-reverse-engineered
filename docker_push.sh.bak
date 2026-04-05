#!/bin/sh
#
for img in cart catalog checkout orders ui; do \
  docker tag $img:service sonuparit/retail-app:$img; \
  docker push sonuparit/retail-app:$img; \
done
