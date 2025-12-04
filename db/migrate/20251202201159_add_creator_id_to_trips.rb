class AddCreatorIdToTrips < ActiveRecord::Migration[8.0]
  def change
    rename_column :trips, :user_id, :creator_id
    rename_index :trips, "index_trips_on_user_id", "index_trips_on_creator_id"
  end
end
