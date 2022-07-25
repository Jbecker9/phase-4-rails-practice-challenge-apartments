class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_lease_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_lease_response

    def index 
        leases = Lease.all
        render json: leases
    end

    def create
        lease = Lease.create!(lease_params)
        render json: lease
    end

    def destroy
        lease = Lease.find_by!(id: params[:id])
        lease.destroy
        head :no_content
    end

private

    def lease_params
        params.permit(:apartment_id, :tenant_id, :rent)
    end

    def render_invalid_lease_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
    
    def render_lease_not_found_response
        render json: { errors: "Lease not found" }, status: :not_found
    end

end
