# frozen_string_literal: true

# == Schema Information
#
# Table name: trade_log_analyses
#
#  id               :bigint           not null, primary key
#  bbwp             :decimal(8, 2)
#  bbwp_exponential :decimal(8, 4)
#  bbwp_trend       :string
#  rsi              :decimal(8, 4)
#  rsi_exponential  :decimal(8, 4)
#  rsi_trend        :string
#  stoch_fast       :decimal(8, 4)
#  stoch_slow       :decimal(8, 4)
#  stoch_trend      :string
#  trend            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  timeframe_id     :bigint           not null
#  trade_log_id     :bigint           not null
#
# Indexes
#
#  index_trade_log_analyses_on_timeframe_id  (timeframe_id)
#  index_trade_log_analyses_on_trade_log_id  (trade_log_id)
#
# Foreign Keys
#
#  fk_rails_...  (timeframe_id => timeframes.id)
#  fk_rails_...  (trade_log_id => trade_logs.id)
#
class TradeLogAnalysis < ApplicationRecord
  belongs_to :trade_log, inverse_of: :analyses
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
