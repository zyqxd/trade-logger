# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_entries
#
#  id               :bigint           not null, primary key
#  amount           :decimal(12, 8)   default(1.0), not null
#  close_price      :decimal(8, 2)
#  coin             :string           default("btcusdt"), not null
#  kind             :string           default("long"), not null
#  maker_percentage :decimal(6, 5)    default(0.0), not null
#  margin           :decimal(8, 2)    default(1.0), not null
#  open_price       :decimal(8, 2)
#  paper            :boolean          default(FALSE), not null
#  status           :string           default("opened"), not null
#  taker_percentage :decimal(6, 5)    default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

describe TradeEntry do
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

  describe '#profit' do
    it 'is nil if open_price is nil' do
      trade_entry = create :trade_entry, open_price: nil

      expect(trade_entry.profit).to be_nil
    end

    it 'is nil if close_price is nil' do
      trade_entry = create :trade_entry, close_price: nil

      expect(trade_entry.profit).to be_nil
    end

    it 'is the difference of open_price and close_price' do
      trade_entry = create :trade_entry, open_price: 1_000, close_price: 2_000

      expect(trade_entry.profit).to eq 1_000
    end
  end

  describe '#profit_percentage' do
    it 'returns nil if profit is blank' do
      allow_any_instance_of(TradeEntry).to receive(:profit).and_return(nil)
      trade_entry = create :trade_entry

      expect(trade_entry.profit_percentage).to be_nil
    end

    it 'returns nil if position is blank' do
      allow_any_instance_of(TradeEntry).to receive(:position).and_return(nil)
      trade_entry = create :trade_entry

      expect(trade_entry.profit_percentage).to be_nil
    end

    it 'returns the quotient of profit and position' do
      allow_any_instance_of(TradeEntry).to receive(:profit).and_return(1_000)
      allow_any_instance_of(TradeEntry).to receive(:position).and_return(100)
      trade_entry = create :trade_entry

      expect(trade_entry.profit_percentage).to eq 10
    end
  end

  describe '#open_fee' do
    it 'returns 0 if open_price is blank' do
      trade_entry = create :trade_entry, open_price: nil

      expect(trade_entry.open_fee).to be_zero
    end

    it 'returns product of open_price and taker_percentage if post_open' do
      trade_entry = create :trade_entry,
                           open_price: 1_000,
                           taker_percentage: 0.1,
                           post_open: true

      expect(trade_entry.open_fee).to eq 100
    end

    it 'returns product of open_price and maker_percentage if !post_open' do
      trade_entry = create :trade_entry,
                           open_price: 1_000,
                           maker_percentage: 0.1,
                           post_open: false

      expect(trade_entry.open_fee).to eq 100
    end
  end

  describe '#close_fee' do
    it 'returns 0 if close_price is blank' do
      trade_entry = create :trade_entry, close_price: nil

      expect(trade_entry.close_fee).to be_zero
    end

    it 'returns product of close_price and taker_percentage if post_close' do
      trade_entry = create :trade_entry,
                           close_price: 1_000,
                           taker_percentage: 0.1,
                           post_close: true

      expect(trade_entry.close_fee).to eq 100
    end

    it 'returns product of close_price and maker_percentage if !post_close' do
      trade_entry = create :trade_entry,
                           close_price: 1_000,
                           maker_percentage: 0.1,
                           post_close: false

      expect(trade_entry.close_fee).to eq 100
    end
  end

  describe '#true_profit' do
    it 'returns nil if profit is nil' do
      allow_any_instance_of(TradeEntry).to receive(:profit).and_return(nil)
      trade_entry = create :trade_entry

      expect(trade_entry.true_profit).to be_nil
    end

    it 'returns the difference of profit and open_fees + close_fees' do
      allow_any_instance_of(TradeEntry).to receive(:profit).and_return(1_000)
      allow_any_instance_of(TradeEntry).to receive(:open_fee).and_return(100)
      allow_any_instance_of(TradeEntry).to receive(:close_fee).and_return(100)
      trade_entry = create :trade_entry

      expect(trade_entry.true_profit).to eq 800
    end
  end

  describe '#true_profit_percentage' do
    it 'returns nil if true_profit is nil' do
      allow_any_instance_of(TradeEntry).to receive(:true_profit).and_return(nil)
      trade_entry = create :trade_entry

      expect(trade_entry.true_profit_percentage).to be_nil
    end

    it 'returns the quotient of true_profit and position' do
      allow_any_instance_of(TradeEntry).to receive(:true_profit).and_return(100)
      allow_any_instance_of(TradeEntry).to receive(:position).and_return(200)
      trade_entry = create :trade_entry

      expect(trade_entry.true_profit_percentage).to eq 0.5
    end
  end
end
