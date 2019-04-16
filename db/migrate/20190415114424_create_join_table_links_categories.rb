class CreateJoinTableLinksCategories < ActiveRecord::Migration[5.2]
  def change
    create_join_table :links, :categories do |t|
          t.index [:category_id, :category_id]
          t.index [:link_id, :link_id]
    end
  end
end
