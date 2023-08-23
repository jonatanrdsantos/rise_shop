defmodule RiseShop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RiseShopWeb.Telemetry,
      # Start the Ecto repository
      RiseShop.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: RiseShop.PubSub},
      # Start Finch
      {Finch, name: RiseShop.Finch},
      # Start the Endpoint (http/https)
      RiseShopWeb.Endpoint
      # Start a worker by calling: RiseShop.Worker.start_link(arg)
      # {RiseShop.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RiseShop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RiseShopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
