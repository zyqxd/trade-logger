# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                  :bigint           not null, primary key
#  edge                :text
#  enter_strategy      :text
#  exit_strategy       :text
#  margin              :decimal(8, 4)    default(1.0), not null
#  name                :string           not null
#  notes               :text
#  requirements        :text
#  risk_management     :text
#  timeframes          :text
#  trade_entries_count :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Plan < ApplicationRecord
  audited except: %i[created_at updated_at]

  has_many :trade_entries,
           class_name: 'TradeEntry',
           dependent: :nullify,
           inverse_of: :plan

  validates :name, presence: true
end
