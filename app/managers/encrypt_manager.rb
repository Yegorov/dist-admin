class EncryptManager
  class << self
    def encrypt(ciphername, password, file_path, out_file_path=nil)
      outfile = ""
      if File.exists?(file_path)
        outfile = out_file_path ? out_file_path : file_path + "_enc"

        #cmd = "openssl enc -#{ciphername} -e -in #{file_path} -out #{outfile} -pass pass:#{password}"
        cmd = "openssl enc -#{ciphername} -e -in #{file_path} -out #{outfile} -pass stdin"

        Open3.popen3(cmd) do |stdin, _, stderr, _|
          stdin.puts(password)
          output = stderr.read

          if output != ""
            #puts output # to log
            "Stderr: " << output

            outfile = ""
          end

        end


      else
        # add to log
      end
      outfile
    end
    def decrypt(ciphername, password, file_path, out_file_path=nil)
      outfile = ""
      if File.exists?(file_path)
        outfile = file_path + "_dec"
        if file_path[-4..-1] == '_enc'
          outfile = file_path[0..-5]
        end
        outfile = out_file_path ? out_file_path : outfile

        cmd = "openssl enc -#{ciphername} -d -in #{file_path} -out #{outfile} -pass stdin"
        #puts cmd

        Open3.popen3(cmd) do |stdin, _, stderr, _|
          stdin.puts(password)
          output = stderr.read

          if output != ""
            # puts output # to log
            "Stderr: " << output
            # if output.include?("bad decrypt") || output.include?('error')
            begin
              File.delete(outfile)
            rescue
            end
            outfile = ""
          end

        end

      else
        # add to log
      end
      outfile
    end
  end
end
