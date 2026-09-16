require "test_helper"

class TablePageTest < ActiveSupport::TestCase
  test "paginates a scope and exposes navigation metadata" do
    11.times do |index|
      NetworkHost.create!(
        hostname: "test-host-#{index}", design_name: "Test #{index}", ip_address: "192.0.2.#{index + 1}",
        location: "Lab", device_type: "server", status: "active"
      )
    end

    page = TablePage.new(NetworkHost.order(:hostname), page: 2, page_size: 10)

    assert_equal 13, page.total_count
    assert_equal 2, page.total_pages
    assert_equal 3, page.records.size
    assert_equal 11, page.first_record
    assert_equal 13, page.last_record
    assert_equal 1, page.previous_page
    assert_nil page.next_page
  end
end
