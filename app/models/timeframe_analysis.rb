# == Schema Information
#
# Table name: timeframe_analyses
#
#  id              :bigint           not null, primary key
#  bbwp            :decimal(8, 2)
#  bbwp_trend      :string
#  rsi             :decimal(8, 2)
#  rsi_exponential :decimal(8, 2)
#  rsi_trend       :string
#  stoch_fast      :decimal(8, 2)
#  stoch_rsi_trend :string
#  stoch_slow      :decimal(8, 2)
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
class TimeframeAnalysis < ApplicationRecord
  belongs_to :trade_entry, inverse_of: :analyses
  belongs_to :timeframe, inverse_of: :analyses

  enum trend: {
    up: 'up',
    down: 'down',
    consolidation: 'consolidation'
  }, _suffix: :trend

  enum rsi_trend: { up: 'up', down: 'down' }, _suffix: :rsi
  enum stock_rsi_trend: { up: 'up', down: 'down' }, _suffix: :stock_rsi
  enum bbwp: { up: 'up', down: 'down' }, _suffix: :bbwp
end
