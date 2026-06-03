module SchoolScope
  extend ActiveSupport::Concern

  included do
    before_action :set_current_school
    helper_method :scope_query
  end

  def set_current_school
    if current_user&.school_admin?
      @current_school = current_user.school
    end
  end

  def scope_query(relation)
    if current_user&.school_admin? && @current_school
      relation.where(school_id: @current_school.id)
    else
      relation
    end
  end
end
