class TenantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_tenant_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_tenant_response

    def index
        tenants = Tenant.all
        render json: tenants, include: :leases
    end

    def show
        tenant = find_tenant
        render json: tenant, include: :leases
    end

    def create
        tenant = Tenant.create(tenant_params)
        render json: tenant
    end

    def update
        tenant = find_tenant
        tenant.update!(tenant_params)
        render json: tenant
    end

    def destroy
        tenant = find_tenant
        tenant.destroy
        head :no_content
    end

private

    def find_tenant
        Tenant.find_by!(id: params[:id])
    end

    def tenant_params
        params.permit(:name, :age)
    end

    def render_invalid_tenant_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
    
    def render_tenant_not_found_response
        render json: { errors: "Tenant not found" }, status: :not_found
    end

end
