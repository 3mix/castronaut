class AddExtraInfo < ActiveRecord::Migration
  def self.up
    add_column :ticket_granting_tickets, :extra_info, :text
    remove_column :service_tickets, :identifier
  end

  def self.down
    remove_column :ticket_granting_tickets, :extra_info
    add_column :service_tickets, :identifier, :string
  end
end
