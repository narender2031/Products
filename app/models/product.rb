class Product < ApplicationRecord
    has_many :product_images
    belongs_to :user
    
    def images
     @product_image = ProductImage.where(product_id: self.id).try(:last) 
    end

    private
    
end
