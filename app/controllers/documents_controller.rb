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
  end

  def create_file
  end

  def new_folder
    # show form for create folder
  end
  def create_folder
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
