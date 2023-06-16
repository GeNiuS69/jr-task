# frozen_string_literal: true

class Api::PostsController < ApplicationController
  def create
    user = User.find_or_create_by(user_params)
    return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity unless user.persisted?

    post = user.posts.create(post_params)
    if post.errors.any?
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    else
      render json: post.as_json(include: :user), status: :created
    end
  end

  def rate
    post = Post.find(params[:post_id])
    user = User.find(params[:user_id])
    Rating.create(rate_params) unless Rating.find_by(post:, user:)
    post.reload
    render json: post.rating, status: :created
  end

  def top
    render json: Post.top(params[:n]).as_json(only: %i[id title body])
  end

  def ips
    render json: Post.ips.to_json(only: %i[ip authors])
  end

  private

  def user_params
    params.permit(%i[login])
  end

  def post_params
    params.permit(%i[title body ip])
  end

  def rate_params
    params.permit(%i[post_id user_id value])
  end
end
