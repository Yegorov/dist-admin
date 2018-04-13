class FileManager
  # MY_ENV = {
  #   "JAVA_HOME" => "/usr/lib/jvm/java-8-oracle",
  #   "PATH" => "/bin:/usr/bin:/usr/local/hadoop/hadoop-2.9.0/bin"
  # }
  class << self
    def create_new_file(upload_file_id)
      upload_file = UploadFile.find(upload_file_id)

      md5hash = CheckSumManager.md5(upload_file.path)
      date = Time.now.strftime('%Y-%m-%d')
      login = upload_file.user.login

      # in local machine make: `sudo mkdir /userdata` 
      # and add access: `sudo chown USERNAME /userdata` for user if need  
      folder_path = "/userdata/#{login}/#{date}/"

      path = "hdfs://" + folder_path + upload_file.unique_id

      parent = Document.owned(upload_file.user).find_by(iid: upload_file.to)
      file = FileEntity::File.mk_file(name: upload_file.file_name,
                                      real_path: path,
                                      user: upload_file.user,
                                      parent: parent)
      file.size = upload_file.size
      file.hash_sum = md5hash
      file.save

#binding.pry

      # hadoop fs -mkdir -p userdata/admin/2018-04-13
      # add slash to folder_path
      cmd = "hadoop fs -mkdir -p #{folder_path}"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, _|
        output = stdouterr.read
        if output != ""
          Log.create(message: output, status: "error",
                     subject: "FileManager::create_new_file, create dir")
          return
        end
      end


      # hadoop fs -copyFromLocal /tmp/file userdata/admin/2018-04-13
      cmd = "hadoop fs -copyFromLocal #{upload_file.path} #{folder_path}"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, _|
        output = stdouterr.read
        if output != ""
          Log.create(message: output, status: "error",
                     subject: "FileManager::create_new_file, copy file")
          return
        end
      end


      file.prepared = true
      file.save
    end
  end
end
