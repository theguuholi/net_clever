defmodule NetClever.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :name, :description, :lat, :lng]}
  schema "stores" do
    field :description, :string
    field :lat, :float
    field :lng, :float
    field :name, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :description, :lat, :lng])
    |> validate_required([:name, :description, :lat, :lng])
  end
end
