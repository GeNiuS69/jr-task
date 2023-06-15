# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  user_id    :bigint           not null
#  post_id    :bigint           not null
#  value      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :value, presence: true, inclusion: { in: 1..5 }, numericality: true
  validates :post_id, uniqueness: { scope: :user_id }
end
