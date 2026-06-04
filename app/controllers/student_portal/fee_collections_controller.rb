module StudentPortal
  class FeeCollectionsController < BaseController
    def index
      @fee_collections = @student.fee_collections.includes(:fee_structure).order(created_at: :desc)
      @total_due = @student.total_due_fees
    end

    def show
      @fee_collection = @student.fee_collections.find(params[:id])
    end
  end
end
