# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  get 'schools/get_all_schools', to: 'schools#all_schools'
  get 'schools/get_one_school', to: 'schools#one_school'
end
