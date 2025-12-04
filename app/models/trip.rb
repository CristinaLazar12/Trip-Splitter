class Trip < ApplicationRecord
  validates :name, presence: true
  belongs_to :owner

  has_and_belongs_to_many :users
end
