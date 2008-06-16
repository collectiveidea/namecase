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
          send(save_methods[options[:on] || :create]) do |record|
            attrs.each do |attr_name|
              # only titleize Strings that don't contain any lower case letters or
              # don't contain any caps (a hack, I know)
              if record[attr_name].is_a?(String) && ((record[attr_name] =~ /[a-z]/).nil? || (record[attr_name] =~ /[A-Z]/).nil?)
                record[attr_name] = record[attr_name].namecase
              end
            end
          end
        end
      end
    end
  end
end

class String
  def namecase
    downcase.gsub(/\b([a-z])/) { $1.capitalize }
  end
  
  def namecase!
    replace namecase
  end
end