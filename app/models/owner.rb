class Owner < ApplicationRecord
  belongs_to :type
  has_many :repositories
end
