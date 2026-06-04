module SchoolAdmin
  class BookIssuesController < BaseController
    include SchoolScope

    def index
      @issues = scope_query(BookIssue).includes(:library_book, :student, :teacher).order(created_at: :desc)
      @issues = @issues.where(status: params[:status]) if params[:status].present?
      @overdue_count = @issues.overdue.count
    end

    def show
      @issue = scope_query(BookIssue).find(params[:id])
    end

    def return_book
      @issue = scope_query(BookIssue).find(params[:id])
      @issue.return!
      redirect_to school_admin_book_issues_path, notice: "Book returned successfully."
    end
  end
end
