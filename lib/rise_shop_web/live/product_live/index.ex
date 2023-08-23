defmodule RiseShopWeb.ProductLive.Index do
  use RiseShopWeb, :live_view

  alias RiseShop.Catalog
  alias RiseShop.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :catalog_products, Catalog.list_catalog_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Catalog products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({RiseShopWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :catalog_products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, stream_delete(socket, :catalog_products, product)}
  end
end
