class Owner < ApplicationRecord
  belongs_to :type, required: false
  has_many :repositories
end
