class AddTripAndPayerToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :trip_id, :bigint, null: false
    add_column :expenses, :payer_id, :bigint, null: false
  end
end
