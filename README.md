# Trade Logger

TODO

## Includes

- Ruby 3.0
- Rails 6.14
- Postgresql 13.3

## Requirements

You need to setup an env file for heroku deployment

```
RACK_ENV=development
PORT=3000
```

## TODO

1. overall part II
   1. UI
      1. [x] organize type of logs in entry panel
      2. [x] organize type of analyses in log panel
      3. [x] visual indicator for cancelled/opened/filled/closed      
      4. [x] refactor and remove some templating code if possible
      5. [ ] more concise form structures (esp has manys)
   2. models
      1. [x] memos on trade entry
      2. [x] normalize fields
         1. [x] implement counter cache system
         2. [x] profits should be counter cache and should persist
         3. [x] amount should be counter cache and should persist
         4. [x] fees should be on trade entry setting?
         5. [x] margin should be on trade entry
         6. [x] open|close on trade entry should be weighted average
         7. [x] add refresh_explicit_counter_cache on trade logs
         8. [x] clean up trade entry specs
         9.  [x] Fix why profits are negative for shorts
      3. [x] Drop timeframe analysis
      4. [ ] Add to trade log analysis
         1. [ ] add moving averages (maybe jsonb)
         2. [ ] add pattern selection
      5. [ ] Add Stop loss point
      6. [ ] Add RR calculation

2. tags
- should paper & stopped flags be tags?
- should patterns be tags?

3. prompt/warning after something happens
- certain % gain/loss
  - consequctive
- trades with red flags
  - no stop loss
  - before bed time
  - market orders

4. search by timeframe
- persist profit and friends fields
- advance query system
  - 4h:trend = 1h:trend
  - 1h:bbwp > 50
- populate % success while entering trade

5. Another Overall round
   1. UI
      1. Fix NaN displayed in form
      2. Fix NaN displayed in index
      3. Redirect to parent object after filling form (if directed from parent)
      4. paste entry system
   2. Models
      1. Could clean up some `delegate` logic in form objects
      2. Could clean up some audit trail for important columns
      3. Could add guard against changing calculated columns
      4. Auto generate status on trade entry
      5. remove timeframe analysis
   3. Feature spec on all key admin pages
      1. show
      2. new
      3. edit
   
6. Analyses could take schema from global setting, so that future changes doesn't lead to db migration

7. Users
- user level settings
  - margin
  - maker taker fees
  - user level login
- roles

## Nice to haves
- [x] login
- [ ] emotional score
- [ ] Markdown
- [ ] ci? https://circleci.com/integrations/heroku
- [ ] autoloader Zeitwerk causing NameError in heroku deployment
- [ ] Actual heroku docker deployment 
- [ ] AWS? (cheaper)
- [ ] Upgrade to Ruby 3.0.2

## Done

Base
- [x] add margin setting
- [x] add maker/taker fee setting
- [x] add paper trade boolean
- [x] best in place
- [x] Stopped?

Deployment
- [x] heroku

Models part I - refactor: trades should be just additions to entry
- [x] rebuild table trades into trade_logs
- [x] admin pages
- [x] audit trail
- [x] inline edits
- [x] add timeframe analysis

Memos
- [x] Memo on status change or just open, during, close memos

## Deployment

You'll need heroku cli and our production.key. Set it with

```
heroku config:set RAILS_MASTER_KEY=<value in production.key>
```

Deployment

```
heroku login
heroku git:remote -a logit-69
heroku stack:set heroku-20

git push heroku master
heroku run rake db:migrate
```