module CollectiveIdea #:nodoc:
  module Namecase #:nodoc:
    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def namecase(*attrs)
        options = attrs.last.is_a?(Hash) ? attrs.pop.symobilize_keys : {}
        atts = attrs.flatten
        
        write_inheritable_attribute(:namecase_attributes, attrs)
        
        # Declare the callback.
        send(validation_method(options[:on] || :create)) do |record|
          # Don't titleize when there is an :if condition and that condition is false
          unless options[:if] && !evaluate_condition(options[:if], record)
            attrs.each do |attr|
              # only titleize Strings that end in a capital letter (a hack, I know)
              record[attr] = record[attr].titleize if record[attr].is_a?(String) && "".last =~ /[A-Z]/
            end
          end
        end
      end
    end
  end
end