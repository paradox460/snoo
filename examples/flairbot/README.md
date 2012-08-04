This is a simple flairbot you can use to automatically add flair to a subreddit.

It is currently in use on [r/TheWalkingDead](http://www.reddit.com/r/thewalkingdead) and [r/BreakingBad](http://www.reddit.com/r/breakingbad). It provides automatic spoiler detection

# Configuration

## Account
Configuring the bot's account is very simple. Simply edit `config.yaml` and fill out the username and password fields.

## Subreddits
Each subreddit can have multiple regexes, and the bot can run on multiple subreddits. It needs to have moderator on all subreddits.

To add new subreddits, make a new first-level entry under `subreddits:`

To add new flair parsers, add a new entry, with a regular expression as the name. Ex `(show|comic) spoilers`. Beneath this, set if you want to ignore case (recommended) and the flair id of the linkflair to apply. This shows up if you inspect the HTML source of the reddit flair dialog on links.

# Caveats

This bot scrapes new, and as such, will ususally catch most things. That said, it is imperfect, and things may slip through.

To prevent re-duplicating flair calls, it hides a post on flair. This allows you to see which post a bot has flaired, simply by logging into its account.

Finally, regexes are applied in a top-down cascade. Regexes at the bottom will override ones at the top. A post can only have one linkflair, so go from general to specific in your regexes.
