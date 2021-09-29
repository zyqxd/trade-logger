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
require 'rails_helper'

describe TradeLog do
  describe '.weighted_avg' do
    it 'calculates weighted average' do
      create :trade_log, price: 400, amount: 0.5
      create :trade_log, price: 1000, amount: 0.5

      expect(described_class.weighted_avg).to eq 700
    end

    it 'calculates weighted average of scope' do
      create :trade_log, :closed, price: 400, amount: 0.5
      create :trade_log, :closed, price: 1000, amount: 0.5
      create :trade_log, :cancelled, price: 10_000, amount: 10

      expect(described_class.closed.weighted_avg).to eq 700
    end
  end
end
