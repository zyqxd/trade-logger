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

0. Base
- [x] add margin setting
- [x] add maker/taker fee setting
- [x] add paper trade boolean
- [x] best in place
- [x] Stopped?

1. deployment
- [x] heroku

1. refactor: trades should be just additions to entry
   - additions or subtractions (load, reload)
   - maybe they're events

2. memos

3. tags
   - should paper & stopped flags be tags?

4. prompt/warning after something happens
   - certain % gain/loss
     - consequctive
   - trades with red flags
     - no stop loss
     - before bed time
     - market orders

5. timeframe analysis as tag to other system structures

6. search by timeframe
   - advance query system
     - 4h:trend = 1h:trend
     - 1h:bbwp > 50
   - populate % success while entering trade

7. Users
   - user level settings
     - margin
     - maker taker fees
   - login
   - roles

## Nice to haves
- [ ] paste into form feature
- [ ] emotional score
- [ ] ci? https://circleci.com/integrations/heroku
- [ ] autoloader Zeitwerk causing NameError in heroku deployment
- [ ] Actual heroku docker deployment 
- [ ] AWS?