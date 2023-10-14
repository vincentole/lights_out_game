defmodule LightsOutGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LightsOutGameWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:lights_out_game, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LightsOutGame.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LightsOutGame.Finch},
      # Start a worker by calling: LightsOutGame.Worker.start_link(arg)
      # {LightsOutGame.Worker, arg},
      # Start to serve requests, typically the last entry
      LightsOutGameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LightsOutGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LightsOutGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
