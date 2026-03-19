# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :layout_by_resource

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def set_locale
    I18n.locale = params[:locale].presence_in(%w[ja en]) || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username profile avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username profile avatar])
  end

  def layout_by_resource
    devise_controller? ? "auth" : "application"
  end
end
