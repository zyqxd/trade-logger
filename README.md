# Trade Logger

TODO

## Includes

- Ruby 3.0
- Rails 6.14
- Postgresql 13.3

## TODO

0. Base
- [x] add margin setting
- [x] add maker/taker fee setting
- [x] add paper trade boolean
- [x] best in place
- [ ] Stopped?

1. deployment
   - heroku
   - aws?
   - ci?

2. refactor: trades should be just additions to entry
   - additions or subtractions (load, reload)
   - maybe they're events

3. tags
   - should paper & stopped flags be tags?

4. memos

5. prompt/warning after something happens
   - certain % gain/loss
     - consequctive
   - trades with red flags
     - no stop loss
     - before bed time
     - market orders

6. timeframe analysis as tag to other system structures

7. search by timeframe
   - advance query system
     - 4h:trend = 1h:trend
     - 1h:bbwp > 50
   - populate % success while entering trade

8. Users
   - user level settings
     - margin
     - maker taker fees
   - login
   - roles

## Nice to haves
- [ ] paste into form feature
- [ ] emotional score
