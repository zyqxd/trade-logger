# frozen_string_literal: true

# == Schema Information
#
# Table name: timeframes
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_timeframes_on_code  (code) UNIQUE
#
class Timeframe < ApplicationRecord
  has_many :analyses,
           class_name: 'TradeLogAnalyses',
           inverse_of: :timeframe,
           dependent: :destroy
end
