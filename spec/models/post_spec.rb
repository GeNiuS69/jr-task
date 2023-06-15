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
require 'rails_helper'

RSpec.describe Post do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:ratings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:ip) }
  end

  describe '#rating' do
    let(:post) { create(:post) }

    it 'returns zero without any ratings' do
      expect(post.rating).to eq(0)
    end

    it 'returns non-zero with any ratings' do
      create_list(:rating, 5, post:)
      expect(post.rating).not_to eq(0)
    end
  end

  describe '#top' do
    it 'returns not more than N' do
      create_list(:post, 10)

      expect(described_class.top(3).length).to eq(3)
    end

    it 'returns array' do
      post2 = create(:post)
      create_list(:rating, 3, post: post2)
      post1 = create(:post)
      create_list(:rating, 5, post: post1, value: 5)

      expect(described_class.top).to eq([post1, post2])
    end
  end

  describe '#ips' do
    context 'when same IP' do
      let(:ip) { '192.168.0.1' }

      before do
        create_list(:post, 3, ip:)
      end

      it 'returns ip' do
        expect(described_class.ips[0]&.ip.to_s).to eq(ip)
      end

      it 'returns logins' do
        expect(described_class.ips[0]&.authors).not_to be_empty
      end

      it 'returns 3 logins' do
        expect(described_class.ips[0]&.authors&.length).to eq(3)
      end
    end

    context 'when different IP' do
      it 'returns empty array' do
        create(:post, ip: '192.168.0.1')
        create(:post, ip: '192.168.1.1')

        expect(described_class.ips).to be_empty
      end
    end
  end
end
