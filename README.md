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

overall part II
1. UI
  1.  [x] make plan show page display word-wrap
  2.  [ ] Give color coding to coins
  3.  [x] Make form inputs toggles (EVERY FORM)
2. models
   1. [ ] Add to trade log analysis
      1. [ ] refactor to key/value analyses (likely full denormalized so we can see what we use more)
      2. [ ] more visual indicator for forms (toggles ideal)
      3. [ ] add moving averages (maybe jsonb)
      4. [ ] add pattern selections? (maybe not)
      5. [ ] make timeframes + plans association, enforce new analysis form (can constraint uniqueness on timeframe + plan)
   2. [ ] migrations
      1. [x] migrate analysis `filled` to `closed`
      2. [ ] move cancelled out of status
   3. [ ] Use `open` and `close` for kinds in trade log
      1. [ ] change in trade log model
      2. [ ] change in trade entry mode
      3. [ ] change in trade log admin
      4. [ ] change in trade entry admin
      5. [ ] change in BIP tags
   4. [ ] add counter caches to trade log analyses
   5. [ ] trade log
      1. [ ] has one memo per 
      2. [ ] add counter cache for memos
      3. [ ] add counter cache for analyses
      4. [ ] lock price after close
      5. [ ] lock amount after close

Bugs 
1. [x] Fix bug with bip_status not reloading (error in value)
2. [x] Fix calculation issue with profit $ and %
3. [ ] Fix/Optimize excess db calls in model callbacks
4. [x] Fix bug with nil amount being compared in new trade entries
5. [ ] Don't count cancelled logs for amount

tags
- should paper & stopped flags be tags?
- should patterns be tags?
- tags can have descriptions for strategies, used for searching later
  - example 1h 4h trading ranges with custom tag

Memos 
- Require memo every update?

prompt/warning after something happens
- certain % gain/loss
  - consequctive
- trades with red flags
  - no stop loss
  - before bed time
  - market orders

search by timeframe
- persist profit and friends fields
- advance query system
  - 4h:trend = 1h:trend
  - 1h:bbwp > 50
- populate % success while entering trade

Another Overall round
   1. break this down further
   2. UI
      1. Fix NaN displayed in form
      2. Redirect to parent object after filling form (if directed from parent)
      3. paste entry system
      4. add counters and show `memos` from tradelog panel actions in trade entries
      5. Allow trade entries create action to redirect to show page
      6. Actual form validations (show errors instead of 500)
      7. Make margin global setting for new trades
   3. Models
      1. Could clean up some audit trail for important columns
      2. Could add guard against changing calculated columns
      3. Auto generate status on trade entry
      4. remove timeframe analysis
      5. consider performance of callbacks
      6. trade entries
         1. consolidate all memos into entries
         2. consolidate all analyses into entries
   4. Feature spec on all key admin pages
      1. show
      2. new
      3. edit
   
Analyses could take schema from global setting, so that future changes doesn't lead to db migration

Users
- user level settings
  - margin
  - maker taker fees
  - user level login
- roles

## Nice to haves
- [x] login
- [x] database sync
- [x] Auto delegate all methods (probably rename model)
- [ ] Some base class for admin decorators
- [ ] https://github.com/aasm/aasm
- [ ] emotional score
- [ ] Markdown
- [ ] ci? https://circleci.com/integrations/heroku
- [ ] autoloader Zeitwerk causing NameError in heroku deployment
- [ ] Actual heroku docker deployment 
- [ ] AWS? (cheaper)
- [ ] Upgrade to Ruby 3.0.2
- [ ] ActiveAdmin auto reload helpers [known bug](https://github.com/activeadmin/activeadmin/blob/master/docs/14-gotchas.md#helpers)

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

Trade Plans
- [x] detailed sections with text
- [x] Sidebar plan while creating in form

UI
1. [x] organize type of logs in entry panel
2. [x] organize type of analyses in log panel
3. [x] visual indicator for cancelled/opened/filled/closed      
4. [x] refactor and remove some templating code if possible
5. [x] trade logs
    1. [x] add cancelled as separate boolean
    2. [x] add post button in trade logs panel
    3. [x] sort by type then price in trade logs panel
6. [x] Quick changes
    1. [x] add confirmation to form submit since its long
    2. [x] index pages
      1. [x] trade entry default to open and filled trades
      2. [x] trade logs default to open trades
    3. [x] Fix method_missing rubocop issue
7.  [x] In place edits
    1. [x] add lock logic into best_in_place_helper
    2. [x] add styles to status_tags for specific method
8.  [x] In place forms
    1.  [x] add quick link to open add position (longs buy / shorts sell)
    2.  [x] add quick link to close add position
9.  [x] Index page
    1.  [x] fix NaN
    2.  [x] show paper prices
    3.  [x] show proper formatting of numbers
10. [x] Forms
    1.  [x] Always redirect back
    2.  [x] Add BIP in index pages
11. [x] side bar 
    1.  [x] figure out why you have 2x sidebar
    2.  [x] make plan fetch new plan info when creating logs and entries
    3.  [x] make plan in side bar when filling out log
    4.  [x] make entry in side bar when filling out log

Models
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
   9. [x] Fix why profits are negative for shorts
3.  [x] Drop timeframe analysis
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
