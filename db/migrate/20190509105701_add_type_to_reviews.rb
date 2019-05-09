class AddTypeToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :type, :string
  end
end
