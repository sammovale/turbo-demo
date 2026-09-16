require "test_helper"

class NetworkHosts::BulkUpdatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @network_hosts = [ network_hosts(:edge), network_hosts(:branch) ]
  end

  test "updates selected hosts and replaces each row with Turbo Streams" do
    patch bulk_update_url,
      params: { bulk_update: { ids: @network_hosts.map(&:id), status: "retired" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal [ "retired", "retired" ], @network_hosts.map { |network_host| network_host.reload.status }

    @network_hosts.each do |network_host|
      assert_select "turbo-stream[action='replace'][target='network_host_#{network_host.id}']", 1 do
        assert_select "tr#network_host_#{network_host.id}.network-host-row--updated", 1
        assert_select ".status-badge--retired", text: "Retired"
      end
    end

    assert_select "turbo-stream[action='prepend'][target='toasts'] .toast", text: /2 network hosts updated/
  end

  test "redirects after an HTML bulk update" do
    patch bulk_update_url,
      params: { bulk_update: { ids: [ @network_hosts.first.id ], status: "maintenance" } }

    assert_redirected_to network_hosts_url
    assert_equal "maintenance", @network_hosts.first.reload.status
  end

  test "rejects an empty selection" do
    patch bulk_update_url,
      params: { bulk_update: { ids: [], status: "active" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :unprocessable_content
    assert_select "turbo-stream[action='prepend'][target='toasts'] .toast--alert",
      text: /Select at least one network host/
  end
end
