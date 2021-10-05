# frozen_string_literal: true

require 'rails_helper'

describe Trades::Admin::TradeEntryForm do
  describe '#margin' do
    it 'returns margin if trade entry is persisted' do
      trade_entry = create :trade_entry, margin: 20
      form = described_class.new(trade_entry)

      expect(form.margin).to eq trade_entry.margin
    end

    it 'returns margin if trade entry has no plan' do
      trade_entry = build :trade_entry, margin: 20
      form = described_class.new(trade_entry)

      expect(form.margin).to eq trade_entry.margin
    end

    it 'returns plan margin if trade entry is new and has plan' do
      plan = create :plan, margin: 55
      trade_entry = build :trade_entry, margin: 20, plan: plan
      form = described_class.new(trade_entry)

      expect(form.margin).to eq plan.margin
    end
  end

  describe '#status=' do
    let(:form) { described_class.new }

    it 'updates status to cancelled' do
      trade_entry = create :trade_entry
      form = described_class.new(trade_entry)

      form.status = 'cancelled'
      expect(trade_entry.status).to eq 'cancelled'

      form.save!
      expect(trade_entry.reload.status).to eq 'cancelled'
    end

    it 'updates status to opened' do
      trade_entry = create :trade_entry, :closed
      form = described_class.new(trade_entry)

      form.status = 'opened'
      expect(trade_entry.status).to eq 'opened'

      form.save!
      expect(trade_entry.reload.status).to eq 'opened'
    end

    it 'updates status to closed and all logs to closed' do
      trade_entry = create :trade_entry, :opened
      log = create :trade_log, :opened, entry: trade_entry
      form = described_class.new(trade_entry)

      form.status = 'closed'
      expect(trade_entry.status).to eq 'closed'

      form.save!
      expect(trade_entry.reload.status).to eq 'closed'
      expect(log.reload.status).to eq 'closed'
    end
  end
end
