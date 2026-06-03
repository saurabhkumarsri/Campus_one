Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  namespace :super_admin do
    root "dashboard#index"
    resources :schools
    resources :subscription_plans
    resources :school_admins
    resources :reports, only: [:index]
  end

  namespace :school_admin do
    root "dashboard#index"
    resources :subscriptions, only: [:index, :create]
    resources :classrooms
    resources :sections
    resources :subjects
    resources :subject_assignments, only: [:index, :new, :create, :destroy]
    resources :teachers
    resources :students do
      member do
        get :id_card
        get :download_id_card
      end
    end
    resources :student_attendances, only: [:index, :new, :create] do
      collection do
        get :monthly_report
      end
    end
    resources :teacher_attendances, only: [:index, :new, :create] do
      collection do
        get :monthly_report
      end
    end
    resources :fee_structures
    resources :fee_collections, only: [:index, :new, :create, :show] do
      collection do
        get :due_fees
      end
      member do
        get :receipt
      end
    end
  end
end
