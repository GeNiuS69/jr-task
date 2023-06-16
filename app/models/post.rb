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

  def self.top(limit = nil)
    limit ||= 3
    select('posts.*, coalesce(AVG(ratings.value), 0) AS rating')
      .joins('LEFT JOIN ratings ON posts.id = ratings.post_id')
      .group('posts.id')
      .order('rating DESC')
      .limit(limit)
  end

  def self.ips
    select('posts.ip, ARRAY_AGG(DISTINCT users.login) AS authors')
      .joins(:user)
      .group('posts.ip')
      .having('COUNT(DISTINCT users.login) > 1')
  end

  def rating
    ratings.average(:value).to_f
  end
end
