class UserController < ApplicationController
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
                @users = User.all
                @id_admin = user.id
            end
        end
    end

    def new
        @user = User.new
    end

    def create 
        user_fisrt_name = params[:first_name]
        user_last_name = params[:last_name]
        user_age = params[:age]
        user_password = params[:password]
        user_name = User.find_by(first_name: user_fisrt_name)

        if !user_name.nil?
            redirect_to "/user/new", notice: "Usuário já cadastrado."
        elsif user_fisrt_name == ""
            redirect_to "/user/new", notice: "Preencha o campo 'Primeiro Nome:'."
        elsif user_last_name == ""
            redirect_to "/user/new", notice: "Preencha o campo 'Segundo Nome:'."
        elsif user_age == ""
            redirect_to "/user/new", notice: "Preencha o campo 'Idade:'."
        elsif user_password == ""
            redirect_to "/user/new", notice: "Digite uma senha."
        else
            user = User.create(first_name: user_fisrt_name,last_name: user_last_name,age: user_age,password: user_password,admin: false)
            redirect_to "/", notice: "Cadastro realizado com sucesso."
        end
    end

    def show
        id_user = params[:id]
        id_authenticated = id_user.to_i
        authenticated = UserAuthenticated.last
        if authenticated.id_user_authenticated != id_authenticated
            redirect_to "/", notice: "Usuário sem permissão."
        else
            @user = User.find_by(id: id_user)
        end   
    end

    def edit
        @user = User.find(params[:id])
        authenticated = UserAuthenticated.last
        if @user.id != authenticated.id_user_authenticated
            redirect_to "/", notice: "Usuário sem permissão."
        end        
    end

    def update
        user_params = params.require(:user).permit(:first_name, :last_name, :age, :password)
        user_id = params[:id]
        user_name = User.find_by(first_name: user_params[:first_name])

        if !user_name.nil? and user_name.id.to_i != user_id.to_i

            redirect_to "/user/#{user_id}/edit", notice: "Usuário já cadastrado."
        elsif user_params[:first_name] == ""
            redirect_to "/user/#{user_id}/edit", notice: "Preencha o campo 'Primeiro Nome:'."
        elsif user_params[:last_name] == ""
            redirect_to "/user/#{user_id}/edit", notice: "Preencha o campo 'Segundo Nome:'."
        elsif user_params[:age] == ""
            redirect_to "/user/#{user_id}/edit", notice: "Preencha o campo 'Idade:'."
        elsif user_params[:password] == ""
            redirect_to "/user/#{user_id}/edit", notice: "Digite uma senha."
        else
            user = User.find_by(id: user_id)
            user.first_name = user_params[:first_name]
            user.last_name = user_params[:last_name]
            user.age = user_params[:age]
            user.password = user_params[:password]
            user.save
            redirect_to "/user/#{user.id}", notice: "Atualização do usuário executada com suscesso."
        end
    end

    def destroy
        authenticated = UserAuthenticated.last
        id_admin = authenticated.id_user_authenticated
        
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
        @user = User.find(params[:id])
        authenticated = UserAuthenticated.last
        if @user.id != authenticated.id_user_authenticated
            redirect_to "/", notice: "Usuário sem permissão."
        else
            if @user.nil?
                redirect_to "/", notice: "Usuário não cadastrado."
            else
                @n_list = @user.shopping_lists
                
                if @n_list.nil?
                    redirect_to "/user/#{@user.id}", notice: "Usuário não possui lista cadastrada."
                else
                    @shopping_list = @n_list.map { |row| row.products }
                end
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
            user_authenticated = UserAuthenticated.create(id_user_authenticated: user.id)
            redirect_to "/user/#{user.id}" 
        end
    end

    def logout
        user = UserAuthenticated.last
        user.id_user_authenticated = ""
        user.save 
        redirect_to "/", notice: "Logout efetuado com suscesso."
    end
    
end
