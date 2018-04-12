class CheckSumManager
  class << self
    def md5(file_path)
      md5_openssl_with_handle_output(file_path)
    end

    private
    def md5_openssl(file_path)
      hash = ""
      hashAlg = 'md5'
      cmd = "openssl dgst -#{hashAlg} #{file_path}"
      output = `#{cmd}`
      begin
        hash = output.split("=")[1].strip
      rescue
        hash = ""
      end
      hash
    end

    def md5_openssl_with_handle_output(file_path)
      hash = ""
      hashAlg = 'md5'
      cmd = "openssl dgst -#{hashAlg} #{file_path}"
      Open3.popen3(cmd) do |_, stdout, stderr, _|
        output = stdout.read
        begin
          hash = output.split("=")[1].strip
        rescue
          # add error to log
          # puts stderr.read, file_path
          hash = ""
        end
      end
      hash
    end

  end
end
