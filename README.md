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

1. models part II
- better entry system
  - tab entry
  - table style forms
  - refactor and remove some templating code if possible
  - paste into form feature
- timeframe analysis form
  - validations on values
  - update decimals to be 8,4
  - refactor trend values
    - bbwp sometimes just oscillating
    - stoch trend is implied by diff of fast + slow
    - rsi stays in zones, maybe okay with trends
- normalize fields (profit, fees, margin etc)
  - open|close prices should be average
  - profit should take sums

2. tags
- should paper & stopped flags be tags?

3. prompt/warning after something happens
- certain % gain/loss
  - consequctive
- trades with red flags
  - no stop loss
  - before bed time
  - market orders

4. timeframe analysis as tag to other system structures

5. search by timeframe
- persist profit and friends fields
- advance query system
  - 4h:trend = 1h:trend
  - 1h:bbwp > 50
- populate % success while entering trade

6. Users
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