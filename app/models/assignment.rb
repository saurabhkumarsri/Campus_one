class Assignment < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  belongs_to :classroom
  belongs_to :subject
  has_many :assignment_questions, dependent: :destroy
  has_many :homework_submissions, dependent: :nullify

  enum :status, { draft: "draft", published: "published", closed: "closed" }

  validates :title, presence: true
  validates :due_date, presence: true
  validates :max_marks, numericality: { greater_than_or_equal_to: 0 }
end
