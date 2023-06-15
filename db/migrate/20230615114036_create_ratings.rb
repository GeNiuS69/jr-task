class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :value, null: false, limit: 1

      t.timestamps
    end

    add_index :ratings, [:user_id, :post_id], unique: true
  end
end
