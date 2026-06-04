class TeacherDocument < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  has_one_attached :file

  enum :doc_type, { certificate: "certificate", training: "training", resume: "resume", other: "other" }

  validates :title, presence: true
  validates :doc_type, presence: true
end
