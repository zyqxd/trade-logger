# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(TRUE), not null
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
FactoryBot.define do
  factory :plan do
    name { 'The plan' }
    margin { 1.0 }
  end
end
