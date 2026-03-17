class AddOutfitInfoToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :worn_on, :date
    add_column :posts, :temperature, :integer
    add_column :posts, :weather, :integer, null: false, default: 0
    add_column :posts, :scene, :integer, null: false, default: 0
  end
end
