require "ipaddr"

module NetworkHost::Addressable
  extend ActiveSupport::Concern

  MAC_ADDRESS_PATTERN = /\A(?:[0-9a-f]{2}:){5}[0-9a-f]{2}\z/i

  included do
    before_validation :normalize_network_addresses

    validates :ip_address, presence: true, uniqueness: true
    validates :mac_address, format: { with: MAC_ADDRESS_PATTERN, allow_blank: true }
    validate :ip_address_must_be_valid
  end

  private
    def normalize_network_addresses
      self.ip_address = ip_address.to_s.strip
      self.mac_address = mac_address.to_s.strip.downcase.presence
    end

    def ip_address_must_be_valid
      IPAddr.new(ip_address) if ip_address.present?
    rescue IPAddr::InvalidAddressError
      errors.add(:ip_address, "is not a valid IPv4 or IPv6 address")
    end
end
