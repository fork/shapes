module Shapes
  module Assignment

    def create_assignment
      assignment = record.shape_assignments.
        build(:shape => base.shape, :path => path) and
        assignment.save
    end

    def destroy
      destroy_assignment
      super
    end

    def after_clone
      create_assignment
      super
    end

    def after_save
      assignment = record.shape_assignments.
          find_first_by_path_and_shape(path(@_ident), base.shape)

      if new_resource?
        create_assignment
      elsif path(true) != path
        assignment = record.shape_assignments.
          find_first_by_path_and_shape(path(true), base.shape)
        assignment.path = path
        assignment.save
      end
      super
    end

    def destroy_assignment
      assignment = record.shape_assignments.
        find_first_by_path_and_shape(path, base.shape)
      assignment and assignment.delete
    end

  end
end
