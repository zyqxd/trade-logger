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
  belongs_to :entry, class_name: 'TradeEntry', inverse_of: :logs

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
end
