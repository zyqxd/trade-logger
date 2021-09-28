# frozen_string_literal: true

# == Schema Information
#
# Table name: memos
#
#  id            :bigint           not null, primary key
#  description   :text
#  memoable_type :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  memoable_id   :bigint
#
# Indexes
#
#  index_memos_on_memoable  (memoable_type,memoable_id)
#
class Memo < ApplicationRecord
  belongs_to_polymorphic :memoable,
                         allowed_classes: [TradeEntry, TradeLog],
                         inverse_of: :memos
end
