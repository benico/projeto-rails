class CreateUserAuthenticateds < ActiveRecord::Migration[7.0]
  def change
    create_table :user_authenticateds do |t|
      t.integer :id_user_authenticated
      
      t.timestamps
    end
  end
end
