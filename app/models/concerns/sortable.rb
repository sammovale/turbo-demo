module Sortable
  extend ActiveSupport::Concern

  included do
    class_attribute :sortable_attributes, instance_writer: false, default: []
    class_attribute :default_sort_attribute, instance_writer: false
    class_attribute :default_sort_direction, instance_writer: false, default: "asc"
  end

  class_methods do
    def sorts_by(*attributes, default: attributes.first, direction: :asc)
      self.sortable_attributes = attributes.map(&:to_s).freeze
      self.default_sort_attribute = default.to_s
      self.default_sort_direction = normalized_direction(direction)
    end

    def sorted_by(sort: nil, direction: nil)
      attribute = sort_attribute_for(sort)
      direction = sort_direction_for(direction)

      order(attribute => direction).order(id: direction)
    end

    def sort_attribute_for(sort)
      sortable_attributes.include?(sort.to_s) ? sort.to_s : default_sort_attribute
    end

    def sort_direction_for(direction)
      normalized_direction(direction.presence || default_sort_direction)
    end

    private
      def normalized_direction(direction)
        %w[ asc desc ].include?(direction.to_s) ? direction.to_s : "asc"
      end
  end
end
