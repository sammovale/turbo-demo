module ApplicationHelper
  def sortable_table_header(label, attribute, frame:)
    active = table_sort_attribute == attribute.to_s
    direction = active && table_sort_direction == "asc" ? "desc" : "asc"
    indicator = active ? (table_sort_direction == "desc" ? "↓" : "↑") : "↕"
    aria_sort = active ? (table_sort_direction == "desc" ? "descending" : "ascending") : nil
    url = url_for(table_query_parameters.merge(sort: attribute, direction: direction))

    tag.th scope: "col", class: active ? "is-sorted" : nil, aria: { sort: aria_sort } do
      link_to url, data: { turbo_frame: frame }, class: "sort-link" do
        safe_join([ label, tag.span(indicator, aria: { hidden: true }) ], " ")
      end
    end
  end

  def status_badge(status)
    tag.span(status.humanize, class: "status-badge status-badge--#{status}")
  end
end
