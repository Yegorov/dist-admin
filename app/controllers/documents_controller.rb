class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_document, only: [:show, :edit, :destroy]

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
  end

  def edit
    # edit name
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
end
