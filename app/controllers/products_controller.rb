class ProductsController < ApplicationController
    skip_before_action :verify_authenticity_token
 
    def index
        @id_admin = params[:id_admin]
        if @id_admin.nil?
            redirect_to "/", notice: "Usuário sem permissão."
        else
            @products = Product.all
        end
    end

    def create
        id_admin = params[:id_admin]
        product_name = params[:name]
        product_value = params[:value]

        Product.create(name: product_name,value: product_value)
        redirect_to "/user/#{id_admin}", notice: "Cadastro realizado com sucesso."
    end
    
end