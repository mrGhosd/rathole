module ApplicationHelper

  def page_header(main_text, small_text = nil)
    content_tag :div, class: 'page-header' do
      content_tag :h1 do 
        text = main_text
        text += content_tag :small, small_text if small_text
        raw text
      end
    end
  end

  def icon(name, text = nil)
    result = content_tag :i, '', class: "fa fa-#{name.to_s}"
    result += raw("&nbsp; #{text}") if text
    result
  end

  def edit_link(model, href = nil)    
    href ||= url_for [:edit, :user, model]
    content_tag :a, icon(:edit), href: href, class: 'edit'
  end

  def page_header
    content_tag :h2, t('.page_header')
  end

  def spacer 
    content_tag :div, '', class: 'spacer'
  end

  def menu_item(title, href, icon_name = nil)
    text = icon_name ? icon(icon_name, title) : title
    content_tag :li, content_tag(:a, text, href: href)
  end

  def menu_divider
    content_tag :li, '', class: 'divider'
  end

  def full_image_url(path)
    request.protocol + request.host_with_port + path
  end
end
