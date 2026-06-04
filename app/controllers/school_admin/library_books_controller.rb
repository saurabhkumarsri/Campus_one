module SchoolAdmin
  class LibraryBooksController < BaseController
    include SchoolScope

    def index
      @books = scope_query(LibraryBook).order(:title)
      @books = @books.search(params[:q]) if params[:q].present?
      @books = @books.where(category: params[:category]) if params[:category].present?
    end

    def show
      @book = scope_query(LibraryBook).find(params[:id])
      @issues = @book.book_issues.includes(:student, :teacher).order(created_at: :desc).limit(20)
    end

    def new
      @book = LibraryBook.new
    end

    def create
      @book = scope_query(LibraryBook).new(book_params)
      if @book.save
        redirect_to school_admin_library_books_path, notice: "Book added to library."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @book = scope_query(LibraryBook).find(params[:id])
    end

    def update
      @book = scope_query(LibraryBook).find(params[:id])
      if @book.update(book_params)
        redirect_to school_admin_library_book_path(@book), notice: "Book updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @book = scope_query(LibraryBook).find(params[:id])
      @book.destroy
      redirect_to school_admin_library_books_path, notice: "Book removed."
    end

    def issue
      @book = scope_query(LibraryBook).find(params[:id])
      if params[:student_id].present?
        student = scope_query(Student).find(params[:student_id])
        @book.issue_to!(student: student)
      elsif params[:teacher_id].present?
        teacher = scope_query(Teacher).find(params[:teacher_id])
        @book.issue_to!(teacher: teacher)
      end
      redirect_to school_admin_library_book_path(@book), notice: "Book issued."
    rescue StandardError => e
      redirect_to school_admin_library_book_path(@book), alert: e.message
    end

    private

    def book_params
      params.require(:library_book).permit(:title, :author, :isbn, :publisher, :category, :total_copies, :shelf_location, :barcode)
    end
  end
end
