# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  login      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :login, presence: true, uniqueness: true
end
