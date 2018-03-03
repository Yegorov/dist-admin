module ApplicationHelper
  def active?(path)
    request.path == path ? "active" : ""
  end
  def current_user?(user)
    current_user.id == user.id
  end
  def show404
    render "errors/show404", status: 404
  end
end
