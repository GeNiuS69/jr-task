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
require 'rails_helper'

RSpec.describe Rating do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe 'validations' do
    subject { build(:rating) }

    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_numericality_of(:value) }
    it { is_expected.to validate_inclusion_of(:value).in_range(1..5) }

    it { is_expected.to validate_uniqueness_of(:post_id).scoped_to(:user_id) }
  end
end
