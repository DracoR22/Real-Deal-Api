defmodule RealDealApi.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comment" do
    field :text, :string

    belongs_to :account, RealDealApi.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :account_id])
    |> validate_required([:text, :account_id])
  end
end
