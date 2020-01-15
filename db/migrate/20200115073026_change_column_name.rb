class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :occupancies, :mpsh, :mpsh3
  end
end
