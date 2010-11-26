﻿class Admin::LecturesController < ApplicationController
  respond_to :html,:js

  def index
    @lectureable = find_lectureable
    @lectures = @lectureable.lectures
  end

  def create
    @lectureable = find_lectureable
    @lecture = @lectureable.lectures.build(params[:lecture])
    if @lecture.save
      flash[:notice] = "Successfully created lecture."
    else
      render :action => 'new'
    end
  end

  def destroy
    @lectureable = find_lectureable
    @lecture = @lectureable.lectures.find(params[:id])
    @lecture_id = "lecture_#{@lecture.id}"
    if @lecture.destroy
      flash[:notice] = "Successfully deleted"
    end
  end

  private

  def find_lectureable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end