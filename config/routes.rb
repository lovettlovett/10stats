LiveInsta::Application.routes.draw do
  root "main#index"

  get "/addhandle", to: "main#new"
  get "/showhandle", to: "main#show"
  post "/showhandle", to: "main#show"

  get "/newbattle", to: "main#newbattle"
  get "/showbattle", to: "main#showbattle"
  post "/showbattle", to: "main#showbattle"

  

end
