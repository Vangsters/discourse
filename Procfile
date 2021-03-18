web: bundle exec rails server -p $PORT
sidekiq: bundle exec sidekiq -e $RAILS_ENV -q critical,8 -q default,4 -q low,2 -q ultra_low,1
