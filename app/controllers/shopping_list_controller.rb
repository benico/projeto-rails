class ShoppingListController < ApplicationController
    skip_before_action :verify_authenticity_token
    def new
        @products = Product.all
        @user = User.find(params[:id_user])
        lists = @user.shopping_lists
        
    end

    def create
        id_user = params[:id_user]
        id_list = params[:id_list]
        #PEGA O ID DOS PRODUTOS QUE VEM POR PARAMETROS
        i = 0
        j = 0
        params_field = []
        params_value = []
        params.each do |field, value|
            if (i>1) and (field != "controller") and (field != "action")
                params_field[j] = field
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
        #VERSÃO ANTIGA
        #PEQUISA NA TABELA PRODUCT PELO NOME E USUARIO PELO ID
        #name_product = params[:name_product]
        #product = Product.find_by(name: name_product)
        #id_user = params[:id_user]
        #user = User.find_by(id: id_user)
        #if product.nil?
        #    render json: {"Mensagem": "Produto não CADASTRADO"} 
        #elsif user.nil?
        #    render json: {"Mensagem": "Usuário não CADASTRADO"} 
        #else
        #    id_list = params[:id_list]
        #    list = ShoppingList.find_by(id: id_list)
        #    if list.nil?
        #        ShoppingList.create(id: id_list,user_id: user.id)
        #        ListProduct.create(shopping_list_id: id_list,product_id: product.id)
        #        render json: {"Mensagem": "Cadastro realizado com suscesso"} 
        # 
        #     elsif (list.user_id != id_user) then
        #         render json: {"Mensagem": "Número da Lista ja esta sendo utilizado por outro usuario"} 
        #     else
        #         ListProduct.create(shopping_list_id: id_list,product_id: product.id)
        #         render json: {"Mensagem": "Cadastro realizado com suscesso"} 
        #     end
        #end
    end

    def destroy
        id_list = params[:id]
        list = ShoppingList.find_by(id: id_list)
        if list.nil?
            redirect_to "/user/#{list.user_id}/shopping_list", notice: "Lista não cadastrada."
            #render json: {"Mensagem": "Lista não cadastrada"}
        else
            ShoppingList.destroy_by(id: id_list)
            ListProduct.destroy_by(shopping_list_id: id_list)

            redirect_to "/user/#{list.user_id}/shopping_list", notice: "Lista excluida com sucesso."
            #render json: {"Mensagem": "Lista excluida com suscesso"}
        end 
    end
end