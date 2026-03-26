class Expense < ApplicationRecord
  belongs_to :trip
  belongs_to :payer, class_name: "User"
  enum :split_type, { equal: 0 }
  has_many :users

  validates :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :date, presence: true
  validates :split_type, presence: true
end