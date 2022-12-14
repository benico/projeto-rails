class UserController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @users = User.all
        @id_admin = params[:id_admin]
        #render json: {"users": users}
    end

    def new
    end

    def create 
        user_fisrt_name = params[:first_name]
        user_last_name = params[:last_name]
        user_age = params[:age]
        user_password = params[:password]
        
        user = User.create(first_name: user_fisrt_name,last_name: user_last_name,age: user_age,password: user_password,admin: false)
        redirect_to "/", notice: "Cadastro realizado com sucesso."
        #render json: {"Mensagem": "Cadastro realizado com suscesso"} 
    end

    def show
        id_user = params[:id]
        @user = User.find_by(id: id_user)

        #render json: {"user": user}      
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        user_fisrt_name = params[:first_name]
        user_last_name = params[:last_name]
        user_age = params[:age]
        user_password = params[:password]
    
        id_user = params[:id]
        user = User.find_by(id: id_user)
        user.first_name = user_fisrt_name
        user.last_name = user_last_name
        user.age = user_age
        user.password = user_password
        user.save
        
        redirect_to "/user/#{user.id}", notice: "Atualização do usuário executada com suscesso."
        #render json: {"Mensagem": "Atualização realizada com suscesso"} 
    end

    def destroy
        id_admin = params[:id_admin]
        
        user_id = params[:id]
        user = User.find(user_id)
        lists = user.shopping_lists
        lists.each do |row|
            ShoppingList.destroy_by(id: row.id)
            ListProduct.destroy_by(shopping_list_id: row.id)
        end

        User.destroy_by(id: user_id)
        redirect_to "/user/#{id_admin}", notice: "Usuário excluido com sucesso."
    end

    def shopping_list
        @user = User.find_by(id: params[:id])
        if @user.nil?
            render json: {"Mensagem": "Usuário não cadastrado"}
        else
            @n_list = @user.shopping_lists
            
            if @n_list.nil?
                redirect_to "/user/#{@user.id}", notice: "Usuário não possui lista cadastrada."
                #render json: {"Mensagem": "Usuário não possui lista cadastrada"}
            else
                @shopping_list = @n_list.map { |row| row.products }
                #render json: {"shopping_list": @shopping_list}
            end
        end
    end

    def home
    end

    def login
        first_name = params[:first_name]
        password = params[:password]
        user = User.find_by(first_name: first_name)
        if user.nil?
            redirect_to "/", notice: "Usuário não cadastrado."
        elsif user.password != password
            redirect_to "/", notice: "Senha incorreta."
        else
            redirect_to "/user/#{user.id}" 
        end
    end
    
end
