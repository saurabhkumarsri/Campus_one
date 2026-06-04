class Timetable < ApplicationRecord
  belongs_to :school
  belongs_to :classroom
  belongs_to :teacher
  belongs_to :subject

  enum :day_of_week, {
    monday: "monday",
    tuesday: "tuesday",
    wednesday: "wednesday",
    thursday: "thursday",
    friday: "friday",
    saturday: "saturday",
    sunday: "sunday"
  }

  validates :period, presence: true, numericality: { greater_than: 0 }
  validates :start_time, presence: true
  validates :end_time, presence: true
end
