class AddNewAddressParamsToPeople < ActiveRecord::Migration[5.2]
  def change
      remove_column :people, :addr, :string
      add_column :people, :street, :string
      add_column :people, :city, :string
      add_column :people, :province, :string
      add_column :people, :country, :string
      add_column :people, :postal_code, :string
  end
end
