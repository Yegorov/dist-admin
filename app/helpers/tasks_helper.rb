module TasksHelper
  def state_line(all_states, current_state)
    all_states.each do |state|
      badge_class = state == current_state ? 'badge-primary' : 'badge-secondary'
      concat(content_tag('span', t(state, scope: 'tasks.show.states', default: state),
                         class: "badge #{badge_class} mr-2"))
    end
  end
end
