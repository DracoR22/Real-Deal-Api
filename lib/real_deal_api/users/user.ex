defmodule RealDealApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :gender, :string
    field :biography, :string
    # This Is How We Establish Relations
    belongs_to :account, RealDealApi.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    # All Schema Fields
    |> cast(attrs, [:name, :gender, :biography])
    # Required Fields
    |> validate_required([:account_id])
  end
end
