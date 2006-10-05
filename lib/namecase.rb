module CollectiveIdea #:nodoc:
  module Namecase #:nodoc:
    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def namecase(*attrs)
        options = attrs.last.is_a?(Hash) ? attrs.pop.symbolize_keys : {}
        attrs = attrs.flatten
        
        class_eval do
          save_methods = { :create => :before_create, :save => :before_save }
        
          # Declare the callback.
          # send(save_methods[options[:on] || :create]) do |record|
          before_save do |record|
            attrs.each do |attr_name|
              # only titleize Strings that end with a cap or don't contain any caps (a hack, I know)
              if record[attr_name].is_a?(String) && (record[attr_name].last =~ /[A-Z]/ || (record[attr_name] =~ /[A-Z]/).nil?)
                record[attr_name] = record[attr_name].titleize
              end
            end
          end
        end
      end
    end
  end
end