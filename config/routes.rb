Rails.application.routes.draw do
  resources :items do
    member do
      get 'details'
      get 'rename'
      put 'perform_rename'
      get 'check_in'
      put 'check_in' => 'items#perform_check_in'
      get 'remove'
      put 'remove' => 'items#perform_remove'
      put 'deactivate'
    end
  end

  resources :event_logs, only: [:index, :show]

  root to: 'items#index'
end
