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
FactoryBot.define do
  factory :rating do
    user
    post
    value { Faker::Number.within(range: 1..5) }
  end
end
