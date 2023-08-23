defmodule RiseShop.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RiseShop.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: :enabled,
        description: "some description",
        image: "some image",
        price: 42,
        sku: "some sku",
        quantity: 42
      })
      |> RiseShop.Catalog.create_product()

    product
  end
end
