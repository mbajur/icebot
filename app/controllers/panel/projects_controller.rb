module Panel
  class ProjectsController < ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy]

    # GET /projects
    # GET /projects.json
    def index
      @projects = Project.all
    end

    # GET /projects/1
    # GET /projects/1.json
    def show
    end

    # GET /projects/new
    def new
      @project = Project.new
    end

    # GET /projects/1/edit
    def edit
    end

    # POST /projects
    # POST /projects.json
    def create
      @project = Project.new(project_params)
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
      if @project.update(project_params)
        redirect_to [:panel, @project], notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /projects/1
    # DELETE /projects/1.json
    def destroy
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
      params.require(:project).permit(:name)
    end
  end
end
