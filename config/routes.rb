Rails.application.routes.draw do
  get 'home/index'
  get '/occupancies', to: 'occupancy#get_json'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
