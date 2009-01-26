module ActiveRecord #:nodoc:
  class Base #:nodoc:
    def self.inherited_with_shapes(base)
      inherited_without_shapes(base)
      Shapes.extend_model(base)
    end
    class << self
      alias_method_chain :inherited, :shapes
    end
  end
  module Acts #:nodoc:
    module Shape #:nodoc:
      module ClassMethods

        DEFAULTS = {
          :to_shape_xml_options  => nil,
          :scope                => {},
          :select_name          => :id
        }

        def acts_as_shape(options = {})
          options = DEFAULTS.merge options

          # FIXME: Inheritance FAILS
          write_inheritable_attribute :acts_as_shape_options, options
          class_inheritable_reader :acts_as_shape_options

          define_method(:name_for_select) do
            if acts_as_shape_options[:select_name].is_a?(Symbol)
              self.send(acts_as_shape_options[:select_name]).to_s
            elsif acts_as_shape_options[:select_name].is_a?(Proc)
              acts_as_shape_options[:select_name].call(self).to_s
            end
          end
          #TODO:
          # if options[:select_name].is_a? Symbol
          #  class_eval %Q"def name_for_select
          #    #{ acts_as_shape_options[:select_name] }.to_s
          #  end"
          #elsif options[:select_name].is_a? Proc
          #  define_method :name_for_select, &options[:select_name]
          #end

          has_many :shape_assignments,
            :dependent => :destroy
          has_many :shapes,
            :through => :shape_assignments

          # TODO: Move this into instance methods
          after_update do |record|
            record.shapes.each { |shape| shape.expire_cache }
          end
          # TODO: Move this into instance methods
          after_destroy do |record|
            record.shapes.each { |shape| shape.expire_cache }
          end

        end

        def find_in_scope
          find :all, :conditions => acts_as_shape_options[:scope]
        end
      end
    end
  end
end
