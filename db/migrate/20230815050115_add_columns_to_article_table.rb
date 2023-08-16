class AddColumnsToArticleTable < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :title, :string
    add_column :articles, :content, :string
  end
end
