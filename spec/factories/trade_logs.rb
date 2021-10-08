# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_logs
#
#  id         :bigint           not null, primary key
#  amount     :decimal(12, 8)   not null
#  close_time :datetime
#  fee        :decimal(8, 2)    default(0.0), not null
#  kind       :string           default("long"), not null
#  post       :boolean          default(FALSE), not null
#  price      :decimal(12, 2)   not null
#  status     :string           default("opened"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entry_id   :bigint
#
# Indexes
#
#  index_trade_logs_on_entry_id  (entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (entry_id => trade_entries.id)
#
FactoryBot.define do
  factory :trade_log do
    association :entry, factory: :trade_entry
    amount { 1 }
    price { 10_000 }
    post { true }
    kind { :long }
    status { :closed }
    close_time { Time.current }

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
  end
end
