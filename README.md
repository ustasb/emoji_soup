CS 4850 - Building Game Engines
Final Project
Brian Ustas
04/26/14

# Emoji Soup

  This project is written in CoffeeScript and uses HTML5's Canvas API. Please
  view it in Chrome by opening index.html.

  I researched billiard ball physics and implemented it here. Gravity fields are
  also used.

  I wanted to show the network effect between happy and sad Emoji.
    - Happy Emoji attract other happy Emoji
    - Unhappy Emoji don't attract others
    - Emoji become less happy when bumping into others
    - When together, Emoji become more happy
    - If alone, Emoji gravitate towards a neutral state
    - Food makes Emoji grow

  It's interesting to see the groups that form! Crowded spaces create unhappy
  Emoji.

  Left-click the screen to spawn neutral Emoji. Browser resizing is also
  supported!

  Thanks for the semester! I learnt a lot.

# Old Idea

  See PresentationProposal.pdf for a description of my old idea. The assets for
  it are under old_idea/.

# Development

  Run `rake -T` for task descriptions.

  This project relies on Ruby and CoffeeScript for development.

# Resources Used

  Books:
  - HTML5 Animation with JavaScript
  - Beginning Math and Physics for Game Programmers
  - Game Physics Engine Development: How to Build a Robust Commercial-Grade Physics Engine for your Game
