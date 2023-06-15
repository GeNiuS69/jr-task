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
class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy

  validates :title, :body, :ip, presence: true

  def self.top(n = 5)
    select('posts.*, AVG(ratings.value) AS rating')
      .joins('LEFT JOIN ratings ON posts.id = ratings.post_id')
      .group('posts.id')
      .order('rating DESC')
      .limit(n)
  end

  def self.ips
    select('posts.ip, ARRAY_AGG(users.login) AS authors')
      .joins(:user)
      .group('posts.ip')
      .having('COUNT(*) > 1')
  end

  def rating
    ratings.average(:value).to_f
  end
end
