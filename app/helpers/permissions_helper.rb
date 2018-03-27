module PermissionsHelper
  def get_action_tree(actions, permissions)
    res = []
    actions.each do |action|
      #binding.pry
      is_select = !(permissions.reject! { |p| p.action.id == action[:id] }).nil?
      node = {
        text: action[:title],
        id: action[:id],
        checked: is_select
        # href: "#node-1",
        # selectable: true,
        # state: {
        #   expanded: true,
        #   selected: is_select,
        #   checked: is_select
        # }
      }
      nodes = get_action_tree(action[:childrens], permissions)
      node[:children] = nodes if nodes.present?
      res << node
    end
    res
  end
end
