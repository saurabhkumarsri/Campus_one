module SchoolAdmin
  class FeeStructuresController < BaseController
    def index
      @fee_structures = scope_query(FeeStructure).includes(:classroom).order(:name)
    end

    def new
      @fee_structure = FeeStructure.new
    end

    def create
      @fee_structure = scope_query(FeeStructure).new(fee_structure_params)
      if @fee_structure.save
        redirect_to school_admin_fee_structures_path, notice: "Fee structure created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @fee_structure = scope_query(FeeStructure).find(params[:id])
    end

    def update
      @fee_structure = scope_query(FeeStructure).find(params[:id])
      if @fee_structure.update(fee_structure_params)
        redirect_to school_admin_fee_structures_path, notice: "Fee structure updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @fee_structure = scope_query(FeeStructure).find(params[:id])
      @fee_structure.destroy
      redirect_to school_admin_fee_structures_path, notice: "Fee structure deleted successfully."
    end

    private

    def fee_structure_params
      params.require(:fee_structure).permit(:name, :amount, :frequency, :classroom_id, :status).merge(school_id: current_user.school_id)
    end
  end
end
