class AddPromptToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :prompt, :string
  end
end
