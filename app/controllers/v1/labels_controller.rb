class V1::LabelsController < ApplicationController
  def index
    labels = Label.all  
    render json: labels.as_json
  end

  def create
    label = Label.new(
      artist: params[:name], 
      title: params[:email], 
      media: params[:phone_number]
      )
    if label.save
      render json: label.as_json
    else
      render json: {errors: label.errors.full_messages}, status: 422
    end
  end

  def show
    id = params[:id]
    label = Label.find_by(id: id)
    render json: label.as_json
  end

  def update
    id = params[:id]
    label = Label.find_by(id: id)
    label.name = params[:name] ||  label.name
    label.email = params[:email] || label.email
    label.phone_number = params[:phone_number] || label.phone_number
    if label.save
      render json: label.as_json
    else
      render json: {errors: label.errors.full_messages}, status: 422
    end
  end

  def destroy
    id = params[:id]
    label = Label.find_by(id: id)
    label.destroy
    render json: {message: "Label successfully destroyed."}
  end

end