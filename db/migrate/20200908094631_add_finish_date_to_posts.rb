class AddFinishDateToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :finish_date, :date
  end
end
