class Document::LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_document, only: [:index, :index_user]
  before_action :find_user, only: :index_user
  before_action :find_log, only: :show

  def index_all
    @logs = DocumentActionLog.joins(:document) #includes(:documents, users)
                             .where(documents: { owner: current_user })
                             .order(created_at: :desc)
                             .page(params[:page])
  end

  def index
    @logs = DocumentActionLog.document(@document)
                             .order(created_at: :desc)
                             .page(params[:page])
  end

  def index_user
    @logs = DocumentActionLog.document(@document)
                             .user(@user)
                             .order(created_at: :desc)
                             .page(params[:page])
  end

  def show
  end

  private
  def find_document
    @document = Document.owned(current_user)
                        .available
                        .find_by!(iid: params[:document_iid])
  rescue
    show404
  end
  def find_user
    @user = User.find_by!(login: params[:user_login])
  rescue
    show404
  end
  def find_log
    @log = DocumentActionLog.find(params[:id])
  rescue
    show404
  end
end
