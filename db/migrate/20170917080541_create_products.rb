class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :walmart_id, null: false
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end

    add_index :products, :walmart_id, unique: true
  end
end
