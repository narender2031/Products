class DashboardController < ApplicationController
    before_action :authorize
    def home
        @products = current_user.products.all
    end

    def edit
        puts params
       @product =  current_user.products.find_by(id: params[:id])
    end

    def update
        require 'uri'
        require 'net/http'

        url = URI("http://localhost:3000/api/v1/Products")

        http = Net::HTTP.new(url.host, url.port)

        request = Net::HTTP::Post.new(url)
        request["authorization"] = current_user.token
        request["content-type"] = 'application/json'
        request["cache-control"] = 'no-cache'
        request["postman-token"] = '1ccd6225-ef51-99be-f935-01cf9a11333c'
        if params[:product][:categories].present?
            @categories =  params[:product][:categories].split(",")
         end
         if params[:product][:tags].present?
            @tags = params[:product][:tags].split(",")
         end
         @data_products = {name: product_params[:name], sku_id: product_params[:sku_id], expiry: product_params[:expire_date], price: product_params[:price], categories: @categories, tag: @tags  }
        request.body = @data_products.to_json
        puts @data_products.to_json
        response = http.request(request)
        if response.code == "201"
            redirect_to admin_products_path
        else
            @product = current_user.products.find_by(id: product_params[:id]) || current_user.products.new
            flash.now.alert = response.body
            render :edit
        end
    end

    def add_product
        @product = current_user.products.new
        render "dashboard/edit.html.erb"
    end

    private
    def product_params
        params.require(:product).permit(:id, :name, :price, :sku_id, :categories, :tags, :expire_date)
    end
end
