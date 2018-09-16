class Repository < ApplicationRecord
  belongs_to :owner, required: false
  belongs_to :language, required: false
end
