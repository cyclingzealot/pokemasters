Rails.application.routes.draw do
  resources :volunteer_attributes
  resources :volunteer_taggings
  resources :oganizations
  resources :assignments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
