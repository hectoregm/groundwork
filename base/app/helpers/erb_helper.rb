module ErbHelper

  def locale_attrs
    locale = I18n.locale.to_s
    "lang='#{locale}' xml:lang='#{locale}' xmlns='http://www.w3.org/1999/xhtml'"
  end

  def text_field_i18n(model, attribute)
    str = attribute.to_s
    result = label_tag(str, model.human_attribute_name(str)) + "\n"
    result += text_field_tag(attribute, nil, :class => 'text_field') + "\n"
    result
  end

  def submit_button(label)
    content_tag :fieldset, :class => 'buttons' do
      content_tag :ol do
        content_tag :li do
          submit_tag label, :class => 'button'
        end
      end
    end
  end

end
