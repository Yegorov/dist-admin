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

      File.delete(upload_file.path)
      upload_file.destroy


      file.prepared = true
      file.save
    end

    def encrypt_file(document_id, encript_opts)
      file = Document.find(document_id)
      file.update_attributes(prepared: false)

      tmp_dir = "/tmp/files_for_encrypt/"
      Dir.mkdir(tmp_dir) unless Dir.exists?(tmp_dir)

      doc_path = file.real_path
      if doc_path[0..6] = "hdfs://"
        doc_path = doc_path[7..-1]
      end
      doc_name = doc_path.split('/')[-1]
      temp_doc_path = "#{tmp_dir}#{doc_name}"

      # copy from hdfs
      cmd = "hadoop fs -copyToLocal #{doc_path} #{tmp_dir}"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, _|
        output = stdouterr.read
        if output != ""
          Log.create(message: output, status: "error",
                     subject: "FileManager::encript_file, copy file to local")
          return
        end
      end

      # Encrypt
      EncryptManager.encrypt(encript_opts[:ciphername],
                             encript_opts[:password],
                             temp_doc_path)

      # copy to hdfs
      cmd = "hadoop fs -copyFromLocal -f #{temp_doc_path}_enc #{doc_path}"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, _|
        output = stdouterr.read
        if output != ""
          Log.create(message: output, status: "error",
                     subject: "FileManager::encript_file, copy file to hdfs")
          return
        end
      end

      File.delete(temp_doc_path)
      File.delete(temp_doc_path << "_enc")

      file.create_encryptor(cipher: encript_opts[:ciphername],
                            pass_phrase: encript_opts[:password])

      file.update_attributes(prepared: true)
    end

    def decrypt_file(document_id, password)
      file = Document.find(document_id)

      encryptor = file.encryptor
      if encryptor.nil?
        Log.create(message: "Encryptor is nil for document with id=#{document_id}",
                   status: "warn",
                   subject: "encryptor password")
        return
      end
      unless encryptor.verify_pass_phrase(password)
        Log.create(message: "Incorrect passphrase", status: "warn",
                   subject: "encryptor password")
        return
      end

      file.update_attributes(prepared: false)

      tmp_dir = "/tmp/files_for_decrypt/"
      Dir.mkdir(tmp_dir) unless Dir.exists?(tmp_dir)

      doc_path = file.real_path
      if doc_path[0..6] = "hdfs://"
        doc_path = doc_path[7..-1]
      end
      doc_name = doc_path.split('/')[-1]
      temp_doc_path = "#{tmp_dir}#{doc_name}"

      # copy from hdfs
      cmd = "hadoop fs -copyToLocal #{doc_path} #{tmp_dir}"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, _|
        output = stdouterr.read
        if output != ""
          Log.create(message: output, status: "error",
                     subject: "FileManager::encript_file, copy file to local")
          return
        end
      end

      # Decrypt
      EncryptManager.decrypt(encryptor.cipher,
                             password,
                             temp_doc_path)

      # copy to hdfs
      cmd = "hadoop fs -copyFromLocal -f #{temp_doc_path}_dec #{doc_path}"
      Open3.popen2e(ENV, cmd) do |_, stdouterr, _|
        output = stdouterr.read
        if output != ""
          Log.create(message: output, status: "error",
                     subject: "FileManager::encript_file, copy file to hdfs")
          return
        end
      end

      File.delete(temp_doc_path)
      File.delete(temp_doc_path << "_dec")

      file.encryptor.destroy

      file.update_attributes(prepared: true)
    end

  end
end
