require 'datamappify/data/criteria/relational/criteria_method'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class CriteriaMethod < Relational::CriteriaMethod
          private

          # @param scope [Sequel::DataSet]
          #
          # @return [Sequel::DataSet]
          def records_scope(scope = nil)
            secondaries.inject(scope || source_class) do |scope, secondary|
              join_condition = if secondary.options[:via]
                { :id => secondary.options[:via] }
              else
                { secondary.reference_key => :id }
              end

              begin
                scope.graph(secondary.source_table, join_condition)
              rescue ::Sequel::Error
                scope
              end
            end
          end

          # @param primaries [Array<Attribute>]
          #
          # @param secondaries [Array<Attribute>]
          #
          # @return [Hash]
          def structured_criteria
            _criteria = {}

            primaries.each do |primary|
              _criteria[:"#{primary.source_table}__#{primary.source_attribute_key}"] = primary.value
            end

            secondaries.each do |secondary|
              _criteria[:"#{secondary.source_table}__#{secondary.source_attribute_name}"] = secondary.value
            end

            _criteria
          end
        end
      end
    end
  end
end
