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
class TradeEntry < ApplicationRecord
  audited except: %i[created_at updated_at]
  has_associated_audits

  has_many :logs,
           class_name: 'TradeLog',
           inverse_of: :entry,
           foreign_key: :entry_id,
           dependent: :destroy

  has_many :active_logs,
           -> { active },
           class_name: 'TradeLog',
           inverse_of: :entry,
           foreign_key: :entry_id

  has_many :analyses,
           class_name: 'TimeframeAnalysis',
           inverse_of: :trade_entry,
           dependent: :destroy

  has_many :memos, as: :memoable, dependent: :destroy

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

  validates :margin, numericality: { greater_than_or_equals_to: 1 }
  validates :maker_percentage, numericality: { in: -1..1 }
  validates :taker_percentage, numericality: { in: -1..1 }

  before_save :calculate_and_persist_profit_values

  def position
    return nil if open_price.blank?

    open_price * amount * 1.0 / margin
  end

  def refresh_aggregate_with_callbacks
    scope = long? ? active_logs.long : active_logs.short
    inverse_scope = long? ? active_logs.short : active_logs.long

    update(
      amount: scope.sum(:amount),
      open_price: scope.weighted_avg,
      close_price: inverse_scope.weighted_avg,
      updated_at: Time.current,
    )
  end

  private

  def calculate_and_persist_profit_values
    return nil if close_price.blank? || position.blank?

    self.profit = (close_price - open_price) * amount
    self.profit_percentage = profit * 1.0 / position
    self.true_profit = profit - active_logs.sum(:fee)
    self.true_profit_percentage = true_profit * 1.0 / position
  end
end
