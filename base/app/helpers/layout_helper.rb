module LayoutHelper

  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

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
