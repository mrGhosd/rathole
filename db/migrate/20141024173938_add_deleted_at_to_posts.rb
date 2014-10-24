class AddDeletedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :deleted_at, :timestamp
    add_index :posts, :deleted_at
  end
end
