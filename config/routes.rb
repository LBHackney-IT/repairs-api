# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :properties, only: [:index, :show]
    end
  end

  get :healthcheck, to: proc { [200, {}, %w[OK]] }
end
