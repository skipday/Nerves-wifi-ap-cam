defmodule NervesWifiApCam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesWifiApCam.Supervisor]

    ap_config =
      %{
        dhcpd: %{
          end: {192, 168, 0, 254},
          max_leases: 235,
          options: %{
            dns: [{192, 168, 0, 1}],
            domain: "nerves.local",
            router: [{192, 168, 0, 1}],
            search: ["nerves.local"],
            subnet: {255, 255, 255, 0}
          },
          start: {192, 168, 0, 20}
        },
        dnsd: %{records: [{"nerves.local", {192, 168, 0, 1}}]},
        ipv4: %{address: {192, 168, 0, 1}, method: :static, prefix_length: 24},
        type: VintageNetWiFi,
        vintage_net_wifi: %{
          networks: [%{key_mgmt: :wpa_psk, psk: "ex.vnet.wifi", mode: :ap, ssid: "v_net"}]
        }
      }

    VintageNet.configure("wlan0", ap_config)

    children =
      [
        # Children for all targets
        # Starts a worker by calling: NervesWifiApCam.Worker.start_link(arg)
        # {NervesWifiApCam.Worker, arg},
        Plug.Cowboy.child_spec(scheme: :http, plug: NervesWifiApCam.Router, options: [port: 4001])
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: NervesWifiApCam.Worker.start_link(arg)
      # {NervesWifiApCam.Worker, arg},
      Picam.FakeCamera
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: NervesWifiApCam.Worker.start_link(arg)
      # {NervesWifiApCam.Worker, arg},
      Picam.Camera
    ]
  end

  def target() do
    Application.get_env(:nerves_wifi_ap_cam, :target)
  end
end
