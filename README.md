# Emoji Soup

[ustasb.com/emojisoup](http://ustasb.com/emojisoup)

A bunch of interacting, emotional emoji...

## Usage

First, build the Docker image:

    docker build -t emoji_soup .

Compile SASS and CoffeeScript with:

    ./recompile_assets.sh

## Development

To recompile assets when files change:

    fswatch -o src css | xargs -n1 -I{} ./recompile_assets.sh

To serve assets via a local server:

    python -m SimpleHTTPServer

Navigate to `http://localhost:8000` in your browser.
