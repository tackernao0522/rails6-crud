Rails.application.routes.draw do
  get 'people/index'
  get 'people/add'
  post 'people/add', to: 'people#create'
  get 'people/:id', to: 'people#show'
  get 'people/edit/:id', to: 'people#edit'
  patch 'people/edit/:id', to: 'people#update'
  delete 'people/delete/:id', to: 'people#delete'
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
