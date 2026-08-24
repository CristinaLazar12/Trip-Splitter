class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :title, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.datetime :date, null: false
      t.string :split_type, null: false

      t.timestamps
    end
  end
end


