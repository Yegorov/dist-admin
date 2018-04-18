require 'securerandom'

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
      input_file_path = input_file.real_path.sub('hdfs://', '')
      output_folder = "/userdata/#{user.login}/task_#{task.id}_#{Time.now.to_i.to_s}"
      # Проверить файл input
      # PermitManager.allow()

      # Проверить файл output или создать его



      # подготовить временные файлы (скрипты)
      exts = { 'python' => 'py', 'ruby' => 'rb', 'golang' => 'go', 'javascript' => 'js'}
      lang = task.script.language
      tmp_dir = "/tmp/files_for_mapreduce/"
      Dir.mkdir(tmp_dir) unless Dir.exists?(tmp_dir)
      unique_id = [user.login, SecureRandom.hex(5), Time.now.to_i.to_s].join("_")
      mapper_path = tmp_dir + "mapper_#{unique_id}.#{exts[lang]}"
      reducer_path = tmp_dir + "reducer_#{unique_id}.#{exts[lang]}"

      File.open(mapper_path, "w") do |f|
        f.write(task.script.mapper.gsub("\r\n", "\n"))
      end

      File.open(reducer_path, "w") do |f|
        f.write(task.script.reducer.gsub("\r\n", "\n"))
      end

      # set permission for run script chmod +x
      unless system("chmod +x #{mapper_path} #{reducer_path}")
        Log.create(message: "Not set permission for run script: " <<
                   "#{task.inspect!}",
                   status: "warn",
                   subject: "TaskManager::start")
        return
      end

      runCmd =
        "hadoop jar /usr/local/hadoop/hadoop-2.9.0/share/hadoop/tools/lib/hadoop-streaming-2.9.0.jar " \
        "-files \"#{mapper_path},#{reducer_path}\" " \
        "-input \"#{input_file_path}\" " \
        "-output \"#{output_folder}\" " \
        "-mapper \"#{mapper_path}\" " \
        "-reducer \"#{reducer_path}\" "

      Log.create(message: "CMD:\n#{runCmd}", status: 'info', subject: "TaskManager::start")

      task.prepared!
      
      # Запуск самой задачи
      cmd = "yarnhd jar /usr/local/hadoop/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.0.jar pi 0 1"
      #cmd = "yarnhd jar /usr/local/hadoop/hadoop-2.9.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.0.jar pi 160 10000"
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

      # Очистить временные файлы, скрипты
      #File.delete(mapper_path)
      #sFile.delete(reducer_path)

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
