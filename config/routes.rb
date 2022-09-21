Rails.application.routes.draw do
  get 'people/index'
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
