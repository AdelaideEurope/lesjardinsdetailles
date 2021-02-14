class NewsletterSubscribersController < ApplicationController
    before_action :set_farm, only: [:index, :new, :create]
    skip_before_action :authenticate_user!, only: [ :create ]

    def index
      @newsletter_subscribers = NewsletterSubscriber.where(farm_id: @farm.id)
      authorize @newsletter_subscribers
      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    def new
      @newsletter_subscriber = NewsletterSubscriber.new
    end

    def create
      @newsletter_subscriber = NewsletterSubscriber.new(farm_id: 1, first_name: params[:first_name], email: params[:email])
      authorize @newsletter_subscriber
      if @newsletter_subscriber.save
      flash[:notice] = "C'est bon #{params[:first_name]}, vous êtes parmi les formidables destinataires de notre lettre d'info ! ☀️"
      redirect_to root_path(anchor: "newsletter")
    else
      redirect_to root_path
    end
    end

    def set_farm
      @farm = Farm.find(1)
    end

end
