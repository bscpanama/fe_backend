class AddPlanToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :plan_id, :integer
  end
end
