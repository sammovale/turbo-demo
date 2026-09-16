class TablePage
  DEFAULT_SIZE = 10
  MAXIMUM_SIZE = 100

  attr_reader :current_page, :page_size, :records, :total_count, :total_pages

  def initialize(scope, page: nil, page_size: nil)
    @page_size = normalize_page_size(page_size)
    @total_count = scope.count
    @total_pages = [ (@total_count.to_f / @page_size).ceil, 1 ].max
    @current_page = normalize_page(page)
    @records = scope.limit(@page_size).offset((@current_page - 1) * @page_size)
  end

  def next_page
    current_page + 1 if current_page < total_pages
  end

  def previous_page
    current_page - 1 if current_page > 1
  end

  def first_record
    total_count.zero? ? 0 : (current_page - 1) * page_size + 1
  end

  def last_record
    [ current_page * page_size, total_count ].min
  end

  private
    def normalize_page_size(value)
      (value.presence || DEFAULT_SIZE).to_i.clamp(1, MAXIMUM_SIZE)
    end

    def normalize_page(value)
      (value.presence || 1).to_i.clamp(1, total_pages)
    end
end
