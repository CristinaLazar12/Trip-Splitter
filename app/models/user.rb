class User < ApplicationRecord

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true

  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :created_trips, class_name: "Trip", foreign_key: :creator_id #created_trips sunt obiecte din clasa Trips; in tabela trips, legatura catre acest model se face prin coloana creator_id.
  has_and_belongs_to_many :trips #la care participa
  has_and_belongs_to_many :expenses

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
