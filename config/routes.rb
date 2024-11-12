Rails.application.routes.draw do
  # Routen für Benutzerverwaltung
  resources :users, only: [:new, :index, :edit, :update, :destroy]
  devise_for :users

  # Startseite
  root 'posts#index'

  # Post-Ressourcen
  resources :posts do
    collection do
      get :unapproved       # Für ungeprüfte Beiträge
    end
    member do
      patch :approve        # Genehmigen eines Beitrags
      delete :reject        # Ablehnen eines Beitrags
    end

    # Verschachtelte Ressourcen für Kommentare
    resources :comments, only: [:create, :destroy, :update, :edit]
  end

  # Abmeldung über devise
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
