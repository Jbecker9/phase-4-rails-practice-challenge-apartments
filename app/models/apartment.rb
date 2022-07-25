class Apartment < ApplicationRecord
    has_many :leases, dependent: :destroy
    has_many :tenants, through: :leases

    validates :number, presence: true
end
