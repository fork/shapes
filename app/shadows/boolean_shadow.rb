class BooleanShadow < Shadows::Base
  def form
    render_shape(:form)
  end
  def form_for_struct
    render_shape(:form_struct)
  end
end
