defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    # Confirm The Relation
    has_one :user, RealDealApi.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    # All Schema Fields
    |> cast(attrs, [:email, :hash_password])
    # Required Fields
    |> validate_required([:email, :hash_password])
    # Validate Email
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end
end
