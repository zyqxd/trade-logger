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
#  margin                 :decimal(8, 2)    default(1.0), not null
#  open_price             :decimal(8, 2)
#  paper                  :boolean          default(FALSE), not null
#  profit                 :decimal(8, 2)
#  profit_percentage      :decimal(12, 8)
#  status                 :string           default("opened"), not null
#  true_profit            :decimal(8, 2)
#  true_profit_percentage :decimal(12, 8)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class TradeEntry < ApplicationRecord
  audited except: %i[
    created_at
    updated_at
    amount
    open_price
    close_price
    profit
    profit_percentage
    true_profit
    true_profit_percentage
  ]
  has_associated_audits

  has_many :logs,
           class_name: 'TradeLog',
           inverse_of: :entry,
           foreign_key: :entry_id,
           dependent: :destroy

  has_many :closed_logs,
           -> { closed },
           class_name: 'TradeLog',
           inverse_of: :entry,
           foreign_key: :entry_id

  has_many :memos, as: :memoable, dependent: :destroy

  enum status: {
    opened: 'opened',
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

  scope :paper, -> { where(paper: true) }
  scope :live, -> { where(paper: false) }
  scope :opened, -> { live.where(status: :opened) }
  scope :closed, -> { live.where(status: :closed) }
  scope :cancelled, -> { live.where(status: :cancelled) }

  validates :margin, numericality: { greater_than_or_equals_to: 1 }

  before_save :calculate_and_persist_profit_values

  def position
    return nil if open_price.blank?

    open_price * amount * 1.0 / margin
  end

  def refresh_aggregate_with_callbacks
    scope = long? ? closed_logs.long : closed_logs.short
    inverse_scope = long? ? closed_logs.short : closed_logs.long

    update(
      amount: scope.sum(:amount),
      open_price: scope.weighted_avg,
      close_price: inverse_scope.weighted_avg,
      updated_at: Time.current,
    )
  end

  def locked?
    cancelled? || closed?
  end

  private

  def calculate_and_persist_profit_values
    # NOTE(DZ): We want to only use closed logs. No paper profits
    return nil if close_price.blank? || position.blank?

    normalized_profit = (long? ? 1.0 : -1.0) * (close_price - open_price)
    closed_amount = (long? ? closed_logs.short : closed_logs.long).sum(:amount)
    self.profit = normalized_profit * closed_amount
    self.profit_percentage = profit * 100.0 / position
    self.true_profit = profit - closed_logs.sum(:fee)
    self.true_profit_percentage = true_profit * 100.0 / position
  end
end
