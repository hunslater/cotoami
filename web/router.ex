defmodule Cotoami.Router do
  use Cotoami.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Cotoami.Auth
  end
  
  pipeline :api_public do
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Cotoami.Auth
  end
  
  @clientside_paths [
    "/", 
    "/cotonomas/:key"
  ]

  scope "/", Cotoami do
    pipe_through :browser # Use the default browser stack

    Enum.each(@clientside_paths, &get(&1, PageController, :index))
    get "/signin/:token/:anonymous_id", SigninController, :signin
    get "/signout", SessionController, :signout
  end
  
  scope "/api/public", Cotoami do
    pipe_through :api_public
    
    get "/", PublicController, :index
    get "/info", PublicController, :info
  end

  scope "/api", Cotoami do
    pipe_through :api
    
    get "/session", SessionController, :index
    get "/amishis/email/:email", AmishiController, :show_by_email
    resources "/cotos", CotoController, only: [:index, :create, :delete]
    resources "/cotonomas", CotonomaController, only: [:index, :create]
    get "/cotonomas/:key/cotos", CotonomaController, :cotos
    get "/signin/request/:email/:save_anonymous", SigninController, :request
  end
end
