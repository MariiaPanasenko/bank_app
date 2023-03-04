# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root "transactions#index"

  resources :transactions, only: [:index, :new, :create]
end
