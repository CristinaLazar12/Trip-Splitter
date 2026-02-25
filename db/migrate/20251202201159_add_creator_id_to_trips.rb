class AddCreatorIdToTrips < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :trips, :users #aveam inainte foreign_key:FOREIGN KEY (user_id) REFERENCES users(id); ca sa redenumesc coloana user_id in creator_id, trebuie sters foreign_keyul de pe user_id; practic am redenumit o coloana (users_id) cu foreign_key activ, asa ca daca vreau sa redenumesc coloana, trebuie sters foreign_keyul

    rename_column :trips, :user_id, :creator_id #am redenumit coloana coloana user_id in creator_id

    add_foreign_key :trips, :users, column: :creator_id #prin acest foreign_key legam trips.creator_id de users.id
                                                        #creator_id devine cheia externa (foreign key)
                                                        #orice valoare din creator_id trebuie sa corespunda unui id din tabela users
    change_column_null :trips, :creator_id, false #in tabela trips, vreau ca valoarea coloanei creator_id sa nu aiba valoarea NULL
  end
end
