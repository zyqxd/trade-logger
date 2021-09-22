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
class Timeframe < ApplicationRecord
  has_many :analyses,
           class_name: 'TimeframeAnalysis',
           inverse_of: :timeframe,
           dependent: :destroy
end
