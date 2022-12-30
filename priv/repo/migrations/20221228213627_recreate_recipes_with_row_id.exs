defmodule RecipeBook.Repo.Migrations.RecreateRecipesWithRowId do
  use Ecto.Migration

  @content_table_name "recipes"
  @index_table_name "recipes_fts5"

  def change do
    drop table("recipes")

    create table(@content_table_name) do
      add :name, :text, null: false
      add :ingredients, :text, null: false, default: ""
      add :photo_url, :text, null: false
      add :id, :text_uuid, null: false

      timestamps()
    end

    create unique_index(@content_table_name, [:id])

    execute(
      "CREATE VIRTUAL TABLE #{@index_table_name} USING fts5(recipes_name_fts5, recipes_ingredients_fts5, content=#{@content_table_name}, tokenize=trigram)",
      "DROP TABLE #{@index_table_name}"
    )

    execute(create_trigger(:insert), drop_trigger(:insert))
    execute(create_trigger(:update), drop_trigger(:update))
    execute(create_trigger(:delete), drop_trigger(:delete))
  end

  defp create_trigger(operation) do
    trigger_name = get_trigger_name(operation)

    case operation do
      :update ->
        ~s"""
          CREATE TRIGGER #{trigger_name} AFTER UPDATE ON #{@content_table_name} BEGIN
            #{delete_index_row()}
            #{insert_index_row()}
          END
        """

      :delete ->
        ~s"""
          CREATE TRIGGER #{trigger_name} AFTER DELETE ON #{@content_table_name} BEGIN
            #{delete_index_row()}
          END
        """

      :insert ->
        ~s"""
          CREATE TRIGGER #{trigger_name} AFTER INSERT ON #{@content_table_name} BEGIN
            #{insert_index_row()}
          END
        """
    end
  end

  defp drop_trigger(operation), do: "DROP TRIGGER #{get_trigger_name(operation)}"

  defp get_trigger_name(operation),
    do: "#{@content_table_name}_#{operation}_replicate_in_#{@index_table_name}"

  defp delete_index_row,
    do: ~s"""
      INSERT INTO #{@index_table_name}(#{@index_table_name}, rowid, recipes_name_fts5, recipes_ingredients_fts5)
      VALUES('delete', old.rowid, old.name, old.ingredients);
    """

  defp insert_index_row,
    do: ~s"""
      INSERT INTO #{@index_table_name}(rowid, recipes_name_fts5, recipes_ingredients_fts5)
      VALUES(new.rowid, new.name, new.ingredients);
    """
end
