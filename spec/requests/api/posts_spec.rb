# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Posts' do
  describe 'POST /api/posts' do
    context 'when success' do
      context 'when user exists' do
        let(:user) { create(:user) }
        let(:post_params) do
          { login: user.login,
            title: 'Some title',
            body: 'Some body. Some body.',
            ip: '192.168.0.1' }
        end

        before do
          post '/api/posts', params: post_params
        end

        it 'returns 201 code' do
          expect(response).to have_http_status(:created)
        end

        it 'return same user_id' do
          expect(response.parsed_body).to include('user_id' => user.id)
        end

        it 'returns necessary keys' do
          expect(response.parsed_body.keys).to include(*%w[id user_id title body ip user])
        end
      end

      context 'when user don\'t exists' do
        let(:post_params) do
          { login: 'someextrauser',
            title: 'Some title',
            body: 'Some body. Some body.',
            ip: '192.168.0.1' }
        end

        it 'creates new user' do
          expect { post('/api/posts', params: post_params) }.to change(User, :count)
        end
      end
    end

    context 'when fail' do
      context 'when login params is absence' do
        it 'returns 422 code' do
          post '/api/posts', params: {}
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when login params is present' do
        it 'returns 422 code' do
          post '/api/posts', params: { login: 'login' }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'POST /api/posts/:post_id/rate' do
    let(:user) { create(:user) }
    let(:my_post) { create(:post) }
    let(:rating_params) do
      {
        user_id: user.id,
        value: 3
      }
    end

    context 'when user didn\'t rate yet' do
      it 'increases ratings count' do
        expect { post("/api/posts/#{my_post.id}/rate", params: rating_params) }.to change(Rating, :count)
      end
    end

    context 'when user already have rating' do
      before do
        create(:rating, user:, post: my_post)
      end

      it 'didn\'t change ratings count' do
        expect { post("/api/posts/#{my_post.id}/rate", params: rating_params) }.not_to change(Rating, :count)
      end
    end
  end

  describe 'GET /api/posts/top' do
    before do
      post = create(:post)
      create(:rating, post:)
      get '/api/posts/top'
    end

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns something' do
      expect(response.body).not_to be_empty
    end

    it 'returns necessary keys' do
      expect(response.parsed_body.first.keys).to include(*%w[id title body])
    end
  end

  describe 'GET /api/posts/ips' do
    let(:ip) { '192.168.0.1' }

    before do
      create_list(:post, 3, ip:)

      get '/api/posts/ips'
    end

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns something' do
      expect(response.body).not_to be_empty
    end

    it 'returns necessary keys' do
      expect(response.parsed_body.first.keys).to include(*%w[ip authors])
    end
  end
end
