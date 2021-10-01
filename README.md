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
      6. [x] trade logs
         1. [x] add cancelled as separate boolean
         2. [x] add post button in trade logs panel
         3. [x] sort by type then price in trade logs panel
      7. [ ] Quick changes
         1. [x] add confirmation to form submit since its long
         2. [ ] index pages
            1. [ ] trade entry default to open and filled trades
            2. [ ] trade logs default to open trades
         3. [ ] trade entries
            1. [ ] consolidate all memos
            2. [ ] consolidate all analyses
      8. [ ] In place edits
         1. [ ] auto reload helpers
         2. [ ] add lock logic into best_in_place_helper
         3. [ ] add styles to status_tags for specific method
      9. [ ] Forms
         1. [ ] add tp/open amount limits (25% | 50% | 75% | 100%)
         2. [ ] make analyses custom template
         3. [ ] make log custom template
      10. [ ] side bar 
         4. [ ] figure out why you have 2x sidebar
         5. [ ] clean up stats we show
            1. [ ] show opened amount
            2. [ ] show closed amount
            3. [ ] show position size
            4. [ ] show cancelled amount
            5. [ ] show if current position has outstand positions
               1. [ ] maybe something we persist
         6. [ ] maybe make position fixed on screen
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
         1. [ ] refactor to key/value analyses
         2. [ ] add moving averages (maybe jsonb)
         3. [ ] add pattern selection
      5. [ ] migrations
         1. [ ] migrate analysis `filled` to `closed`
         2. [ ] move cancelled out of status
      6. [ ] add counter caches to trade log analyses
      7. [ ] trade log
         1. [ ] has one memo per 
         2. [ ] add counter cache for memos
         3. [ ] add counter cache for analyses
         4. [ ] lock price after close
         5. [ ] lock amount after close

2. tags
- should paper & stopped flags be tags?
- should patterns be tags?
- tags can have descriptions for strategies, used for searching later
  - example 1h 4h trading ranges with custom tag

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
      5. add counters and show `memos` from tradelog panel actions in trade entries
   2. Models
      1. Could clean up some `delegate` logic in form objects
      2. Could clean up some audit trail for important columns
      3. Could add guard against changing calculated columns
      4. Auto generate status on trade entry
      5. remove timeframe analysis
      6. consider performance of callbacks
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
- [x] database sync
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