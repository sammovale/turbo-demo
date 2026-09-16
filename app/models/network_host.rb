class NetworkHost < ApplicationRecord
  include Addressable, Broadcastable, Filterable, Sortable

  STATUSES = %w[ active planned maintenance retired ].freeze
  DEVICE_TYPES = %w[ firewall router server switch wireless ].freeze

  filters_by :status, :location, :device_type
  searches_by :hostname, :design_name, :ip_address, :mac_address, :vendor, :hardware_model
  sorts_by :hostname, :design_name, :ip_address, :location, :device_type, :status, :updated_at,
    default: :hostname

  before_validation :normalize_hostname

  validates :hostname, presence: true, uniqueness: { case_sensitive: false }
  validates :design_name, :location, :device_type, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :vlan_id, numericality: { only_integer: true, in: 1..4094, allow_nil: true }

  private
    def normalize_hostname
      self.hostname = hostname.to_s.strip.downcase
    end
end
