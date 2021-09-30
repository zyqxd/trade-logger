# frozen_string_literal: true

namespace :heroku do
  task deploy: :environment do
    system('git push heroku master')
  end

  task sync: [:environment, 'db:reset'] do
    filename = 'tmp/latest.dump'

    system('heroku pg:backups:capture')
    system("rm #{filename}")
    system("heroku pg:backups:download -o #{filename}")
    system('docker exec -i trade-logger_db_1 '\
           'pg_restore -U user -c -v -d trade_logger_development '\
           "< #{filename}")
    system('rails db:migrate')
  end
end
