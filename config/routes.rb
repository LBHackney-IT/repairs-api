# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v2 do
      resources :properties, only: %i(index show) do
        resources :cautionary_alerts, path: "/cautionary-alerts", only: [:index]
      end
    end
  end

  get :healthcheck, to: proc { [200, {}, %w[OK]] }

  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
end
