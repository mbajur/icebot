# typed: false
module Panel
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project, only: [:show, :edit, :update, :destroy]

    # GET /projects
    # GET /projects.json
    def index
      @projects = current_user.projects
    end

    # GET /projects/1
    # GET /projects/1.json
    def show
    end

    # GET /projects/new
    # def new
    #   @project = Project.new
    #   authorize @project
    # end

    # GET /projects/new
    def new_github
      @project = Project.new
      authorize @project

      if current_user.oauth_authorizations&.first&.credentials
        client = Octokit::Client.new(access_token: current_user.oauth_authorizations.first.credentials['token'])
        @repos = client.repos(type: 'public', sort: :created)
      else
        @repos = []
      end
    end

    # GET /projects/1/edit
    def edit
      authorize @project
    end

    # POST /projects
    # POST /projects.json
    def create
      client = Octokit::Client.new(access_token: current_user.oauth_authorizations.first.credentials['token'])
      repo = client.repo(project_params[:id].to_i)

      @project = Project.new(
        name:        repo.name,
        full_name:   repo.full_name,
        external_id: repo.id,
        provider:    :github
      )
      authorize @project
      @project.user = current_user

      if @project.save
        redirect_to [:panel, @project], notice: 'Project was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /projects/1
    # PATCH/PUT /projects/1.json
    def update
      authorize @project

      if @project.update(project_params)
        redirect_to [:panel, @project], notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /projects/1
    # DELETE /projects/1.json
    def destroy
      authorize @project
      @project.destroy
      redirect_to panel_projects_url, notice: 'Project was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:id)
    end
  end
end
