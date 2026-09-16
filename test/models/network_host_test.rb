require "test_helper"

class NetworkHostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "normalizes host and MAC addresses" do
    host = NetworkHost.new(valid_attributes(hostname: " EDGE-SW-02 ", mac_address: "AA:BB:CC:DD:EE:FF"))

    assert host.valid?
    assert_equal "edge-sw-02", host.hostname
    assert_equal "aa:bb:cc:dd:ee:ff", host.mac_address
  end

  test "rejects invalid network addressing" do
    host = NetworkHost.new(valid_attributes(ip_address: "not-an-address", mac_address: "invalid"))

    assert_not host.valid?
    assert_includes host.errors[:ip_address], "is not a valid IPv4 or IPv6 address"
    assert host.errors[:mac_address].any?
  end

  test "filters by configured fields and a text query" do
    assert_equal [ network_hosts(:edge) ], NetworkHost.filtered_by(status: "active", query: "Palo").to_a
  end

  test "ignores unconfigured filters and sort columns" do
    assert_equal 2, NetworkHost.filtered_by(notes: "Branch rollout").count
    assert_equal "branch-rtr-01", NetworkHost.sorted_by(sort: "notes", direction: "drop table").first.hostname
  end

  test "filters and sorts an existing query" do
    base_query = NetworkHost.where.not(status: "planned")

    query = base_query.filtered_by(location: "New York HQ")
    query = query.sorted_by(sort: "hostname", direction: "desc")

    assert_equal [ network_hosts(:edge) ], query.to_a
  end

  test "broadcasts refreshes to the host and inventory streams" do
    assert_enqueued_jobs 2, only: Turbo::Streams::BroadcastStreamJob do
      network_hosts(:edge).update!(design_name: "Updated elsewhere")
    end
  end

  private
    def valid_attributes(overrides = {})
      {
        hostname: "hq-sw-02",
        design_name: "HQ access switch",
        ip_address: "10.20.1.2",
        location: "New York HQ",
        device_type: "switch",
        status: "active"
      }.merge(overrides)
    end
end
