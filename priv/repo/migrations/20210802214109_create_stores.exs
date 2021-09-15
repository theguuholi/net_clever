defmodule NetClever.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create_query =
      "CREATE TYPE category_types AS ENUM ('comercio', 'alimenticio', 'acougue', 'vestuario', 'marketing', 'estetica')"

    drop_query = "DROP TYPE category_types"

    execute(create_query, drop_query)

    create table(:stores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :lat, :float, default: -22.734029485683514
      add :lng, :float, default: -47.33476458089478
      add :category, :category_types, default: "comercio"
      add :active, :boolean, default: false
      add :phone, :string

      add :photos_url, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:stores, [:user_id])
  end
end
