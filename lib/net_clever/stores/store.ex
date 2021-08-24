defmodule NetClever.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :description, :lat, :lng, :phone]
  @optional_fields [:photos_url, :active]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :name, :description, :lat, :lng]}
  schema "stores" do
    field :description, :string
    field :lat, :float
    field :lng, :float
    field :name, :string
    field :phone, :string
    field :active, :boolean, default: false
    field :photos_url, {:array, :string}
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields, message: "preencher o campo acima")
  end
end
