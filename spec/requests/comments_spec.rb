# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_record) { create(:post) }

  describe 'POST /posts/:post_id/comments' do
    it 'redirects to sign_in when not logged in' do
      expect do
        post post_comments_path(post_record),
             params: { comment: { content: 'nice' } }
      end.not_to change(Comment, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'creates a comment and redirects to post show when logged in' do
      sign_in user

      expect do
        post post_comments_path(post_record),
             params: { comment: { content: 'nice' } }
      end.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
    end

    it 'renders posts/show with 422 when content is blank' do
      sign_in user

      expect do
        post post_comments_path(post_record),
             params: { comment: { content: '' } }
      end.not_to change(Comment, :count)

      expect(response).to have_http_status(:unprocessable_entity) # 422
      # render 'posts/show' なのでテンプレまで見るならこれ
      expect(response.body).to include('name="comment[content]"')
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    it 'redirects to sign_in when not logged in' do
      comment = create(:comment, user: user, post: post_record)

      expect do
        delete post_comment_path(post_record, comment)
      end.not_to change(Comment, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'deletes own comment and redirects' do
      sign_in user
      comment = create(:comment, user: user, post: post_record)

      expect do
        delete post_comment_path(post_record, comment)
      end.to change(Comment, :count).by(-1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
    end

    it 'does not delete others comment and redirects with alert' do
      sign_in user
      comment = create(:comment, user: other_user, post: post_record)

      expect do
        delete post_comment_path(post_record, comment)
      end.not_to change(Comment, :count)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(post_path(post_record, locale: I18n.locale))
      follow_redirect!
      expect(response.body).to include('削除できません')
    end
  end
end
