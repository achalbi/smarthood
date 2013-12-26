class CreateTicketActions < ActiveRecord::Migration
  def change
    create_table :ticket_actions do |t|
      t.string :description

      t.timestamps
    end
  end
end
