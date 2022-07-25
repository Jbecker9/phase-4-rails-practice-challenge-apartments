class ApartmentsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_apartment_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_apartment_response

def index
    apartments = Apartment.all
    render json: apartments, include: :leases
end

def show
    apartment = find_apartment
    render json: apartment, include: :tenants
end

def create
    apartment = Apartment.create!(apartment_params)
    render json: apartment
end

def update
    apartment = find_apartment
    apartment.update!(apartment_params)
    render json: apartment
end

def destroy
    apartment = find_apartment
    apartment.destroy
    head :no_content
end


private

def find_apartment
    Apartment.find_by!(id: params[:id])
end

def apartment_params
    params.permit(:number)
end

def render_invalid_apartment_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
end

def render_apartment_not_found_response
    render json: { errors: "Apartment not found" }, status: :not_found
end

end
