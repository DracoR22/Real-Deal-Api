defmodule RealDealApi.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comment, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :string
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:comment, [:account_id], :text)
  end
end
