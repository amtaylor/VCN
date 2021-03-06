Vcn::Application.routes.draw do

  
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  get "welcome/index"
  resources :investors
  resources :companies
  

  get 'companylist' => 'welcome#companylist'
  get 'investorlist' => 'welcome#investorlist'
  get 'companylistfulldata' => 'welcome#companylistfulldata'

  get 'heartbeat' => 'health#index'

  get "/FAQ", to: "static_pages#FAQ"
  get "/a-competitors-investor-is-your-enemy" , to: "static_pages#a_competitors_investor_is_your_enemy"
  get "/sf-vs-the-peninsula", to: "static_pages#SF_vs_the_peninsula"
  get "/a-warning-about-competition", to: "static_pages#a_warning_about_competition"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
