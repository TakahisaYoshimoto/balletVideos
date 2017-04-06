class BoardTag < ApplicationRecord
  belongs_to :board, required: false
end
