defmodule Axi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AxiWeb.Telemetry,
      Axi.Repo,
      {DNSCluster, query: Application.get_env(:axi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Axi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Axi.Finch},
      # Start a worker by calling: Axi.Worker.start_link(arg)
      # {Axi.Worker, arg},
      # Start to serve requests, typically the last entry
      AxiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Axi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AxiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
