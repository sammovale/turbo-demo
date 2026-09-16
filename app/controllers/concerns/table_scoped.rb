module TableScoped
  extend ActiveSupport::Concern

  included do
    class_attribute :table_model, instance_writer: false
    helper_method :table_query_parameters, :table_sort_attribute, :table_sort_direction
  end

  class_methods do
    def table_for(model)
      self.table_model = model
    end
  end

  private
    def paginate_table(scope)
      @table_page = TablePage.new(scope, page: params[:page], page_size: params[:per_page])
      @table_page.records
    end

    def table_filter_parameters
      params.permit(:query, *table_model.filterable_attributes)
    end

    def table_order_parameters
      params.permit(:sort, :direction).to_h.symbolize_keys
    end

    def table_query_parameters
      request.query_parameters.slice(
        "query", *table_model.filterable_attributes, "sort", "direction", "per_page"
      ).compact_blank
    end

    def table_sort_attribute
      table_model.sort_attribute_for(params[:sort])
    end

    def table_sort_direction
      table_model.sort_direction_for(params[:direction])
    end
end
