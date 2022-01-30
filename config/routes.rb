# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  get 'institutions/get_all_institutions', to: 'institutions#all_institutions'
  get 'institutions/get_one_institution', to: 'institutions#one_institution'
  
  mount GoodJob::Engine => 'good_job'

end