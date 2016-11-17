Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help' #creates two variables: help_path and help_url
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
end