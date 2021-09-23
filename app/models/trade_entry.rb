# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id          :bigint           not null, primary key
#  amount      :decimal(8, 8)    default(0.0), not null
#  cancelled   :boolean          default(FALSE), not null
#  close_price :decimal(8, 2)
#  close_time  :datetime
#  coin        :string           default("btcusdt"), not null
#  kind        :string           default("long"), not null
#  open_price  :decimal(8, 2)
#  open_time   :datetime
#  post_close  :boolean          default(FALSE), not null
#  post_open   :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TradeEntry < ApplicationRecord
  has_many :trades, inverse_of: :trade_entry, dependent: :destroy

  has_many :analyses,
           class_name: 'TimeframeAnalysis',
           inverse_of: :trade_entry,
           dependent: :destroy

  # TODO(DZ) this should be status enum
  scope :filled, -> { where(cancelled: false) }
  scope :cancelled, -> { where(cancelled: true) }

  enum coin: {
    btcusdt: 'btcusdt',
    btcusd: 'btcusd'
  }

  enum kind: {
    long: 'long',
    short: 'short'
  }
end
