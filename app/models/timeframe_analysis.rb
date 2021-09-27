# frozen_string_literal: true

# == Schema Information
#
# Table name: timeframe_analyses
#
#  id              :bigint           not null, primary key
#  bbwp            :decimal(8, 2)
#  bbwp_trend      :string
#  kind            :string           default("open"), not null
#  rsi             :decimal(8, 2)
#  rsi_exponential :decimal(8, 2)
#  rsi_trend       :string
#  stoch_fast      :decimal(8, 2)
#  stoch_slow      :decimal(8, 2)
#  stoch_trend     :string
#  trend           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  timeframe_id    :bigint           not null
#  trade_entry_id  :bigint           not null
#
# Indexes
#
#  index_timeframe_analyses_on_timeframe_id    (timeframe_id)
#  index_timeframe_analyses_on_trade_entry_id  (trade_entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (timeframe_id => timeframes.id)
#  fk_rails_...  (trade_entry_id => trade_entries.id)
#
# TODO(DZ): drop
class TimeframeAnalysis < ApplicationRecord
  belongs_to :trade_entry, inverse_of: :analyses
  belongs_to :timeframe, inverse_of: :analyses

  enum kind: {
    open: 'open',
    fill: 'fill',
    close: 'close',
    cancel: 'cancel',
  }, _prefix: :on

  enum trend: {
    up: 'up',
    down: 'down',
    consolidation: 'consolidation',
  }, _suffix: :trend

  enum rsi_trend: { up: 'up', down: 'down' }, _suffix: :rsi
  enum stoch_trend: { up: 'up', down: 'down' }, _suffix: :stoch
  enum bbwp_trend: { up: 'up', down: 'down' }, _suffix: :bbwp
end
