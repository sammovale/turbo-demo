# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_13_224816) do
  create_table "network_hosts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "design_name", null: false
    t.string "device_type", null: false
    t.string "hardware_model"
    t.string "hostname", null: false
    t.string "ip_address", null: false
    t.string "location", null: false
    t.string "mac_address"
    t.text "notes"
    t.string "operating_system"
    t.string "status", default: "planned", null: false
    t.datetime "updated_at", null: false
    t.string "vendor"
    t.integer "vlan_id"
    t.index ["device_type"], name: "index_network_hosts_on_device_type"
    t.index ["hostname"], name: "index_network_hosts_on_hostname", unique: true
    t.index ["ip_address"], name: "index_network_hosts_on_ip_address", unique: true
    t.index ["location"], name: "index_network_hosts_on_location"
    t.index ["status"], name: "index_network_hosts_on_status"
    t.check_constraint "status IN ('active', 'planned', 'maintenance', 'retired')", name: "network_hosts_status"
    t.check_constraint "vlan_id IS NULL OR vlan_id BETWEEN 1 AND 4094", name: "network_hosts_vlan_id"
  end
end
