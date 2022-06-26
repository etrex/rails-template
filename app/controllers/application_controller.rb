class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers

  def authenticate_user
    return if current_user.present?
    redirect_to user_line_omniauth_authorize_path
  end

  def line_messaging_login
    return unless user_from_line?
    sign_in line_user
  end

  def user_from_line?
    params[:platform_type].present?   &&
    params[:source_type].present?     &&
    params[:source_group_id].present? &&
    params[:source_user_id].present?
  end

  private

  def line_user
    name = params.dig(:profile, :displayName)
    line_id = params.dig(:source_user_id)

    user = User.find_or_create_by(line_id: line_id)
    user.update(name: name)
    user
  end
end