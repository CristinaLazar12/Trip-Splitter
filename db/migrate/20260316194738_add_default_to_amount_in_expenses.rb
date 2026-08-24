class AddDefaultToAmountInExpenses < ActiveRecord::Migration[8.0]
  def change
    change_column_default :expenses, :amount, 0
  end
end
