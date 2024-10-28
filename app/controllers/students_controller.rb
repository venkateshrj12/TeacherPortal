class StudentsController < ApplicationController
  before_action :validate_jwt
  before_action :set_student, only: %i[ show update destroy ]

  # GET /students
  def index
    @students = Student.where(user_account: @current_user).page(@page).per(@per_page)
    pagination_details = pagination_details(@students)
      
    render json: {
      pagination_details: pagination_details,
      data: StudentSerializer.new(@students).serializable_hash[:data]
    }
  end

  # GET /students/1
  def show
    render json: StudentSerializer.new(@student).serializable_hash
  end

  # POST /students
  def create
    @student = Student.new(student_params)

    if @student.save
      render json: StudentSerializer.new(@student).serializable_hash, status: :created
    else
      render json: {errors: @student.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
      render json: StudentSerializer.new(@student).serializable_hash
    else
      render json: @student.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy!
    render json: {messages: ["Student record deleted succesfully"]}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.where(user_account: @current_user).find_by_id(params[:id])

      unless @student
        render json: {errors: ["Student not found"]}, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    # use subjects_attributes to accept nested attributes
    def student_params
      params.permit(:full_name, subjects_attributes: [:id, :name, :marks, :_destroy]).merge(user_account: @current_user)
    end
end
