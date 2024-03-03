defmodule NervesWifiApCam.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    markup = ~s"""
    <!DOCTYPE html>
    <html>
    <head>
      <title>Video Feed</title>
    </head>
    <body style="margin: 0; background-color: black;">
        <div style="box-sizing: border-box; width: 100%;"></div>
        <img alt="camera feed" style="box-sizing: border-box; width: 100%; height: auto; display: inline-block;" src="video.mjpg" />
    </body>
    </html>
    """

    put_resp_content_type(conn, "text/html")
    |> send_resp(200, markup)
  end

  forward("/video.mjpg", to: NervesWifiApCam.Streamer)

  match _ do
    send_resp(conn, 404, "Oops. Try /")
  end
end
