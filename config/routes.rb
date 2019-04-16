Rails.application.routes.draw do
  
  root 'links#index'
  

  resources :links, except: :index do
      resources :comments, only: [:create, :edit, :update, :destroy]
      post :upvote, on: :member
      post :downvote, on: :member
    end
    
    get '/newest' => 'links#newest'
    
   get '/comments' => 'comments#index'
    
   resources :users, only: [:new, :create]
   
   resources :sessions, only: [:new, :create] do
     delete :destroy, on: :collection
   end
  
end
