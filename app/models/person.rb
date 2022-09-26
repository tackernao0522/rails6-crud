class Person < ApplicationRecord
  validates :name, presence: {message: "Name が入力されていません"}
  validates :age, presence: {message: "Age が入力されていません"}
  validates :age, numericality: {only_integer: true, message: "数値ではありません"}

  belongs_to :student
end
