class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :get_abbreviated_months
  before_action :get_short_abbreviated_months

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def get_abbreviated_months
    @abbr_month_names = I18n.t(:abbr_month_names).map {|k, v| v}
  end

  def get_short_abbreviated_months
    @short_abbr_month_names = I18n.t(:abbr_month_names).map {|k, v| v[0]}
  end

  def after_sign_in_path_for(resource)
    if resource.worker
      farm_dashboard_path(resource.farm_id)
    end
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)/
  end

  def user_not_authorized
    flash[:alert] = "⛔ Tu ne peux pas accéder à cette page top secrète !"
    redirect_to(request.referrer || root_path)
  end
end
