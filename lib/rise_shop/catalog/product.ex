defmodule RiseShop.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "catalog_products" do
    field :name, :string
    field :status, Ecto.Enum, values: [:enabled, :disabled]
    field :description, :string
    field :image, :string
    field :price, :integer
    field :sku, :string
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :description, :image, :sku, :quantity, :status])
    |> validate_required([:name, :price, :description, :image, :sku, :quantity, :status])
  end
end
