module ActiveRecord #:nodoc:
  class Base #:nodoc:
    def self.inherited_with_ducks(base)
      inherited_without_ducks(base)
      DuckDescribe.extend_model(base)
    end
    class << self
      alias_method_chain :inherited, :ducks
    end
  end
  module Acts #:nodoc:
    module Duck #:nodoc:
      module ClassMethods       
      
        def acts_as_duck
          options = DuckDescribe.config[self.name]

          write_inheritable_attribute(:acts_as_duck_options, 
            options.merge({
              :to_duck_xml_options => options[:to_duck_xml_options],
              :scope => options.delete(:scope) || {},
              :select_name => options.delete(:select_name) || :id
            })
          )
          class_inheritable_reader :acts_as_duck_options

          define_method(:name_for_select) do
            if acts_as_duck_options[:select_name].is_a?(Symbol)
              self.send(acts_as_duck_options[:select_name]).to_s
            elsif acts_as_duck_options[:select_name].is_a?(Proc)
              acts_as_duck_options[:select_name].call(self).to_s
            end
          end

          has_many :duck_appearances,
            :as => :appearance,
            :dependent => :destroy
          has_many :ducks,
            :through => :duck_appearances

          after_update {|record| 
            record.ducks.each(&:expire_cache)
          }
          after_destroy {|record| 
            record.ducks.each(&:expire_cache)
          }
        end

        def find_in_scope
          find :all, :conditions => acts_as_duck_options[:scope]
        end
      end
    end
  end
end
