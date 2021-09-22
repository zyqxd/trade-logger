# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Timeframe.create([
                   { name: '15 minutes', code: '15m' },
                   { name: '30 minutes', code: '30m' },
                   { name: '1 hour', code: '1h' },
                   { name: '2 hours', code: '2h' },
                   { name: '3 hours', code: '3h' },
                   { name: '4 hours', code: '4h' },
                   { name: '6 hours', code: '6h' },
                   { name: '12 hours', code: '12h' },
                   { name: '1 day', code: '1d' },
                   { name: '2 days', code: '2d' },
                   { name: '3 days', code: '3d' },
                   { name: '5 days', code: '5d' },
                   { name: '1 week', code: '1w' },
                   { name: '1 month', code: '1M' }
                 ])
