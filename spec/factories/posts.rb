# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  title      :string           not null
#  body       :string           not null
#  ip         :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :post do
    user
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph(sentence_count: rand(1..10)) }
    ip { Faker::Internet.ip_v4_address }
  end
end
