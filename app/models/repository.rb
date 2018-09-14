class Repository < ApplicationRecord
  belongs_to :owner
  belongs_to :language
end
