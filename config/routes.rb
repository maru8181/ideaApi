Rails.application.routes.draw do
  root 'apis#index', defaults: { format: :json }
  get ':category_name', to: 'apis#show', defaults: { format: :json }
  get ':category_name/:body', to: 'apis#create', defaults: { format: :json }
  get '*path', to: redirect('/')
end
