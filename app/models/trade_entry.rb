# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id               :bigint           not null, primary key
#  amount           :decimal(12, 8)   default(1.0), not null
#  close_price      :decimal(8, 2)
#  close_time       :datetime
#  coin             :string           default("btcusdt"), not null
#  kind             :string           default("long"), not null
#  maker_percentage :decimal(6, 5)    default(0.0), not null
#  margin           :decimal(8, 2)    default(1.0), not null
#  open_price       :decimal(8, 2)
#  open_time        :datetime
#  paper            :boolean          default(FALSE), not null
#  post_close       :boolean          default(FALSE), not null
#  post_open        :boolean          default(FALSE), not null
#  status           :string           default("opened"), not null
#  stopped          :boolean          default(FALSE), not null
#  taker_percentage :decimal(6, 5)    default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class TradeEntry < ApplicationRecord
  audited except: %i[created_at updated_at]
  has_associated_audits

  has_many :logs,
           class_name: 'TradeLog',
           inverse_of: :entry,
           foreign_key: :entry_id,
           dependent: :destroy

  has_many :analyses,
           class_name: 'TimeframeAnalysis',
           inverse_of: :trade_entry,
           dependent: :destroy

  enum status: {
    opened: 'opened',
    filled: 'filled',
    closed: 'closed',
    cancelled: 'cancelled',
  }

  enum coin: {
    btcusdt: 'btcusdt',
    btcusd: 'btcusd',
  }

  enum kind: {
    long: 'long',
    short: 'short',
  }

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :margin, numericality: { greater_than_or_equals_to: 1 }
  validates :maker_percentage, numericality: { in: -1..1 }
  validates :taker_percentage, numericality: { in: -1..1 }

  def position
    return nil if open_price.blank?

    open_price * amount * 1.0 / margin
  end

  def profit
    return nil if close_price.blank? || open_price.blank?

    (close_price - open_price) * amount
  end

  def profit_percentage
    return nil if profit.blank? || position.blank?

    profit * 1.0 / position
  end

  def open_fee
    return 0 if open_price.blank?

    open_price * (post_open ? taker_percentage : maker_percentage)
  end

  def close_fee
    return 0 if close_price.blank?

    close_price * (post_close ? taker_percentage : maker_percentage)
  end

  def true_profit
    return nil if profit.blank?

    profit - open_fee - close_fee
  end

  def true_profit_percentage
    return nil if true_profit.blank?

    true_profit * 1.0 / position
  end
end
