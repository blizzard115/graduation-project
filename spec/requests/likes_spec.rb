# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post) }

  describe 'POST /posts/:post_id/like' do
    it 'redirects to sign_in when not logged in' do
      expect do
        post post_like_path(post_record)
      end.not_to change(Like, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'creates a like and redirects when logged in' do
      sign_in user

      expect do
        post post_like_path(post_record),
             headers: { 'HTTP_REFERER' => post_path(post_record, locale: I18n.locale) }
      end.to change(Like, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
    end

    it 'does not increase likes count on duplicate like and redirects' do
      sign_in user

      post post_like_path(post_record),
           headers: { 'HTTP_REFERER' => post_path(post_record, locale: I18n.locale) }

      expect do
        post post_like_path(post_record),
             headers: { 'HTTP_REFERER' => post_path(post_record, locale: I18n.locale) }
      end.not_to change(Like, :count)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
    end
  end

  describe 'DELETE /posts/:post_id/like' do
    it 'redirects to sign_in when not logged in' do
      expect do
        delete post_like_path(post_record)
      end.not_to change(Like, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'deletes a like and redirects when logged in' do
      sign_in user
      create(:like, user: user, post: post_record)

      expect do
        delete post_like_path(post_record),
               headers: { 'HTTP_REFERER' => post_path(post_record, locale: I18n.locale) }
      end.to change(Like, :count).by(-1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
    end

    it 'does not error when like does not exist and redirects' do
      sign_in user

      expect do
        delete post_like_path(post_record),
               headers: { 'HTTP_REFERER' => post_path(post_record, locale: I18n.locale) }
      end.not_to change(Like, :count)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
    end
  end
end
