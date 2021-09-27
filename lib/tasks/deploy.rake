# frozen_string_literal: true

namespace :deploy do
  task production: :environment do
    system('git push heroku master')
  end
end
