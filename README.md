# Blackjack

A single-player blackjack game against a computer dealer, built with Ruby on Rails as a learning project.

## Requirements

- **Ruby 3.3.0** — the version is pinned in `.ruby-version`. Install it with a version manager such as [mise](https://mise.jdx.dev), rbenv or asdf.
- **Bundler** — installed automatically by `bin/setup` if missing.
- **SQLite 3** — included with macOS and most Linux distributions. No database server is needed.
- **Git**, to clone the repository.

Rails 7.2 and all other gems are installed by Bundler from the `Gemfile`.

## Installation

```sh
git clone https://github.com/bvsaker1/blackjack-rails.git
cd blackjack-rails

# Install Ruby 3.3.0 if you don't have it (mise shown; use your version manager)
mise install

# Install gems, create the database, load the schema and seed the 52 cards
bin/setup
```

`bin/setup` is safe to run again at any time. If you prefer to do the steps by hand:

```sh
bundle install
bin/rails db:prepare   # creates storage/development.sqlite3 and seeds the cards
```

If the card table is ever empty, reseed it with `bin/rails db:seed` (it won't create duplicates).

## Running the game

```sh
bin/rails server
```

Then open <http://localhost:3000>.

- **Deal** — deals two cards each to the player and the dealer. One dealer card stays face down.
- **Hit** — takes another card.
- **Stand** — ends your turn. The dealer reveals their hidden card and draws one card per second until reaching 17 or more, then the hand is scored.
- **Reset** — deletes the current game, including the win tally, and starts a new one.

The result is shown for a few seconds before the Deal button returns for the next hand.

## How it works

| Model | Purpose |
|---|---|
| `Card` | The 52 cards (suit and rank), created by `db/seeds.rb` and shared by all games. |
| `Game` | One per browser session. Holds the status (`waiting`, `in_progress`, `dealer_turn`, `player_won`, `dealer_won`, `push`) and the win tally (`player_score`, `dealer_score`). |
| `Deck` / `DeckCard` | Each game's own shuffled copy of the cards. `position` is the order in the deck and `hand_id` is where the card currently is (`nil` means still in the deck). |
| `Hand` | Each game has a `player`, a `dealer` and a `discarded` hand. Used cards move to the discard pile between rounds. |

- The current game is tracked in the Rails session cookie. A different browser, or a private window, gets its own game.
- The deck is reshuffled when fewer than 20% of the cards remain undealt.
- The one-second dealer pacing and the result delay use a `<meta http-equiv="refresh">` tag. There is no JavaScript game logic.
- Card images are from the [Kenney Playing Cards Pack](https://www.kenney.nl) (CC0 license) in `app/assets/images/cards/`.

## Limitations

- **Single player only.** There are no accounts, and a game lives only as long as its session cookie.
- **Basic rules only.** No betting, doubling down, splitting, insurance or surrender. A natural blackjack isn't treated as a special case or paid 3:2, and the dealer stands on all 17s, including soft 17.
- **Single 52-card deck** per game. There is no multi-deck shoe.
- **Page refreshes drive the dealer's turn.** Reloading the page during the dealer's turn makes the dealer draw slightly faster. The rules are still followed.
- **No automated tests.** The files in `test/` are the default Rails stubs.
- **Development only.** The app hasn't been configured or tested for production deployment. SQLite stores data in `storage/`, so any host needs a persistent disk.

## Development notes

- Debugging: the `debug` gem is included. Add `debugger` (or `<% debugger %>` in a view) where you want to stop, then run the server from a terminal. In VS Code, the `.vscode/launch.json` "Rails server" configuration uses the Ruby LSP extension. If you use mise, set `"rubyLsp.rubyVersionManager": { "identifier": "mise" }` in your VS Code settings.
- To clear out old games, run `bin/rails runner 'Game.destroy_all'`. A new game is created on the next page load.
