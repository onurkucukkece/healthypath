class CreateDealers < ActiveRecord::Migration
  def change
    create_table :dealers do |t|
      t.string :name
      t.string :path
      t.string :status

      t.timestamps null: false
    end
  end
end
