# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id                     :bigint           not null, primary key
#  amount                 :decimal(16, 10)  default(0.0), not null
#  close_price            :decimal(14, 6)
#  coin                   :string           default("btcusdt"), not null
#  kind                   :string           default("long"), not null
#  margin                 :decimal(8, 2)    default(1.0), not null
#  open_price             :decimal(14, 6)
#  paper                  :boolean          default(FALSE), not null
#  paper_amount           :decimal(12, 8)   default(0.0)
#  paper_close_price      :decimal(14, 6)
#  paper_open_price       :decimal(14, 6)
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
require 'rails_helper'

describe TradeEntry do
  describe 'before_save :calculate_and_persist_profit_values' do
    context 'without logs' do
      let(:trade_entry) { create :trade_entry }

      it 'returns nil for profit' do
        expect(trade_entry.profit).to be_nil
      end

      it 'returns nil for profit_percentage' do
        expect(trade_entry.profit_percentage).to be_nil
      end

      it 'returns nil for true_profit' do
        expect(trade_entry.true_profit).to be_nil
      end

      it 'returns nil for true_profit_percentage' do
        expect(trade_entry.true_profit_percentage).to be_nil
      end
    end

    context 'when positions are not closed (without closed logs)' do
      let(:trade_entry) { create :trade_entry, :long }
      before do
        create :trade_log, :opened, :long, entry: trade_entry
        create :trade_log, :opened, :short, entry: trade_entry
      end

      it 'returns nil for profit' do
        expect(trade_entry.profit).to be_nil
      end

      it 'returns nil for profit_percentage' do
        expect(trade_entry.profit_percentage).to be_nil
      end

      it 'returns nil for true_profit' do
        expect(trade_entry.true_profit).to be_nil
      end

      it 'returns nil for true_profit_percentage' do
        expect(trade_entry.true_profit_percentage).to be_nil
      end
    end

    context 'with logs for a long winner' do
      let(:trade_entry) { create :complete_trade_entry, :long, winner: true }

      it 'profit is the difference of longs and shorts times amount' do
        expect(trade_entry.profit).to eq 2000
      end

      it 'returns profit_percentage correctly' do
        expect(trade_entry.profit_percentage).to eq 400
      end

      it 'returns true_profit correctly' do
        expect(trade_entry.true_profit).to eq 2001.02
      end

      it 'returns profit_percentage correctly' do
        expect(trade_entry.true_profit_percentage).to eq 400.204
      end
    end

    context 'with logs for a short loser' do
      let(:trade_entry) { create :complete_trade_entry, :short, winner: false }

      it 'profit is the difference of longs and shorts times amount' do
        expect(trade_entry.profit).to eq(-2000)
      end

      it 'returns profit_percentage correctly' do
        expect(trade_entry.profit_percentage).to be_within(0.001).of(-133.333)
      end

      it 'returns true_profit correctly' do
        expect(trade_entry.true_profit).to be_within(0.01).of(-1998.98)
      end

      it 'returns profit_percentage correctly' do
        expect(trade_entry.true_profit_percentage).to(
          be_within(0.001).of(-133.265),
        )
      end
    end

    context 'other' do
      let(:trade_entry) { create :trade_entry, :long }

      it 'profit only takes in amount that has closed' do
        create :trade_log, :long, :closed,
               entry: trade_entry,
               amount: 1,
               price: 800

        create :trade_log, :short, :closed,
               entry: trade_entry,
               amount: 1,
               price: 1000

        create :trade_log, :long, entry: trade_entry, amount: 1, price: 800

        expect(trade_entry.profit).to eq(200)
      end
    end
  end

  describe '#refresh_aggregate_with_callbacks' do
    let(:entry) { create :trade_entry, :long }

    it 'saves amount as 0 if no opens were present' do
      create :trade_log, :short, entry: entry

      expect(entry.amount).to eq 0.0
    end

    it 'saves amount as sum of closed long logs' do
      create :trade_log, :long, amount: 0.1, entry: entry
      create :trade_log, :long, amount: 0.2, entry: entry

      expect(entry.amount).to eq 0.3
    end

    it 'saves open_price as nil if no opens were present' do
      create :trade_log, :short, entry: entry

      expect(entry.open_price).to be_nil
    end

    it 'saves close_price as weighted average of closed long logs' do
      create :trade_log, :long, price: 100, amount: 0.1, entry: entry
      create :trade_log, :long, price: 50, amount: 0.2, entry: entry

      expect(entry.open_price).to be_within(0.01).of(66.66)
    end

    it 'saves close_price as nil if no closes were present' do
      create :trade_log, :long, entry: entry

      expect(entry.close_price).to be_nil
    end

    it 'saves close_price as weighted average of closed short logs' do
      create :trade_log, :short, price: 100, amount: 0.1, entry: entry
      create :trade_log, :short, price: 50, amount: 0.2, entry: entry

      expect(entry.close_price).to be_within(0.01).of(66.66)
    end

    it 'saves paper amount as sum of all long logs' do
      create :trade_log, :long, amount: 0.1, entry: entry
      create :trade_log, :long, :opened, amount: 0.2, entry: entry

      expect(entry.paper_amount).to eq 0.3
    end

    it 'saves paper_open_price as weighted average of all long logs' do
      create :trade_log, :long, price: 100, amount: 0.1, entry: entry
      create :trade_log, :long, :opened, price: 50, amount: 0.2, entry: entry

      expect(entry.paper_open_price).to be_within(0.01).of(66.66)
    end

    it 'saves paper_close_price as weighted average of all short logs' do
      create :trade_log, :short, price: 100, amount: 0.1, entry: entry
      create :trade_log, :short, :opened, price: 50, amount: 0.2, entry: entry

      expect(entry.paper_close_price).to be_within(0.01).of(66.66)
    end
  end

  describe '#position' do
    it 'is nil if open_price is nil' do
      trade_entry = create :trade_entry, open_price: nil, amount: 1

      expect(trade_entry.position).to be_nil
    end

    it 'is the product of open_price and amount divided by margin' do
      trade_entry = create :trade_entry, open_price: 1_000, amount: 1, margin: 5

      expect(trade_entry.position).to eq 200
    end
  end

  describe '#locked?' do
    let(:trade_entry) { create :trade_entry }

    it 'is false if opened' do
      trade_entry.opened!

      expect(trade_entry.locked?).to eq false
    end

    it 'is true if cancelled' do
      trade_entry.cancelled!

      expect(trade_entry.locked?).to eq true
    end

    it 'is true if closed' do
      trade_entry.closed!

      expect(trade_entry.locked?).to eq true
    end
  end
end
