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
class TradeLog < ApplicationRecord
  audited associated_with: :entry, except: %i[fee created_at updated_at]

  extension RefreshExplicitCounterCache, :entry, :aggregate_with_callbacks

  belongs_to :entry, class_name: 'TradeEntry', inverse_of: :logs

  has_many :analyses,
           class_name: 'TradeLogAnalysis',
           inverse_of: :trade_log,
           dependent: :destroy

  has_many :memos, as: :memoable, dependent: :destroy

  enum status: { opened: 'opened', closed: 'closed' }

  enum kind: {
    long: 'long',
    short: 'short',
  }

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_and_persist_fee
  before_save :calculate_and_persist_status

  class << self
    def weighted_avg
      return nil unless exists?

      select(
        Arel::Nodes::Multiplication.new(
          arel_table[:price],
          arel_table[:amount],
        ).as('product'),
      ).to_a.sum { |v| v['product'] } / sum(:amount)
    end
  end

  def locked?
    closed?
  end

  private

  def calculate_and_persist_status; end

  BYBIT_TAKER_FEE = 0.00075
  BYBIT_MAKER_FEE = -0.00025
  def calculate_and_persist_fee
    self.fee = price * amount * (post ? BYBIT_MAKER_FEE : BYBIT_TAKER_FEE)
  end
end
