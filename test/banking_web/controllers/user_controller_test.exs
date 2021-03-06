defmodule BankingWeb.UserControllerTest do
  use BankingWeb.ConnCase

  alias Banking.UserService

  @create_attrs %{name: "Teste", email: "teste@teste.com", password: "teste"}
  @invalid_attrs %{name: nil, email: nil, password: nil}

  def fixture(_) do
    {:ok, user} = UserService.create(@create_attrs)
    {:ok, user: user}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /users - index" do
    setup [:fixture]

    test "renders lists all users", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200) == [
        %{
          "id" => user.id,
          "name" => user.name,
          "email" => user.email
        }
      ]
    end
  end

  describe "GET /users/{id} - show" do
    setup [:fixture]

    test "renders user detail", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show, user.id))
      assert json_response(conn, 200) == %{
        "id" => user.id,
        "name" => user.name,
        "email" => user.email
      }
    end
  end

  describe "POST /users - create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @create_attrs)
      assert %{"email" => email} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

end
