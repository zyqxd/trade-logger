# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id                     :bigint           not null, primary key
#  amount                 :decimal(12, 8)   default(1.0), not null
#  close_price            :decimal(8, 2)
#  coin                   :string           default("btcusdt"), not null
#  kind                   :string           default("long"), not null
#  maker_percentage       :decimal(6, 5)    default(0.0), not null
#  margin                 :decimal(8, 2)    default(1.0), not null
#  open_price             :decimal(8, 2)
#  paper                  :boolean          default(FALSE), not null
#  profit                 :decimal(8, 2)
#  profit_percentage      :decimal(12, 8)
#  status                 :string           default("opened"), not null
#  taker_percentage       :decimal(6, 5)    default(0.0), not null
#  true_profit            :decimal(8, 2)
#  true_profit_percentage :decimal(12, 8)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :trade_entry do
    kind { :long }
    status { :closed }
    coin { :btcusdt }
    margin { 2 }

    trait :long do
      # Default
    end

    trait :short do
      kind { :short }
    end

    trait :closed do
      # Default
    end

    trait :opened do
      status { :opened }
    end

    trait :filled do
      status { :filled }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :btcusdt do
      # Default
    end

    trait :btcusd do
      kind { :btcusd }
    end
  end

  factory :complete_trade_entry, parent: :trade_entry do
    trait :long do
      transient do
        winner { true }
      end

      after :create do |entry, evaluator|
        hprofit = evaluator.winner ? 500 : -500

        create_list :trade_log, 2, :long, entry: entry, price: 1000 - hprofit
        create_list :trade_log, 2, :short, entry: entry, price: 1000 + hprofit
      end
    end

    trait :short do
      transient do
        winner { true }
      end

      after :create do |entry, evaluator|
        hprofit = evaluator.winner ? -500 : 500

        create_list :trade_log, 2, :long, entry: entry, price: 1000 + hprofit
        create_list :trade_log, 2, :short, entry: entry, price: 1000 - hprofit
      end
    end
  end
end
