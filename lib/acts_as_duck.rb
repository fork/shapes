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

        DEFAULTS = {
          :to_duck_xml_options  => nil,
          :scope                => {},
          :select_name          => :id
        }

        def acts_as_duck(options = {})
          options = DEFAULTS.merge options

          # FIXME: Inheritance FAILS
          write_inheritable_attribute :acts_as_duck_options, options
          class_inheritable_reader :acts_as_duck_options

          define_method(:name_for_select) do
            if acts_as_duck_options[:select_name].is_a?(Symbol)
              self.send(acts_as_duck_options[:select_name]).to_s
            elsif acts_as_duck_options[:select_name].is_a?(Proc)
              acts_as_duck_options[:select_name].call(self).to_s
            end
          end
          #TODO:
          # if options[:select_name].is_a? Symbol
          #  class_eval %Q"def name_for_select
          #    #{ acts_as_duck_options[:select_name] }.to_s
          #  end"
          #elsif options[:select_name].is_a? Proc
          #  define_method :name_for_select, &options[:select_name]
          #end

          has_many :duck_appearances,
            :as => :appearance,
            :dependent => :destroy
          has_many :ducks,
            :through => :duck_appearances

          # TODO: Move this into instance methods
          after_update do |record|
            record.ducks.each { |duck| duck.expire_cache }
          end
          # TODO: Move this into instance methods
          after_destroy do |record|
            record.ducks.each { |duck| duck.expire_cache }
          end

        end

        def find_in_scope
          find :all, :conditions => acts_as_duck_options[:scope]
        end
      end
    end
  end
end
