# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      raw = request.env['omniauth.auth']
      auth = raw.respond_to?(:to_h) ? raw.to_h : {}
      auth = auth.deep_symbolize_keys

      email = auth.dig(:info, :email) || auth.dig(:extra, :raw_info, :email)
      return redirect_to new_user_session_path, alert: t('flash.oauth.email_missing') if email.blank?

      user = User.find_by(email: email)
      user ||= User.find_or_initialize_by(provider: auth[:provider], uid: auth[:uid])

      user.provider = auth[:provider] if user.provider.blank?
      user.uid      = auth[:uid]      if user.uid.blank?

      user.email = email if user.email.blank?
      user.password = Devise.friendly_token[0, 20] if user.encrypted_password.blank?

      user.save!

      sign_in_and_redirect user, event: :authentication
    rescue StandardError => e
      Rails.logger.error("[Google OAuth] #{e.class}: #{e.message}")
      redirect_to new_user_session_path, alert: t('flash.oauth.failure')
    end

    def failure
      redirect_to new_user_session_path, alert: t('flash.oauth.failure')
    end
  end
end
