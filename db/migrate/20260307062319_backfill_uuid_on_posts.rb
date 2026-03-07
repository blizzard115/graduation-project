class BackfillUuidOnPosts < ActiveRecord::Migration[7.1]
  def up
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    execute <<~SQL
      UPDATE posts
      SET uuid = gen_random_uuid()
      WHERE uuid IS NULL OR uuid = '';
    SQL

    change_column_null :posts, :uuid, false
    add_index :posts, :uuid, unique: true unless index_exists?(:posts, :uuid)
  end

  def down
    remove_index :posts, :uuid if index_exists?(:posts, :uuid)
    change_column_null :posts, :uuid, true
  end
end