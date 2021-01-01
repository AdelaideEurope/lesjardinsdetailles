class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include Pundit

  # A REVOIR
  # rescue_from Pundit::NotAuthorizedError, redirect_to root_path(notice: "Tu n'as pas le droit d'accéder à cette page 😬")

  after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?


  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
