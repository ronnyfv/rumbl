defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Accounts.User


  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :username, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
      |> cast(attrs, [:name, :username])
      |> validate_required([:name, :username])
      |> unique_constraint(:username)
  end

  def registration_changeset(model, params) do
    model
      |> changeset(params)
      |> cast(params, ~w(password), [])
      |> validate_required([:password])
      |> validate_length(:password, min: 6, max: 100)
      |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
