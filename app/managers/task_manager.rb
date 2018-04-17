class TaskManager
  class << self
    def start(task_id, user_id)
      task = Task.find(task_id)
      user = User.find(user_id)
      if task.nil?
        Log.create(message: "nil task", status: "warn",
                   subject: "TaskManager::start")
        return
      end
      if user.nil?
        Log.create(message: "nil user", status: "warn",
                   subject: "TaskManager::start")
        return
      end


      input_user_login, input_iid = task.script.input.split(":")
      #binding.pry
      input_file = Document.joins(:owner)
                           .where(users: { login: input_user_login }, iid: input_iid)
                           .where('type ILIKE ?', "%File")
                           .first
      if input_file.nil?
        Log.create(message: "Not find input file with parameters: " <<
                   "login: #{input_user_login}, iid: #{input_iid} and File type",
                   status: "warn",
                   subject: "TaskManager::start")
        return
      end
      # Проверить файл
      # PermitManager.allow()

      # подготовить временные файлы (скрипты)


      task.prepared!
      
      # Запуск самой задачи
      #cmd = "yarnhd jar /usr/local/hadoop/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.0.jar pi 0 1"
      cmd = "yarnhd jar /usr/local/hadoop/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.0.jar pi 160 10000"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, wait_thr|
        task.update_column(:unix_pid, wait_thr[:pid])

        if wait_thr.value.success? # blocking operation (wait_thr.value)
          task.finish
          task.prepared!

          output = stdouterr.read
          if output != ""
            TaskLog.create(state: :finished, message: output, task: task)
          end

          TaskLog.create(state: :finished, message: "Task finished successful!", task: task)
        else
          task.stop
          task.prepared!

          output = stdouterr.read
          if output != ""
            TaskLog.create(state: :stopped, message: output, task: task)
          end

          TaskLog.create(state: :stopped, message: "The task was stopped due to an error", task: task)
        end
      end
      task.update_column(:unix_pid, "")

      # Очистить временные файлы

    end

    def stop(task_id, user_id)
      task = Task.find(task_id)
      user = User.find(user_id)
      if task.nil?
        Log.create(message: "nil task", status: "warn",
                   subject: "TaskManager::start")
        return
      end
      if user.nil?
        Log.create(message: "nil user", status: "warn",
                   subject: "TaskManager::start")
        return
      end

      task.prepared!

      if task.unix_pid.present?
        exit = system("kill -9 #{task.unix_pid}")
        if exit
          task.update_column(:unix_pid, "")
          TaskLog.create(state: :stopped, task: task,
                         message: "Task be successful stopped by user")
        end
      end
    end

    def restart(task_id, user_id)
      task = Task.find(task_id)
      user = User.find(user_id)
      if task.nil?
        Log.create(message: "nil task", status: "warn",
                   subject: "TaskManager::restart")
        return
      end
      if user.nil?
        Log.create(message: "nil user", status: "warn",
                   subject: "TaskManager::restart")
        return
      end

      TaskLog.create(state: :started, task: task,
                     message: "Restart task")
      # self.start(task.id, user.id)
    end
  end
end
