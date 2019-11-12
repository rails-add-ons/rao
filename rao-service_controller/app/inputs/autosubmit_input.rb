class AutosubmitInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    wrapper_options.reverse_merge!(label: false)
    if template.autosubmit_now?
      template.content_tag(:div, nil, data: { autosubmit: true } )
    end
  end
end