# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id                     :bigint           not null, primary key
#  amount                 :decimal(12, 8)   default(0.0), not null
#  close_price            :decimal(8, 2)
#  coin                   :string           default("btcusdt"), not null
#  kind                   :string           default("long"), not null
#  margin                 :decimal(8, 2)    default(1.0), not null
#  open_price             :decimal(8, 2)
#  paper                  :boolean          default(FALSE), not null
#  paper_amount           :decimal(12, 8)   default(0.0)
#  paper_close_price      :decimal(8, 2)
#  paper_open_price       :decimal(8, 2)
#  profit                 :decimal(8, 2)
#  profit_percentage      :decimal(12, 8)
#  status                 :string           default("opened"), not null
#  true_profit            :decimal(8, 2)
#  true_profit_percentage :decimal(12, 8)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  plan_id                :bigint
#
# Indexes
#
#  index_trade_entries_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
class TradeEntry < ApplicationRecord
  audited except: %i[
    created_at
    updated_at
    amount
    open_price
    close_price
    paper_amount
    paper_open_price
    paper_close_price
    profit
    profit_percentage
    true_profit
    true_profit_percentage
  ]
  has_associated_audits

  belongs_to :plan,
             class_name: 'Plan',
             inverse_of: :trade_entries,
             counter_cache: true,
             optional: true

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
    adausdt: 'adausdt',
    adausdt: 'adausdt',
    btcusdt: 'btcusdt',
    btcusd: 'btcusd',
    ethusdt: 'ethusdt',
    ethusd: 'ethusd',
  }

  enum kind: {
    long: 'long',
    short: 'short',
  }

  scope :paper, -> { where(paper: true) }
  scope :live, -> { where(paper: false) }
  scope :live_opened, -> { live.where(status: :opened) }
  scope :live_closed, -> { live.where(status: :closed) }
  scope :live_cancelled, -> { live.where(status: :cancelled) }

  validates :margin, numericality: { greater_than_or_equals_to: 1 }

  before_save :calculate_and_persist_profit_values

  def position
    return nil if open_price.blank?

    open_price * amount * 1.0 / margin
  end

  def refresh_aggregate_with_callbacks
    scope = long? ? logs.long : logs.short
    inverse = long? ? logs.short : logs.long

    # TODO(DZ): There are a lot of db calls here
    update(
      paper_amount: scope.sum(:amount),
      paper_open_price: scope.weighted_avg,
      paper_close_price: inverse.weighted_avg,
      amount: scope.closed.sum(:amount),
      open_price: scope.closed.weighted_avg,
      close_price: inverse.closed.weighted_avg,
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

    # TODO(DZ): There are a lot of db calls here
    normalized_profit = (long? ? 1.0 : -1.0) * (close_price - open_price)
    closed_amount = (long? ? closed_logs.short : closed_logs.long).sum(:amount)
    self.profit = normalized_profit * closed_amount
    self.profit_percentage = profit * 100.0 / position
    self.true_profit = profit - closed_logs.sum(:fee)
    self.true_profit_percentage = true_profit * 100.0 / position
  end
end
