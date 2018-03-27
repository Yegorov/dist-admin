class PermissionsController < ApplicationController
  include PermissionsHelper

  before_action :authenticate_user!
  before_action :find_document, only: [:index, :index_show, :show, :new, :create, :edit, :update]
  before_action :find_user, only: [:index_show, :edit, :update]
  #before_action :find_permission, only: [:update, :destroy]
  before_action :set_before_create, only: :create

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
    @allowed_permissions = DocumentPermission.document(@document)
                                             .user(@user)

    @permission = DocumentPermission.document(@document)
                                   .user(@user)
                                   .action(@action)
    if @permission.blank?
      # check dublicates actions in tree
      @allowed_permissions.each do |allowed_permission|
        if @action.class.descendants?(allowed_permission.action.class)
          allowed_permission.destroy
        end
      end
      @permission = DocumentPermission.new
      @permission.action = @action
      @permission.user = @user
      @permission.document = @document
      @permission.save
      flash[:info] = "Permission successfuly created!"
      redirect_to index_show_document_permissions_url(@document.iid, @user.login)
    else
      flash[:info] = "Permission is exist, try to edit!"
      redirect_to index_show_document_permissions_url(@document.iid, @user.login)
    end

  end

  def edit
    @permissions = DocumentPermission.document(@document)
                                     .user(@user)
                                     .to_a
    @actions = Action.to_hash

    @permissions_for_input = @permissions.map { |p| p.action.id }.join(',')
    @action_tree_json = get_action_tree(@actions, @permissions).to_json

  end

  def update
    @actions = params[:permission_actions]
                .split(',')
                .map { |a| DocumentPermission.actions[a.to_i] }
                .compact

    @permissions = DocumentPermission.document(@document)
                                     .user(@user)
                                     .to_a
    @exists_actions = @permissions.map { |a| a.action }

    deletes = @exists_actions - @actions
    adds = @actions - @exists_actions

    # Deletes
    deletes.each do |action_for_delete|
      @permissions.select { |p| p.action.id == action_for_delete.id }.each do |p|
        p.destroy
      end
      @exists_actions.delete(action_for_delete)
    end

    adds_paths = []
    adds.each do |action_for_add|
    # path to root
    ancestors = action_for_add.class
                              .ancestors
                              .take_while { |klass| klass != Action }
                              .map { |klass| klass.new }
      adds_paths << ancestors
    end
    adds_paths.sort_by { |arr| arr.count }

    # Adds
    adds_paths.each do |ancestors|
      # intersect array
      if (ancestors & @exists_actions).blank?
        DocumentPermission.create(document: @document,
                                  user: @user,
                                  action: ancestors.first)
        @exists_actions << ancestors.first
      end
    end

    redirect_to request.referrer
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

  def set_before_create
    @action = DocumentPermission.actions[params[:document_permission][:action].to_i]
    @user = User.available.find(params[:document_permission][:user_id])
  end

  def document_permission_params
    params.require(:document_permission).permit(:user_id, :action)
  end
end
