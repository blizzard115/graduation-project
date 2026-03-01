# frozen_string_literal: true

module Users
  class GoogleOauthSignIn
    def initialize(auth_hash)
      @auth = normalize(auth_hash)
    end

    def call
      email = extracted_email
      raise ArgumentError, 'email is missing' if email.blank?

      user = find_user_by_email(email) || find_or_initialize_by_provider_uid
      attach_provider_uid(user)
      attach_email(user, email)
      ensure_password(user)

      user.tap(&:save!)
    end

    private

    attr_reader :auth

    def normalize(raw)
      hash = raw.respond_to?(:to_h) ? raw.to_h : {}
      hash.deep_symbolize_keys
    end

    def extracted_email
      auth.dig(:info, :email) || auth.dig(:extra, :raw_info, :email)
    end

    def find_user_by_email(email)
      User.find_by(email: email)
    end

    def find_or_initialize_by_provider_uid
      User.find_or_initialize_by(provider: auth[:provider], uid: auth[:uid])
    end

    def attach_provider_uid(user)
      user.provider ||= auth[:provider]
      user.uid ||= auth[:uid]
    end

    def attach_email(user, email)
      user.email = email if user.email.blank?
    end

    def ensure_password(user)
      return if user.encrypted_password.present?

      user.password = Devise.friendly_token[0, 20]
    end
  end
end
