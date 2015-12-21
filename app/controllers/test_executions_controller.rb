class TestExecutionsController < ApplicationController
  before_action :set_test_execution, only: [:destroy, :show]
  before_action :set_task, only: [:new, :create, :show]
  before_action :set_product_test, only: [:show, :new]
  before_action :add_breadcrumbs, only: [:show, :new]

  def create
    @test_execution = @task.execute(params[:results])
    redirect_to "/tasks/#{@task.id}/test_executions/#{@test_execution.id}"
  rescue Mongoid::Errors::Validations
    alert = 'Invalid file upload. Please make sure you upload an XML or zip file.'
    redirect_to "/tasks/#{@task.id}/test_executions/new", flash: { alert: alert.html_safe }
  end

  def new
    if @task.most_recent_execution
      redirect_to "/tasks/#{@task.id}/test_executions/#{@task.most_recent_execution.id}"
      return
    end
    render :show
  end

  def show
  end

  def destroy
    @test_execution.destroy
    render status: 204, text: 'Deleted'
  end

  private

  def set_product_test
    @product_test = @task.product_test
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_test_execution
    @test_execution = TestExecution.find(params[:id])
  end

  def add_breadcrumbs
    add_breadcrumb @product_test.product.vendor.name, "/vendors/#{@product_test.product.vendor.id}"
    add_breadcrumb @product_test.product.name, "/vendors/#{@product_test.product.vendor.id}/products/#{@product_test.product.id}"
    add_breadcrumb @product_test.name, "/products/#{@product_test.product.id}/product_tests/#{@product_test.id}"
  end
end
