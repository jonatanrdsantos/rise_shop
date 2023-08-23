defmodule RiseShop.CatalogTest do
  use RiseShop.DataCase

  alias RiseShop.Catalog

  describe "catalog_products" do
    alias RiseShop.Catalog.Product

    import RiseShop.CatalogFixtures

    @invalid_attrs %{name: nil, status: nil, description: nil, image: nil, price: nil, sku: nil, quantity: nil}

    test "list_catalog_products/0 returns all catalog_products" do
      product = product_fixture()
      assert Catalog.list_catalog_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", status: :enabled, description: "some description", image: "some image", price: 42, sku: "some sku", quantity: 42}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.status == :enabled
      assert product.description == "some description"
      assert product.image == "some image"
      assert product.price == 42
      assert product.sku == "some sku"
      assert product.quantity == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name", status: :disabled, description: "some updated description", image: "some updated image", price: 43, sku: "some updated sku", quantity: 43}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.status == :disabled
      assert product.description == "some updated description"
      assert product.image == "some updated image"
      assert product.price == 43
      assert product.sku == "some updated sku"
      assert product.quantity == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
