class Product < ApplicationRecord
    has_many :list_products
    has_many :shopping_lists, through: :list_products
end
