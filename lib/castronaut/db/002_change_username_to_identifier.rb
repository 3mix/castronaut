class ChangeUsernameToIdentifier < ActiveRecord::Migration
  def self.up
    rename_column :service_tickets, :username, :identifier
    rename_column :ticket_granting_tickets, :username, :identifier
  end

  def self.down
    rename_column :service_tickets, :identifier, :username
    rename_column :ticket_granting_tickets, :identifier, :username
  end
end
