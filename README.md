# Emoji Soup

[ustasb.com/emoji-soup](http://ustasb.com/emoji-soup)

A bunch of interacting, emotional emoji...

Initial release: 05/08/14

## Usage

First, build the Docker image:

    docker build -t emoji_soup .

Compile SASS and CoffeeScript with:

    rake docker_build_dist

    # To recompile assets when files change (uses fswatch):

    rake docker_build_dist_and_watch

Serve assets via a local server:

    cd src && python -m SimpleHTTPServer

Navigate to `http://localhost:8000` in your browser.

## Production

To build the `public/` folder:

    rake docker_build_public

Open `public/index.html`.
