class AddPostToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :post, :boolean
  end
end
