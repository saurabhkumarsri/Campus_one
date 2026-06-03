module SchoolAdmin
  class FeeCollectionsController < BaseController
    def index
      @fee_collections = FeeCollection.joins(:student)
                                      .where(students: { school_id: current_user.school_id })
                                      .includes(:student, :fee_structure)
                                      .order(created_at: :desc)
    end

    def show
      @fee_collection = FeeCollection.joins(:student)
                                     .where(students: { school_id: current_user.school_id })
                                     .find(params[:id])
    end

    def new
      @fee_collection = FeeCollection.new
      @students = scope_query(Student).active.order(:name)
      @fee_structures = scope_query(FeeStructure).active.order(:name)
    end

    def create
      @fee_collection = FeeCollection.new(fee_collection_params)
      if @fee_collection.save
        redirect_to receipt_school_admin_fee_collection_path(@fee_collection), notice: "Fee collected successfully."
      else
        @students = scope_query(Student).active.order(:name)
        @fee_structures = scope_query(FeeStructure).active.order(:name)
        render :new, status: :unprocessable_entity
      end
    end

    def due_fees
      @students = scope_query(Student).active.includes(:fee_collections).order(:name)
      @due_collections = FeeCollection.joins(:student)
                                    .where(students: { school_id: current_user.school_id }, status: ["unpaid", "partial"])
                                    .includes(:student, :fee_structure)
                                    .order(:due_date)
    end

    def receipt
      @fee_collection = FeeCollection.joins(:student)
                                     .where(students: { school_id: current_user.school_id })
                                     .find(params[:id])
      respond_to do |format|
        format.html
        format.pdf do
          pdf = FeeReceiptPdf.new(@fee_collection)
          send_data pdf.render, filename: "receipt_#{@fee_collection.receipt_no}.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end

    private

    def fee_collection_params
      params.require(:fee_collection).permit(:student_id, :fee_structure_id, :amount, :paid_date, :due_date, :status, :payment_mode)
    end
  end
end
