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
    # find the student and subecjts in db
    @student = Student.find_by(full_name: student_params[:full_name], subject: student_params[:subject])

    if  @student
      # update if record is available
      @student.update(marks:  student_params[:marks])
    else
      # create new record if record is not available
      @student = Student.new(student_params)
      unless @student.save
        return render json: {errors: @student.errors.full_messages}, status: :unprocessable_entity
      end
    end

    render json: StudentSerializer.new(@student).serializable_hash, status: :created
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
    def student_params
      params.permit(:full_name, :subject, :marks).merge(user_account: @current_user)
    end
end
