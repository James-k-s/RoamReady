class AddOpenaiResponseToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :openai_response, :text
  end
end
