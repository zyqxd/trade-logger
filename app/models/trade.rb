# frozen_string_literal: true

# == Schema Information
#
# Table name: trades
#
#  id             :bigint           not null, primary key
#  amount         :decimal(8, 8)    default(0.0), not null
#  close_price    :decimal(8, 2)
#  close_time     :datetime
#  open_price     :decimal(8, 2)
#  open_time      :datetime
#  post_close     :boolean          default(FALSE), not null
#  post_open      :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trade_entry_id :bigint           not null
#
# Indexes
#
#  index_trades_on_trade_entry_id  (trade_entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (trade_entry_id => trade_entries.id)
#
class Trade < ApplicationRecord
  belongs_to :trade_entry, inverse_of: :trades
end
