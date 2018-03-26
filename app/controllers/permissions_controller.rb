class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_document, only: [:index, :index_show, :show, :new, :edit, :update]
  before_action :find_user, only: [:index_show, :edit]
  #before_action :find_permission, only: [:update, :destroy]

  def index
    @permissions = DocumentPermission.document(@document)
                                     .select("document_permissions.*, \
                                             MAX(updated_at) as last_updated_at")
                                     .order(user_id: :asc)
                                     .group(:user_id)
                                     .page(params[:page])
  end

  # index page for special user
  def index_show
    @permissions = DocumentPermission.document(@document)
                                     .user(@user)
  end

  def show
  end

  def new
    @permission = DocumentPermission.new
    @users = User.available.where.not(id: current_user.id).first(100).map { |u| [u.name, u.id] }
    @actions = Action.all.map {|action_class| [action_class.title, action_class.id] }
  end

  def create
    binding.pry
  end

  def edit
    @permissions = DocumentPermission.document(@document)
                                     .user(@user)
  end

  def update
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
    @user = User.available.find_by!(login: params[:user_login])
  rescue
    show404
  end
  # def find_permission
  #   @permission = DocumentPermission.document(@document)
  #                                   .find(params[:id])
  # rescue
  #   show404
  # end
end
