class NewsletterSubscribersController < ApplicationController
    before_action :set_farm, only: [:index, :new, :create]

    def index
      @newsletter_subscribers = NewsletterSubscriber.where(farm_id: @farm.id)
      authorize @newsletter_subscribers
    end

    def new
      @newsletter_subscriber = NewsletterSubscriber.new
    end

    def create
      @newsletter_subscriber = NewsletterSubscriber.new(farm_id: 1, first_name: params[:newsletter_subscriber][:first_name], email: params[:newsletter_subscriber][:email])
      authorize @newsletter_subscriber
      if @newsletter_subscriber.save
      flash[:notice] = "C'est bon, vous êtes parmi les chanceux destinataires de notre lettre d'info !"
      redirect_to root_path(anchor: "newsletter")
    else
      redirect_to root_path
    end
    end

    def set_farm
      @farm = Farm.find(1)
    end

end
