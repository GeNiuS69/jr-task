# frozen_string_literal: true

class Api::PostsController < ApplicationController
  def create
    user = User.find_or_create_by(params[:login])
    post = user.posts.create(post_params)
    if post.errors.any?
      render json: post.errors.full_messages
    else
      render post.as_json(include: :user)
    end
  end

  def rate
    post = Post.find(params[:post_id])
    user = User.find(params[:user_id])
    Rating.create(rate_params) unless Rating.find_by(post:, user:)
    post.reload
    render json: post.rating
  end

  def top
    posts = Post.top(params[:n])
    render posts.as_json(only: %i[id title body])
  end

  def ips
    render Post.ips.to_json(only: %i[ip authors])
  end

  private

  def post_params
    params.permit(%i[title body ip])
  end

  def rate_params
    params.permit(%i[post_id user_id value])
  end
end
