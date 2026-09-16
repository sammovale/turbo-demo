locations = [ "New York HQ", "Austin Office", "London Office", "Singapore DC" ]
types = NetworkHost::DEVICE_TYPES
vendors = {
  "firewall" => [ "Palo Alto", "PA-440", "PAN-OS 11.1" ],
  "router" => [ "Cisco", "ISR 4331", "IOS XE 17.12" ],
  "server" => [ "Dell", "PowerEdge R660", "Ubuntu 24.04 LTS" ],
  "switch" => [ "Cisco", "Catalyst 9300", "IOS XE 17.12" ],
  "wireless" => [ "Aruba", "AP-635", "ArubaOS 10" ]
}

40.times do |index|
  number = index + 1
  device_type = types[index % types.length]
  vendor, hardware_model, operating_system = vendors.fetch(device_type)
  location = locations[index % locations.length]
  status = NetworkHost::STATUSES[index % NetworkHost::STATUSES.length]

  NetworkHost.find_or_create_by!(hostname: format("%s-%02d", device_type.first(3), number)) do |host|
    host.design_name = "#{location} #{device_type.humanize} #{number}"
    host.ip_address = "10.#{index / 254}.#{index % 254}.#{10 + index % 200}"
    host.mac_address = format("02:00:00:%02x:%02x:%02x", index / 65_536, index / 256, index % 256)
    host.location = location
    host.device_type = device_type
    host.vendor = vendor
    host.hardware_model = hardware_model
    host.operating_system = operating_system
    host.status = status
    host.vlan_id = 10 + (index % 20) * 10
    host.notes = "Demo inventory record for Turbo-powered network operations."
  end
end

puts "Seeded #{NetworkHost.count} network hosts"
