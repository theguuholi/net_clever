defmodule NetClever.Stores.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  import Waffle.Ecto.Schema


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "photos" do
    field :image_url, NetClever.Uploaders.FileUploader.Type
    field :store_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:store_id])
    |> cast_attachments(attrs, [:image_url])
    |> validate_required([:store_id])
  end
end
