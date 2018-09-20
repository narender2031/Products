require 'grape-swagger'
module Products
  class Item < Grape::API
		default_format :json
		# authantication methods in helpers 
		helpers do 
			def authenticate
				token = headers['Authorization']
				User.exists?(token: token)
				if User.exists?(token: token)
					@current_user = User.find_by(token: token)
				else
					error! 'Unauthorized', 401
				end
			end
			def current_user
				@current_user
			end
		end

		# login SignUp Api's
		resources :Products do 
			desc "Create and update produts",{
			headers: {
				"Authorization" => {
				description: "Valdates your identity",
				required: true
				}
			}
			}
			params do
				requires :name, type:String, documentation: { in: 'body' }
				requires :expiry, type:String
				requires :sku_id, type:String
				requires :price, type:Float
				optional :tag, type: Array[String]
				optional :categories, type: Array[String]
				optional :images, type: Array do 
				optional :img_path, type:String
				end
			end
			post "/" do 
				authenticate
				if params[:name].blank? || params[:name] == "string"
					error!({error: "name is missing or Invalid"},400)
				end
				if params[:expiry].blank?|| params[:expiry] == "string"
					error!({error: "expiry is missing or Invalid"},400)
				else
					begin
						@expiry = Date.parse(params[:expiry])
					rescue Exception => error # Never do this!
						@error =  error.message
						error!({error: @error},400)
					end
				end
				if params[:sku_id].blank? || params[:sku_id] == "string"
					error!({error: "sku_id is missing or Invalid"},400)
				end
				if params[:price].blank?|| params[:price] == 0
					error!({error: "price is missing or Invalid"},400)
				end
				@products = current_user.products.find_by(sku_id: params[:sku_id]) || current_user.products.new
				@products.name = params[:name]
				@products.expire_date = @expiry
				@products.price = params[:price]
				@products.sku_id = params[:sku_id]
				@products.user_id = current_user.id
				@tags = params[:tag]
				if @tags.present?
					@tags.each do |tag|
						if @products.tags.include?(tag)
						else
							@products.tags.push(tag)
						end
					end
				else
					@products.tags = []
				end
				@categories = params[:categories]
				if @categories.present?
					@categories.each do |cat|
						if @products.categories.include?(cat)
						else
							@products.categories.push(cat)
						end
					end
				else
					@products.categories = []
				end
				if @products.save
					
					@images = params[:images]
					if @images.present?
						@images.each do |img|
							@product_image = @products.product_images.new
							@images  = params[:images]
							@images.each do |img|
								@product_image.img_path = img[:img_path]
								@product_image.save
							end
							({Success: "Product is save!", status: 201})
						end
					else
						({Success: "Data Saved", sttaus: 201})
					end
				else
          error!({error: "product id not saving Please Check"},401)
        end
			end
		end 
  end
end