class AddAboutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :about, :text
    add_column :users, :about_html, :text
  end
end
