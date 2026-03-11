class Expense < ApplicationRecord
  validates :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :date, presence: true
  validates :split_type, presence: true

  belongs_to :trip
  belongs_to :payer, class_name: "User"
  
  has_many :participants
end