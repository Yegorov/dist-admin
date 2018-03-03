module ApplicationHelper
  def active?(path)
    request.path == path ? "active" : ""
  end
  def current_user?(user)
    current_user.id == user.id
  end
end
