Rails.application.routes.draw do
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
