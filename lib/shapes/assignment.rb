module Shapes
  module Assignment

    def destroy
      destroy_assignment
      children.collect{ |c| c }.each do |primitive|
        primitive.destroy
      end
      super
    end

    def after_save
      if new_resource?
        assignment = record.shape_assignments.
          build(:shape => base.shape, :path => path) and
        assignment.save
      elsif @ident != @_ident
        assignment = record.shape_assignments.
          find_first_by_path_and_shape(path(@_ident), base.shape)
        assignment.path = path
        assignment.save
      end
      super
    end

    def destroy_assignment
      assignment = record.shape_assignments.
        find_first_by_path_and_shape(path, base.shape)
      assignment and assignment.destroy
    end

  end
end
