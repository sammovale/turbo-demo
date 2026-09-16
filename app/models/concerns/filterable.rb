module Filterable
  extend ActiveSupport::Concern

  included do
    class_attribute :filterable_attributes, instance_writer: false, default: []
    class_attribute :searchable_attributes, instance_writer: false, default: []
  end

  class_methods do
    def filters_by(*attributes)
      self.filterable_attributes = attributes.map(&:to_s).freeze
    end

    def searches_by(*attributes)
      self.searchable_attributes = attributes.map(&:to_s).freeze
    end

    def filtered_by(filters = {})
      filters = filters.to_h.stringify_keys
      relation = all

      if filters["query"].present? && searchable_attributes.any?
        relation = matching(relation, filters["query"])
      end

      filterable_attributes.each do |attribute|
        if filters[attribute].present?
          relation = relation.where(attribute => filters[attribute])
        end
      end

      relation
    end

    def filter_options_for(attribute)
      attribute = attribute.to_s

      if filterable_attributes.include?(attribute)
        where.not(attribute => [ nil, "" ]).distinct.order(attribute).pluck(attribute)
      else
        raise ArgumentError, "#{attribute} is not a configured filter"
      end
    end

    private
      def matching(relation, query)
        pattern = "%#{sanitize_sql_like(query.strip)}%"
        predicates = searchable_attributes.map { |attribute| arel_table[attribute].matches(pattern) }
        relation.where(predicates.reduce(&:or))
      end
  end
end
