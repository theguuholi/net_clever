defmodule NetClever.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :image_url, :string
      add :store_id, references(:stores, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:photos, [:store_id])
  end
end
