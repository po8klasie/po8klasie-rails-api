# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs-api'
  devise_for :users, defaults: { format: :json }
  resources :institutions
  
  mount GoodJob::Engine => 'good_job'

end
