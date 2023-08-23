defmodule RiseShop.Repo.Migrations.CreateCatalogProducts do
  use Ecto.Migration

  def change do
    create table(:catalog_products) do
      add :name, :string
      add :price, :integer
      add :description, :text
      add :image, :string
      add :sku, :string
      add :quantity, :integer
      add :status, :string

      timestamps()
    end
  end
end
