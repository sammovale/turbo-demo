Rails.application.routes.draw do
  resources :network_hosts do
    collection do
      resource :bulk_update, only: :update, module: :network_hosts
    end

    resource :status, only: %i[ edit update ], module: :network_hosts
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "network_hosts#index"
end
