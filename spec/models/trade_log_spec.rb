# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_logs
#
#  id         :bigint           not null, primary key
#  amount     :decimal(16, 10)  not null
#  close_time :datetime
#  fee        :decimal(8, 2)    default(0.0), not null
#  kind       :string           default("long"), not null
#  post       :boolean          default(FALSE), not null
#  price      :decimal(14, 6)   not null
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
    it 'returns nil if scope was empty' do
      expect(described_class.weighted_avg).to eq nil
    end

    it 'calculates weighted average' do
      create :trade_log, price: 400, amount: 0.5
      create :trade_log, price: 1000, amount: 0.5

      expect(described_class.weighted_avg).to eq 700
    end

    it 'calculates weighted average of scope' do
      create :trade_log, :closed, price: 400, amount: 0.5
      create :trade_log, :closed, price: 1000, amount: 0.5
      create :trade_log, :opened, price: 10_000, amount: 10

      expect(described_class.closed.weighted_avg).to eq 700
    end
  end

  describe 'before_save :calculate_and_persist_fee' do
    it 'returns product of price and amount with maker fee if post' do
      trade_log = create :trade_log, price: 1_000, amount: 1, post: true

      expect(trade_log.fee).to eq 1000 * TradeLog::BYBIT_MAKER_FEE
    end

    it 'returns product of price and amount with taker fee if not post' do
      trade_log = create :trade_log, price: 1_000, amount: 1, post: false

      expect(trade_log.fee).to eq 1000 * TradeLog::BYBIT_TAKER_FEE
    end
  end

  describe '#locked?' do
    let(:trade_log) { create :trade_log }

    it 'is false if opened' do
      trade_log.opened!

      expect(trade_log.locked?).to eq false
    end

    it 'is true if closed' do
      trade_log.closed!

      expect(trade_log.locked?).to eq true
    end
  end
end
