class PermitManager
  class << self
    def allow?(document, user, action)
      if document.owner == user
        return true
      end

      DocumentActionLog.create!(user: user,
                                document: document,
                                action: action,
                                message: "User #{user.name} (id=#{user.id}) " <<
                                         "made a request to use the file")
      DocumentPermission.user(user)
                        .document(document)
                        .action(action)
                        .exists?
    end
  end
end
