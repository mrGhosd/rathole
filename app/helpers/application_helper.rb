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
    pluralized_class_name = model.class.name.downcase.pluralize
    content_tag :a, icon(:edit), href: href, class: 'edit', title: I18n.t("links.#{pluralized_class_name}.edit")
  end

  def page_header
    content_tag :h2, t('.page_header')
  end

  def spacer 
    content_tag :div, '', class: 'spacer'
  end

  def menu_item(title, href, icon_name = nil, options = {})
    text = icon_name ? icon(icon_name, title) : title
    content_tag :li, content_tag(:a, text, href: href), options
  end

  def menu_divider
    content_tag :li, '', class: 'divider'
  end

  def scroll_to_top
    content_tag :a, icon('arrow-circle-o-up'), href: '#scroll-to-top', id: 'scroll-to-top', title: I18n.t('links.back_to_top')
  end

  def user_subscription_link(user)
    if current_user.subscribed_on?(user)
      link_to icon('bookmark', t('users.avatar.unsubscribe')), subscriptions_user_path(author_id: user.id), title: I18n.t('users.unsubscribe.title.author'), class: 'btn btn-success', method: 'delete'
    else
      link_to icon('bookmark-o', t('users.avatar.subscribe')), subscriptions_user_path(author_id: user.id), title: I18n.t('users.subscribe.title.author'), class: 'btn btn-success', method: 'post'
    end
  end

  def upload_picture_link(target, title, options = {}, &block)
    attrs = options || {}
    attrs[:title] = title if title.present?
    attrs[:class] = "#{attrs[:class]} upload-picture"
    attrs[:data] = (attrs[:data] || {}).merge(target: target, title: title)
    if block
      link_to upload_picture_path, attrs, &block
    else
      link_to icon('upload'), upload_picture_path, attrs
    end
  end
end
