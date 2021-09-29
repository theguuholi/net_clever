defmodule NetClever.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias NetClever.Stores.Photo

  @category_types ~w/comercio alimenticio acougue vestuario marketing estetica/a
  @required_fields [:name, :description, :phone, :category]
  @optional_fields [:active, :lat, :lng]
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
    # field :photos_url, {:array, :string}
    field :user_id, :binary_id
    field :category, Ecto.Enum, values: @category_types, default: :comercio

    has_many :photos, Photo

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> cast_assoc(:photos, with: &Photo.changeset/2)
    |> validate_required(@required_fields, message: "preencher o campo acima")
  end
end
