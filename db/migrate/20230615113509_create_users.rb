class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :login, null: false, uniq: true, index: { unique: true }

      t.timestamps
    end
  end
end
