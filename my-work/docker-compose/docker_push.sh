#!/bin/sh
#
for img in cart catalog checkout orders ui; do \
  docker tag $img:small sonuparit/retail-app:$img-small; \
  docker push sonuparit/retail-app:$img-small; \
done
