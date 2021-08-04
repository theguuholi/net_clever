defmodule NetClever.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :lat, :float
      add :lng, :float
      add :phone, :string
      add :photos_url, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:stores, [:user_id])
  end
end
