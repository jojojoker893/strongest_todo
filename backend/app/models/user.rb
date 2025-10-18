class User < ApplicationRecord
  has_many :task, dependent: :destroy
  has_many :completed_tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}

  has_secure_password
end
