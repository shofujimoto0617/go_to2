class AddStartDateToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :start_date, :date
  end
end
