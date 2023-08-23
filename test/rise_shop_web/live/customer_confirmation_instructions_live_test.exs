defmodule RiseShopWeb.CustomerConfirmationInstructionsLiveTest do
  use RiseShopWeb.ConnCase

  import Phoenix.LiveViewTest
  import RiseShop.StoreFixtures

  alias RiseShop.Store
  alias RiseShop.Repo

  setup do
    %{customer: customer_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/customers/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, customer: customer} do
      {:ok, lv, _html} = live(conn, ~p"/customers/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", customer: %{email: customer.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Store.CustomerToken, customer_id: customer.id).context == "confirm"
    end

    test "does not send confirmation token if customer is confirmed", %{conn: conn, customer: customer} do
      Repo.update!(Store.Customer.confirm_changeset(customer))

      {:ok, lv, _html} = live(conn, ~p"/customers/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", customer: %{email: customer.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Store.CustomerToken, customer_id: customer.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/customers/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", customer: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Store.CustomerToken) == []
    end
  end
end
