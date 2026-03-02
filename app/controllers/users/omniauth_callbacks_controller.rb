# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth = request.env['omniauth.auth']
      user = Users::GoogleOauthSignIn.new(auth).call
      sign_in_and_redirect user, event: :authentication
    rescue StandardError => e
      Rails.logger.error("[Google OAuth] #{e.class}: #{e.message}")
      redirect_to new_user_session_path, alert: t('flash.oauth.google_failed')
    end

    def failure
      redirect_to new_user_session_path, alert: t('flash.oauth.google_failed')
    end
  end
end
