class ClassroomSubject < ApplicationRecord
  belongs_to :classroom
  belongs_to :subject
  belongs_to :teacher, optional: true

  validates :classroom_id, uniqueness: { scope: :subject_id }
end
