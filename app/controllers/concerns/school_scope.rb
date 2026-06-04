module SchoolScope
  extend ActiveSupport::Concern

  included do
    before_action :set_current_school
    helper_method :scope_query
  end

  def set_current_school
    if current_user&.school_admin? || current_user&.teacher?
      @current_school = current_user.school
    end
  end

  def scope_query(relation)
    if (current_user&.school_admin? || current_user&.teacher?) && @current_school
      model = relation.respond_to?(:klass) ? relation.klass : relation
      if model.column_names.include?("school_id")
        relation.where(school_id: @current_school.id)
      else
        case model.name
        when "StudentAttendance"
          relation.joins(:student).where(students: { school_id: @current_school.id })
        when "TeacherAttendance"
          relation.joins(:teacher).where(teachers: { school_id: @current_school.id })
        when "ExamResult"
          relation.joins(:student).where(students: { school_id: @current_school.id })
        when "FeeCollection"
          relation.joins(:student).where(students: { school_id: @current_school.id })
        else
          raise ArgumentError, "Cannot scope #{model.name} by school_id: the table lacks a school_id column and no fallback join is configured in SchoolScope."
        end
      end
    else
      relation
    end
  end
end
