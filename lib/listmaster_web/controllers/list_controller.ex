defmodule ListmasterWeb.ListController do
  use ListmasterWeb, :controller

  def index(conn, %{"id" => id}) do
    if Listmaster.ListIdMapServer.get_list_pid(:list_map, id) == nil do
      Listmaster.ListIdMapServer.add_list_pid_link(:list_map, id)
      render(conn, "index.html", list_id: id, tasks: [])
    else
      tasks =
        Listmaster.ListIdMapServer.get_list_pid(:list_map, id) |> Listmaster.ListServer.all()

      render(conn, "index.html", list_id: id, tasks: tasks)
    end
  end

  def create(conn, %{"list_id" => list_id, "item" => item}) do
    if Listmaster.ListIdMapServer.get_list_pid(:list_map, list_id) == nil do
      Listmaster.ListIdMapServer.add_list_pid_link(:list_map, list_id)
    end

    pid = Listmaster.ListIdMapServer.get_list_pid(:list_map, list_id)
    Listmaster.ListServer.add(pid, item)

    redirect(conn, to: Routes.list_path(conn, :index, list_id))
    # render(conn, "index.html", list_id: list_id, tasks: Listmaster.ListServer.all(pid))
  end
end
