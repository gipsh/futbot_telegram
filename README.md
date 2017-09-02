# Futbot

This bot helps organize soccer match with your friends.
Just invite the bot to your group.

This was a weekend proyect, the code is crappy and not optimized. 

The locale is forced to :es (spanish)

This app uses [telegram-bot](https://github.com/telegram-bot-rb/telegram-bot) gem.


## Commands

- `/futbol` - Information about the upcoming match.
- `/futbol %day_name% %time$ - create a new match for the group
- `/juego` - join to the game
- `/juego %name%` - join an external user to the group
- `/lista` - print current players

## Setup

- Create bot with [@BotFather](https://telegram.me/BotFather) `unless has_test_bot?`
- Clone repo.
- run `./bin/setup`.
- Update `config/secrets.yml` with your bot's token.

## Run

### Development

```
bin/rake telegram:bot:poller
```

### Production

One way is just to run poller. You don't need anything else, just check
your production secrets & configs. But there is better way: use webhooks.

__You may want to use different token: after you setup the webhook,
you need to unset it to run development poller again.__

First you need to setup the webhook. There is rake task for it,
but you're free to set it manually with API call.
To use rake task you need to set host in `routes.default_url_options`
for production environment (`config.routes` for Rails < 5).
There is already such line in the repo in `production.rb`.
Uncomment it, change the values, and you're ready for:

```
bin/rake telegram:bot:set_webhook RAILS_ENV=production
```

Now deploy your app in any way you like. You don't need run anything special for bot,
but `rails server` as usual. Your rails app will receive webhooks and bypass them
to bot's controller.



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/telegram-bot-rb/telegram_bot_app.
