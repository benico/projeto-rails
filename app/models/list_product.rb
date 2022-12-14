class ListProduct < ApplicationRecord
    belongs_to :shopping_list
    belongs_to :product
end
