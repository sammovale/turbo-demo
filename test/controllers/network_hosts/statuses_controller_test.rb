require "test_helper"

class NetworkHosts::StatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @network_host = network_hosts(:edge)
  end

  test "loads the status editor in the reusable modal frame" do
    get edit_network_host_status_url(@network_host), headers: { "Turbo-Frame" => "modal" }

    assert_response :success
    assert_select "turbo-frame#modal dialog.modal[data-turbo-temporary][data-controller='modal']"
    assert_select "form[action='#{network_host_status_path(@network_host)}']"
  end

  test "updates the status with targeted Turbo Streams" do
    patch network_host_status_url(@network_host),
      params: { network_host: { status: "maintenance" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_select "turbo-stream[action='replace'][target='status_network_host_#{@network_host.id}']"
    assert_select "turbo-stream[action='replace'][target='modal']"
    assert_select "turbo-stream[action='prepend'][target='toasts'] .toast", text: /status was updated/
    assert_equal "maintenance", @network_host.reload.status
  end

  test "re-renders invalid Turbo updates in the modal frame" do
    patch network_host_status_url(@network_host),
      params: { network_host: { status: "unknown" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :unprocessable_content
    assert_select "turbo-frame#modal"
    assert_select ".form-errors", text: /Status is not included/
    assert_equal "active", @network_host.reload.status
  end

  test "redirects non-Turbo updates to the host" do
    patch network_host_status_url(@network_host), params: { network_host: { status: "retired" } }

    assert_redirected_to network_host_url(@network_host)
  end
end
