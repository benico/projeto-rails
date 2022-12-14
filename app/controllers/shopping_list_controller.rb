class ShoppingListController < ApplicationController
    skip_before_action :verify_authenticity_token
    def new
        @products = Product.all
        user = UserAuthenticated.last
        id_user = user.id_user_authenticated
        @user = User.find(id_user)
        lists = @user.shopping_lists
    end

    def create
        user = UserAuthenticated.last
        id_user = user.id_user_authenticated
        id_list = params[:id_list]
        #SEPARAR O ID DOS PRODUTOS QUE VEM POR PARAMS.
        i = 0
        j = 0
        params_field = []
        params_value = []
        params.each do |field, value|
            if (i>0) and (field != "controller") and (field != "action")
                params_value[j] = value
                j = j + 1
            end
            i = i + 1
        end
        
        #VERIFICA SE JA EXISTI ALGUMA LISTA CADASTRADA COM O VALOR DO ID_LIST
        check_list = ShoppingList.find_by(id: id_list)
        
        if j == 0
            redirect_to "/shopping_list/new", notice: "Nenhum produto selecionado."
        elsif id_list == ""
            redirect_to "/shopping_list/new", notice: "Preencha o campo 'Número da lista:'."
        elsif id_user == ""
            redirect_to "/shopping_list/new", notice: "Preencha o campo 'ID usuário:'."
        elsif !check_list.nil? 
            redirect_to "/shopping_list/new", notice: "O número da lista ja está sendo utilizado."
        else
            ShoppingList.create(id: id_list,user_id: id_user)
            params_value.each do |row|
                ListProduct.create(shopping_list_id: id_list,product_id: row)
            end
            redirect_to "/user/#{id_user}/shopping_list", notice: "Cadastro de lista realizado com sucesso."
        end
    end

    def destroy
        id_list = params[:id]
        list = ShoppingList.find_by(id: id_list)
        if list.nil?
            redirect_to "/user/#{list.user_id}/shopping_list", notice: "Lista não cadastrada."
        else
            ShoppingList.destroy_by(id: id_list)
            ListProduct.destroy_by(shopping_list_id: id_list)

            redirect_to "/user/#{list.user_id}/shopping_list", notice: "Lista excluida com sucesso."
        end 
    end
end