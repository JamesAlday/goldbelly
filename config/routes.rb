Rails.application.routes.draw do
	resources :urls, param: :slug
end
