module ApplicationHelper
  def default_url_options(options={})
    if current_user.present?
      options.merge(login: current_user.login)
    else
      options
    end
  end

  def active?(path)
    request.path == path ? "active" : ""
  end
  def current_user?(user)
    current_user.id == user.id
  end
  def show404
    render "errors/show404", status: 404
  end

  def back_to_index(resource_name)
    content_tag :div do
      link_to "#{resource_name.pluralize.camelize}", send(:"#{resource_name.pluralize}_path"),
                      class: "btn btn-secondary float-right"
    end
  end
end
