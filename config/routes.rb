Rails.application.routes.draw do
  root "books#index"
  resources :books
  match '/download_books', to: 'books#download', via: 'get'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
