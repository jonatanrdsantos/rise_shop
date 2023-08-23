defmodule RiseShopWeb.Router do
  use RiseShopWeb, :router

  import RiseShopWeb.CustomerAuth

  import RiseShopWeb.AdminAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RiseShopWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_customer
    plug :fetch_current_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RiseShopWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", RiseShopWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rise_shop, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RiseShopWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RiseShopWeb do
    pipe_through [:browser, :redirect_if_admin_is_authenticated]

    live_session :redirect_if_admin_is_authenticated,
      on_mount: [{RiseShopWeb.AdminAuth, :redirect_if_admin_is_authenticated}] do
      live "/admins/register", AdminRegistrationLive, :new
      live "/admins/log_in", AdminLoginLive, :new
      live "/admins/reset_password", AdminForgotPasswordLive, :new
      live "/admins/reset_password/:token", AdminResetPasswordLive, :edit
    end

    post "/admins/log_in", AdminSessionController, :create
  end

  scope "/", RiseShopWeb do
    pipe_through [:browser, :require_authenticated_admin]

    live_session :require_authenticated_admin,
      on_mount: [{RiseShopWeb.AdminAuth, :ensure_authenticated}] do
      live "/admins/settings", AdminSettingsLive, :edit
      live "/admins/settings/confirm_email/:token", AdminSettingsLive, :confirm_email
    end
  end

  scope "/", RiseShopWeb do
    pipe_through [:browser]

    delete "/admins/log_out", AdminSessionController, :delete

    live_session :current_admin,
      on_mount: [{RiseShopWeb.AdminAuth, :mount_current_admin}] do
      live "/admins/confirm/:token", AdminConfirmationLive, :edit
      live "/admins/confirm", AdminConfirmationInstructionsLive, :new
    end
  end

  ## Authentication routes

  scope "/", RiseShopWeb do
    pipe_through [:browser, :redirect_if_customer_is_authenticated]

    live_session :redirect_if_customer_is_authenticated,
      on_mount: [{RiseShopWeb.CustomerAuth, :redirect_if_customer_is_authenticated}] do
      live "/customers/register", CustomerRegistrationLive, :new
      live "/customers/log_in", CustomerLoginLive, :new
      live "/customers/reset_password", CustomerForgotPasswordLive, :new
      live "/customers/reset_password/:token", CustomerResetPasswordLive, :edit
    end

    post "/customers/log_in", CustomerSessionController, :create
  end

  scope "/", RiseShopWeb do
    pipe_through [:browser, :require_authenticated_customer]

    live_session :require_authenticated_customer,
      on_mount: [{RiseShopWeb.CustomerAuth, :ensure_authenticated}] do
      live "/customers/settings", CustomerSettingsLive, :edit
      live "/customers/settings/confirm_email/:token", CustomerSettingsLive, :confirm_email
    end
  end

  scope "/", RiseShopWeb do
    pipe_through [:browser]

    delete "/customers/log_out", CustomerSessionController, :delete

    live_session :current_customer,
      on_mount: [{RiseShopWeb.CustomerAuth, :mount_current_customer}] do
      live "/customers/confirm/:token", CustomerConfirmationLive, :edit
      live "/customers/confirm", CustomerConfirmationInstructionsLive, :new
    end
  end
end
