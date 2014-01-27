FreePbx::Engine.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: McpCommon::ApiConstraints.new(version: 1, default: true) do
      resources :test_calls, only: [:index, :create]
    end
  end

  get 'cdrs' => 'cdrs#index'

  # To assist ransack
  get 'asterisk_cdrs' => 'cdrs#index'

  root :to => 'cdrs#index'

end
