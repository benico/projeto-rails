class ProductsController < ApplicationController
    skip_before_action :verify_authenticity_token
 
    def index
        authenticated = UserAuthenticated.last
        if authenticated.id_user_authenticated.nil?
            redirect_to "/", notice: "Usuário sem permissão."
        else
            user = User.find(authenticated.id_user_authenticated)
            if !user.admin
                redirect_to "/", notice: "Usuário sem permissão."
            else
                @products = Product.all
                @id_admin = user.id
            end
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