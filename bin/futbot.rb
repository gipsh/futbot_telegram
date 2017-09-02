# bin/telegram_bot

#!/usr/bin/env ruby

begin
  ENV['BOT_POLLER_MODE'] = 'true'
  require_relative '../config/environment'
  Telegram::Bot::UpdatesPoller.start(ENV['BOT'].try!(:to_sym) || :default)
rescue Exception => e
  Rollbar.report_exception(e) if defined?(Rollbar) && !e.is_a?(SystemExit)
  raise
end
