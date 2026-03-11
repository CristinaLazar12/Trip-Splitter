class Trip < ApplicationRecord
  validates :name, presence: true
  belongs_to :creator, class_name: "User", foreign_key: :creator_id #Fiecare Trip apartine unui creator, iar acel creator este un User. Legatura se face prin creator_id.

  has_and_belongs_to_many :users 
  has_many :expenses, dependent: :destroy
end
