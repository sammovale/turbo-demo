require "test_helper"

class NetworkHostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @network_host = network_hosts(:edge)
  end

  test "gets the Turbo-powered index" do
    get network_hosts_url

    assert_response :success
    assert_select "meta[name='turbo-refresh-method'][content='morph']", 1
    assert_select "meta[name='turbo-refresh-scroll'][content='preserve']", 1
    assert_select "turbo-cable-stream-source", 1
    assert_select "form.table-filters[data-turbo-frame='network_hosts_table']", 1
    assert_select "turbo-frame#network_hosts_table", 1 do
      assert_select "form.table-filters", 0
      assert_select "table tbody tr", 2
    end
    assert_select "th.is-sorted[aria-sort='ascending'] a", text: /Hostname ↑/
    assert_select "form.bulk-actions[action='#{bulk_update_path}']", 1 do
      assert_select "input[name='bulk_update[ids][]']", 2
      assert_select "input[type='submit'][disabled]", value: "Update selected"
    end
    assert_select "a[data-turbo-frame='modal']", text: "Change status", count: 2
    assert_select "turbo-frame#modal", 1
  end

  test "filters and sorts the index with safe query parameters" do
    get network_hosts_url, params: { status: "active", sort: "hostname", direction: "desc" }

    assert_response :success
    assert_select "table tbody tr", 1
    assert_select "a", text: @network_host.hostname
    assert_select "th.is-sorted[aria-sort='descending'] a", text: /Hostname ↓/
  end

  test "paginates inside the table frame after loading the landing page" do
    get root_url, params: { per_page: 1 }

    assert_response :success
    assert_select "a", text: "Next →"

    get network_hosts_url(page: 2, per_page: 1), headers: { "Turbo-Frame" => "network_hosts_table" }

    assert_response :success
    assert_select "turbo-frame#network_hosts_table"
    assert_select ".pagination", text: /Page 2 of 2/
  end

  test "gets new" do
    get new_network_host_url
    assert_response :success
  end

  test "creates a network host" do
    assert_difference("NetworkHost.count") do
      post network_hosts_url, params: { network_host: valid_attributes }
    end

    assert_redirected_to network_host_url(NetworkHost.last)

    follow_redirect!
    assert_select "#toasts .toast", text: /Network host was created/
  end

  test "shows a network host in an editable frame" do
    get network_host_url(@network_host)

    assert_response :success
    assert_select "turbo-cable-stream-source", 1
    assert_select "turbo-frame#network_host_#{@network_host.id}"
  end

  test "gets edit" do
    get edit_network_host_url(@network_host)
    assert_response :success
  end

  test "updates a network host" do
    patch network_host_url(@network_host), params: { network_host: { design_name: "Updated edge" } }

    assert_redirected_to network_host_url(@network_host)
    assert_equal "Updated edge", @network_host.reload.design_name
  end

  test "updates a network host and displays a toast with Turbo Streams" do
    patch network_host_url(@network_host),
      params: { network_host: { design_name: "Streamed update" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_select "turbo-stream[action='replace'][target='network_host_#{@network_host.id}']"
    assert_select "turbo-stream[action='prepend'][target='toasts'] .toast", text: /was updated/
    assert_equal "Streamed update", @network_host.reload.design_name
  end

  test "destroys a network host" do
    assert_difference("NetworkHost.count", -1) do
      delete network_host_url(@network_host)
    end

    assert_redirected_to network_hosts_url
  end

  private
    def valid_attributes
      {
        hostname: "hq-sw-99",
        design_name: "HQ lab switch",
        ip_address: "10.20.99.1",
        mac_address: "02:00:00:00:00:99",
        location: "New York HQ",
        device_type: "switch",
        vendor: "Cisco",
        hardware_model: "Catalyst 9300",
        operating_system: "IOS XE 17.12",
        status: "active",
        vlan_id: 99,
        notes: "Test host"
      }
    end
end
