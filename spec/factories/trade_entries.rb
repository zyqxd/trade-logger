# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id               :bigint           not null, primary key
#  amount           :decimal(12, 8)   default(1.0), not null
#  close_price      :decimal(8, 2)
#  coin             :string           default("btcusdt"), not null
#  kind             :string           default("long"), not null
#  maker_percentage :decimal(6, 5)    default(0.0), not null
#  margin           :decimal(8, 2)    default(1.0), not null
#  open_price       :decimal(8, 2)
#  paper            :boolean          default(FALSE), not null
#  status           :string           default("opened"), not null
#  taker_percentage :decimal(6, 5)    default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :trade_entry do
    amount { 1 }
    open_price { 10_000 }
    close_price { 15_000 }
    kind { :long }
    status { :closed }
    coin { :btcusdt }
    margin { 5 }
    open_time { 4.hours.ago }
    close_time { Time.current }
    maker_percentage { -0.00025 }
    taker_percentage { 0.00075 }
    post_open { true }
    post_close { true }

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
end
