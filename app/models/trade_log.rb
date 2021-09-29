# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_logs
#
#  id         :bigint           not null, primary key
#  amount     :decimal(12, 8)   not null
#  close_time :datetime
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
  audited associated_with: :entry, except: %i[created_at updated_at]

  belongs_to :entry, class_name: 'TradeEntry', inverse_of: :logs

  has_many :analyses,
           class_name: 'TradeLogAnalysis',
           inverse_of: :trade_log,
           dependent: :destroy

  has_many :memos, as: :memoable, dependent: :destroy

  enum status: {
    opened: 'opened',
    closed: 'closed',
    cancelled: 'cancelled',
  }

  enum kind: {
    long: 'long',
    short: 'short',
  }

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  class << self
    def weighted_avg
      select(
        Arel::Nodes::Multiplication.new(
          arel_table[:price],
          arel_table[:amount],
        ).as('product'),
      ).to_a.sum { |v| v['product'] } / sum(:amount)
    end
  end
end
