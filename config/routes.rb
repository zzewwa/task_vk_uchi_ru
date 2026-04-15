Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  post "students", to: "reg#create"
  delete "students/:user_id", to: "students#destroy"

  post "session", to: "sessions#create"
  delete "session", to: "sessions#destroy"

  get "schools/:school_id/classes", to: "classes#index"
  get "schools/:school_id/classes/:class_id/students", to: "students#index"
end
