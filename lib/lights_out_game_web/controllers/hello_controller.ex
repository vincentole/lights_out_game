defmodule LightsOutGameWeb.HelloController do
  use LightsOutGameWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
