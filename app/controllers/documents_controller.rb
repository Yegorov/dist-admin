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
  end

  def show
  end

  def edit
  end

  def destroy
    @document.deleted = true
    @document.save
    if @document.parent_iid.present?
      redirect_to folder_documents_path(@document.parent_iid)
    else
      redirect_to documents_path
    end
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
