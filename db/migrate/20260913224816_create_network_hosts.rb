class CreateNetworkHosts < ActiveRecord::Migration[8.1]
  def change
    create_table :network_hosts do |t|
      t.string :hostname, null: false
      t.string :design_name, null: false
      t.string :ip_address, null: false
      t.string :mac_address
      t.string :location, null: false
      t.string :device_type, null: false
      t.string :vendor
      t.string :hardware_model
      t.string :operating_system
      t.string :status, null: false, default: "planned"
      t.integer :vlan_id
      t.text :notes

      t.timestamps
    end

    add_index :network_hosts, :hostname, unique: true
    add_index :network_hosts, :ip_address, unique: true
    add_index :network_hosts, :status
    add_index :network_hosts, :location
    add_index :network_hosts, :device_type
    add_check_constraint :network_hosts, "status IN ('active', 'planned', 'maintenance', 'retired')",
      name: "network_hosts_status"
    add_check_constraint :network_hosts, "vlan_id IS NULL OR vlan_id BETWEEN 1 AND 4094",
      name: "network_hosts_vlan_id"
  end
end
