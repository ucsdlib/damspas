module ActiveFedora
  module Rdf
    module DefaultNodes
      extend ActiveSupport::Concern

      included do
        class_attribute :_default_write_point
        ActiveFedora::RdfNode::TermProxy.delegate :_default_write_point, to: :target_class
      end

      def attributes=(values)
        case values
        when Hash
          super
        when String
          populate_default(values)
        else
          raise ArgumentError, "You must provide a String or a Hash.  You provided #{values.class}"
        end
      end
      
      # Set values within the node according to its Class defaults
      # If no defaults have been set on the Class a RuntimeError is raised. 
      # set the default by using default_write_point_for_values.
      def populate_default(values)
        parent = self
        if _default_write_point.nil?
          raise "default_write_point_for_values has not been set for #{self.class}, unable to write #{values.inspect}"
        end
        path = _default_write_point.dup
        path.each_with_index do |property_symbol, index|
          if index == path.length-1
            attrs = {}
            attrs[property_symbol] = values
            parent.attributes = attrs
            # puts "Added #{values} to #{default_write_point_for_values}"
          else
            parent = parent.send(property_symbol).build()
          end
        end
      end
    


      module ClassMethods
        # Specifies the default location for writing values on this type of Node.
        # This primarily affects what happens when you use `=` or `<<` to set values on a Node or use `.value` to get the values of a node.
        # To make your Node classes write/read values to/from a custom location, override this method
        # This method should always return an Array of properties that can be traversed using the current node as the starting point.
        # 
        # Note: Much of the behavior that this setting affects is implemented in the `populate_default` method.
        #
        # @example Use default behavior to put assertions in `http://www.w3.org/1999/02/22-rdf-syntax-ns#value`
        #   @ds.topic = "Cosmology"
        #   @ds.value
        #   => ["Cosmology"]
        #
        # @example Set default write point to [:elementList, :topicElement]
        #   class Topic
        #     include ActiveFedora::RdfObject
        #     default_write_point_for_values  [:elementList, :topicElement]
        #   
        #     # rdf_type DummyMADS.Topic
        #     map_predicates do |map|
        #       map.elementList(in: DummyMADS, to: "elementList", class_name:"DummyMADS::ElementList")
        #     end
        #   end
        #   class ElementList
        #     include ActiveFedora::RdfObject
        #     rdf_type DummyMADS.elementList
        #     map_predicates do |map|
        #       map.topicElement(in: DummyMADS, to: "TopicElement")
        #     end
        #   end
        #
        #   @ds.topic = "Cosmology"
        #   @ds.topic(0).elementList.topicElement
        #   => "Cosmology"
        #   @ds.topic.value = ["Cosmology"]
        def default_write_point_for_values (vals)
          # When relying on the default write point :value, make sure :value predicate is declared by the class.  If not, map it to the RDF.value predicate.
          self._default_write_point = vals
        end
      end
    end
  end
end
