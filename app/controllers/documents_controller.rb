require 'securerandom'

class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = Document.order(name: :asc)
                         .owned(current_user)
                         .available
                         .page(params[:page])
    if params[:folder]
      @document = Document.owned(current_user)
                          .find_by(iid: params[:folder])
      if @document && @document.folder?
        @documents = @documents.in_folder(@document)
      else
        show404
      end
    else
      @documents = @documents.roots
    end

    @to = @document.present? ? @document.iid : "root"
  end

  def show
    @parent_document = @document.parent
    @owner = @document.owner
    @creator = @document.creator
  end

  def edit
    # edit name
    # edit owner
    @original_document = @document
  end
  def update
    error = nil
    message = nil

    if @document.file? && (@document.encrypted?.to_s != params[:encrypt])
      if params[:password].present?
        # Encrypt/Decrypt file
        if params[:encrypt] == 'true'
        # encrypt file with params[:password]
        message = "The file will be encrypted, but now it's not available!"
        elsif params[:encrypt] == 'false'
          # decrypt file with params[:password]
          # check password in encryptor
          if @document.encryptor.verify_pass_phrase(params[:password])
            # validation is ok!
            message = "The file will be available after the decryption!"
          else
            error = "Error password for decrypt!"
          end
        else
          error = "Unknown encrypt param value!"
        end
      else
        error = "You need set a password!"
      end
    end

    if @document.update(update_document_params) && error.blank?
      flash[:info] = message if message
      redirect_to document_path(@document.iid)
    else
      @original_document = @document.clone.reload
      flash.now[:danger] = error if error
      render 'edit'
    end
  end

  def destroy
    # sofyt delete
    @document.deleted = true
    @document.save
    if @document.parent_iid.present?
      redirect_to folder_documents_path(@document.parent_iid)
    else
      redirect_to documents_path
    end
  end

  def new_file
    # show form for upload file
    # params[:to]
    @unique_id = [current_user.login, SecureRandom.hex(20), Time.now.to_i.to_s].join("_")
  end

  def create_file
    #binding.pry
    # check params and return status 400
    if params[:start].blank? || params[:end].blank?
       params[:size].blank? || params[:unique_id].blank?
       params[:file].blank?
       render plain: "", status: 400 and return
    end

    _unique_id = params[:unique_id]
    _start = params[:start].to_i
    _end = params[:end].to_i
    _size = params[:size].to_i

    @upload_file = UploadFile.find_by(unique_id: _unique_id)

    if @upload_file.nil? && _start == 0
      @upload_file = UploadFile.create! do |uf|
        uf.file_name = params[:file_name] || "file"
        uf.size = _size
        uf.current_size = _start
        uf.unique_id = _unique_id
        uf.path = "/tmp/#{_unique_id}"
        uf.user = current_user
        uf.to = params[:to] || "root"
      end
    end

    if @upload_file.present?
      if @upload_file.current_size != _start
        render plain: "", status: 400 and return
      end

      File.open @upload_file.path, "ab" do |f|
        f.write(params[:file].read)
      end

      @upload_file.current_size = _end
      @upload_file.save!

      render plain: "", status: 200 and return
    end

    render plain: "", status: 400
  rescue
    render plain: "", status: 400
  end

  def new_folder
    # show form for create folder
  end
  def create_folder
    to = params[:to].presence || 'root'
    parent = to == 'root' ? nil : Document.owned(current_user)
                                          .available
                                          .find_by(iid: to)
    if params[:folder_name].present?
      @document = FileEntity::Folder.mk_dir(name: params[:folder_name],
                                            real_path: "/",
                                            user: current_user,
                                            parent: parent)
      @document.prepared = true
      if @document.save
        flash[:success] = "Folder created successfull."
        redirect_to document_path(@document.iid)
      else
        flash.now[:error] = @document.errors.full_messages.join('. ')
        render 'new_folder'
      end
    else
      raise "Folder name not present!"
    end
  rescue Exception => e
    #binding.pry
    flash.now[:error] = "Error, try again!"
    render 'new_folder'
  end

  private
  def find_document
    @document = Document.owned(current_user)
                        .available
                        .find_by!(iid: params[:iid])
  rescue
    show404
  end
  def update_document_params
    params.require(:document).permit(:name)
  end
end
