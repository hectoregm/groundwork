module HamlHelper

  def locale_attrs
    html_attrs(I18n.locale.to_s)
  end

  def submit_button(label)
    capture_haml do
      haml_tag :fieldset, :class => 'buttons' do
        haml_tag :ol do
          haml_tag :li do
            haml_concat submit_tag label, :class => 'button'
          end
        end
      end
    end
  end

  def text_field_i18n(model, attribute)
    str = attribute.to_s
    capture_haml do
      haml_concat label_tag(str, model.human_attribute_name(str))
      haml_concat text_field_tag(attribute, nil, :class => 'text_field')
    end
  end

end
