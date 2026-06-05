Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#landing"
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  namespace :super_admin do
    root "dashboard#index"
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout
    resources :schools
    resources :subscription_plans
    resources :school_admins
    resources :reports, only: [:index]
  end

  # ─── TEACHER SCOPE (same controllers, /teacher URLs) ───
  scope "/teacher", module: :school_admin, as: :teacher do
    get "teacher_dashboard", to: "teacher_dashboard#index"
    get "my_classes", to: "my_classes#index"
    get "my_students", to: "my_students#index"

    resources :student_attendances, only: [:index, :new, :create] do
      collection do
        get :monthly_report
      end
    end

    resources :homeworks do
      member do
        get :submissions
        patch :review_submission
      end
    end

    resources :assignments do
      member do
        get :submissions
        patch :review_submission
      end
      resources :assignment_questions, only: [:create, :update, :destroy]
    end

    resources :exams do
      member do
        get :results
        post :publish_results
        get :report_card
        get :class_ranking
      end
      resources :exam_results, only: [:index, :new, :create, :edit, :update, :destroy]
    end

    resources :question_banks
    resources :timetables
    resources :lesson_plans
    resources :teacher_documents, only: [:index, :new, :create, :destroy]
    resources :announcements

    get "messages/inbox", to: "messages#inbox", as: :inbox
    get "messages/chat/:id", to: "messages#chat", as: :chat
    post "messages/send", to: "messages#send_message", as: :send_message

    resources :live_classes do
      member do
        get :attendance
        post :mark_attendance
      end
    end

    resources :leave_applications, only: [:index, :show, :edit, :update]

    # Analytics
    get "analytics/dashboard", to: "analytics#dashboard"
    get "analytics/attendance", to: "analytics#attendance"
    get "analytics/finance", to: "analytics#finance"
    get "analytics/academic", to: "analytics#academic"

    # AI Tools
    get "ai/report_generator", to: "ai_tools#report_generator"
    post "ai/generate_report", to: "ai_tools#generate_report"
    get "ai/question_paper", to: "ai_tools#question_paper"
    post "ai/generate_question_paper", to: "ai_tools#generate_question_paper"
    get "ai/homework_generator", to: "ai_tools#homework_generator"
    post "ai/generate_homework", to: "ai_tools#generate_homework"
  end

  namespace :school_admin do
    root "dashboard#index"
    resources :subscriptions, only: [:index, :create]
    resources :payments, only: [:index] do
      member do
        get :checkout
        post :verify
      end
    end
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

    # Exam Management
    resources :exams do
      member do
        get :results
        post :publish_results
        get :report_card
        get :class_ranking
      end
      resources :exam_results, only: [:index, :new, :create, :edit, :update, :destroy]
    end
    resources :grade_systems

    # Homework Management
    resources :homeworks do
      member do
        get :submissions
        patch :review_submission
      end
    end

    # Leave Management
    resources :leave_applications, only: [:index, :show, :edit, :update]

    # Library Management
    resources :library_books do
      member do
        post :issue
        post :return_book
      end
    end
    resources :book_issues, only: [:index, :show]

    # Transport Management
    resources :vehicles
    resources :drivers
    resources :routes do
      resources :route_stops, only: [:create, :update, :destroy]
    end

    # Hostel Management
    resources :hostel_rooms do
      resources :hostel_beds, only: [:create, :update, :destroy]
    end

    # Inventory
    resources :inventory_items

    # Communication Hub
    resources :announcements
    get "messages/inbox", to: "messages#inbox", as: :inbox
    get "messages/chat/:id", to: "messages#chat", as: :chat
    post "messages/send", to: "messages#send_message", as: :send_message

    # Live Classes
    resources :live_classes do
      member do
        get :attendance
        post :mark_attendance
      end
    end

    # LMS
    resources :courses do
      resources :chapters, only: [:create, :update, :destroy] do
        resources :topics, only: [:create, :update, :destroy] do
          resources :quizzes, only: [:create, :update, :destroy] do
            resources :quiz_questions, only: [:create, :update, :destroy]
          end
        end
      end
      resources :course_enrollments, only: [:index, :create, :destroy]
    end

    # AI Tools
    get "ai/report_generator", to: "ai_tools#report_generator"
    post "ai/generate_report", to: "ai_tools#generate_report"
    get "ai/question_paper", to: "ai_tools#question_paper"
    post "ai/generate_question_paper", to: "ai_tools#generate_question_paper"
    get "ai/homework_generator", to: "ai_tools#homework_generator"
    post "ai/generate_homework", to: "ai_tools#generate_homework"

    # Teacher-specific routes (also kept here for school-admin access)
    resources :timetables
    resources :lesson_plans
    resources :teacher_documents, only: [:index, :new, :create, :destroy]
    resources :assignments do
      member do
        get :submissions
        patch :review_submission
      end
      resources :assignment_questions, only: [:create, :update, :destroy]
    end
    resources :question_banks
    get "my_classes", to: "my_classes#index"
    get "my_students", to: "my_students#index"
    get "teacher_dashboard", to: "teacher_dashboard#index"

    # Analytics
    get "analytics/dashboard", to: "analytics#dashboard"
    get "analytics/attendance", to: "analytics#attendance"
    get "analytics/finance", to: "analytics#finance"
    get "analytics/academic", to: "analytics#academic"
  end

  # Student Portal
  namespace :student_portal do
    root "dashboard#index"
    resources :courses, only: [:index, :show] do
      member do
        get :chapters
        get :quiz
        post :submit_quiz
      end
    end
    resources :homeworks, only: [:index, :show] do
      member do
        post :submit
      end
    end
    resources :exams, only: [:index, :show]
    resources :attendances, only: [:index]
    resources :fee_collections, only: [:index, :show]
    get "ai/chatbot", to: "ai_tools#chatbot", as: :ai_chatbot
    post "ai/ask", to: "ai_tools#ask", as: :ai_ask
    get "messages/inbox", to: "messages#inbox", as: :inbox
    get "messages/chat/:id", to: "messages#chat", as: :chat
    post "messages/send", to: "messages#send_message", as: :send_message
  end
end
