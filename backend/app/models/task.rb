class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :category, presence: true
  enum :status, { incomplete: 0, completed: 1}
  enum :visibility, { private_task: 0, public_task: 1}
  scope :open, -> { where(:visibility => public_task)}
end
