#!/usr/bin/env bash

COFFEE_CMD="coffee --compile --join dist/application.js src/*.coffee"
SASS_CMD="sass --update css:dist"

docker run -v $(pwd):/srv/www/emoji_soup emoji_soup $COFFEE_CMD && $SASS_CMD
