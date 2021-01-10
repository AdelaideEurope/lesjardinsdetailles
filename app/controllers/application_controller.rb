class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :get_abbreviated_months

  include Pundit

  # A REVOIR
  # rescue_from Pundit::NotAuthorizedError, redirect_to root_path(notice: "Tu n'as pas le droit d'accéder à cette page 😬")

  after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def get_abbreviated_months
    @abbr_month_names = I18n.t(:abbr_month_names).map {|k, v| v}
  end

  def after_sign_in_path_for(resource)
    if resource.worker
      dashboard_path(resource.farm_id)
    end
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)/
  end
end
