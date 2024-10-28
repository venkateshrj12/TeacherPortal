require 'rails_helper'

RSpec.describe "/students", type: :request do
  before(:all) do
    @teacher = create(:account)
    @student = create(:student, user_account: @teacher)
    @subjects = create_list(:subject, 5, student: @student)

    @token = ::JsonWebToken.encode(id: @teacher.id)
  end
  let(:valid_attributes) {
    attributes_for(:student).merge( subjects_attributes: [ attributes_for(:subject), attributes_for(:subject) ] ) 
  }
  
  let(:invalid_attributes) { attributes_for(:invalid_student, user_account: @teacher) }
  let(:valid_headers) { { Authorization:  @token } }

  describe "GET /index" do
    it "renders a successful response with list of students" do
      get students_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(json_response["data"]).to be_an(Array)
    end
  end

  describe "GET /show" do
    context "with valid id" do
      it "renders a successful response with a student" do
        get student_url(@student), headers: valid_headers, as: :json
        expect(response).to be_successful
        expect(json_response["data"]["attributes"]["full_name"]).to eq(@student.full_name)
      end
    end

    context "with invalid id" do
      it "renders a successful response with a student" do
        get student_url(0), headers: valid_headers, as: :json
        expect(response).to have_http_status(:not_found)
        expect(json_response["errors"]).to eq(["Student not found"])
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "renders a JSON response with the new student" do
        post students_url,
             params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Student" do
        expect {
          post students_url,
               params: invalid_attributes, as: :json
        }.to change(Student, :count).by(0)
      end

      it "renders a JSON response with errors for the new student" do
        post students_url,
             params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested student" do
        patch student_url(@student),
              params: { full_name: "New name" }, headers: valid_headers, as: :json
        @student.reload
        expect(response).to have_http_status(:ok)
        expect(@student.full_name).to eq("New name")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the student" do
        patch student_url(@student),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested student" do
      expect {
        delete student_url(@student), headers: valid_headers, as: :json
      }.to change(Student, :count).by(-1)
    end
  end
end
