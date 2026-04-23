class AddAmountToExpensesUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses_users, :amount, :decimal
  end
end
