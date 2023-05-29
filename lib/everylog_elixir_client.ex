defmodule EverylogElixirClient do
  require Logger
  import HTTPoison
  import Poison
  use Agent

  @setup_defaults %{
    api_key: "",
    projectId: "",
    everylog_url: "https://api.everylog.io/api/v1/log-entries"
  }

  @notify_defaults %{
    title: "Empty notification",
    summary: "Empty summary",
    body: "Empty body",
    tags: [],
    link: "",
    push: false,
    icon: "",
    externalChannels: [],
    properties: %{},
    groups: []
  }

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_variable do
    Agent.get(__MODULE__, & &1)
  end

  def set_variable(value) do
    Agent.update(__MODULE__, fn state -> Map.merge(@setup_defaults, value) end)
  end

  def setup(noptions) do
    set_variable(noptions)
  end

  def notify(notoptions) do
    options = get_variable()

    if options[:api_key] != "" and options[:projectId] != "" do
      notify_options = Map.merge(@notify_defaults, notoptions)
      merged_options = Map.put(notify_options, :projectId, options[:projectId])
      headers = [
        {"Authorization", "Bearer #{options[:api_key]}"},
        {"Content-Type", "application/json"}
      ]
      body = encode!(merged_options)

      case post(options[:everylog_url], body, headers) do
        {:ok, %{status_code: 200, body: raw_body }} ->
          parsed_body = decode!(raw_body)
          {:ok, parsed_body}

        {:ok, %{status_code: 401, body: error_body}} ->
          {:error, "Unauthorized: #{error_body}"}

        {:ok, %{status_code: status_code, body: error_body}} ->
          {:error, "Request failed #{error_body}"}
      end
    else
      "API Key or ProjectId is empty"
    end
  end
end
