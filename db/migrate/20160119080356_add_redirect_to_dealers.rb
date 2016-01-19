class AddRedirectToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :redirect, :string
  end
end
