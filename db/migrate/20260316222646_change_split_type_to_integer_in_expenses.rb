class ChangeSplitTypeToIntegerInExpenses < ActiveRecord::Migration[8.0]
  def change
    remove_column :expenses, :split_type
    add_column    :expenses, :split_type, :integer, default: 0, null: false
  end
end