class Expense < ApplicationRecord
  validates :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :date, presence: true

  belongs_to :trip
  has_many :participants
end