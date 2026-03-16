class ExpensesController < ApplicationController
  before_action :set_trip

  def index
    @expenses = @trip.expenses #toate expenses
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.trip_id = @trip.id #corelam expenseul cu tripul

    # la trip ar trebui ca payer sa fie unul dintre participanti.
    # un dropdown cu toti participantii din trip.

    if @expense.save
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @expense = @trip.expenses.find(params[:id]) 
  end

  def edit
    @expense = @trip.expenses.find(params[:id]) #show la un singur expense, nu la toate
    authorize @expense
  end

  def update
    @expense = @trip.expenses.find(params[:id])
    authorize @expense 

    if @expense.update(expense_params)
      redirect_to trip_expense_path(@trip, @expense), notice: "Expense updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense = @trip.expenses.find(params[:id]) #show la un singur expense, nu la toate
    authorize @expense
    @expense.destroy

    redirect_to trip_path(@trip), notice: "Expense deleted successfully."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def expense_params
    # :payer_id, :creator_id trebuie adaugati din form
    params.require(:expense).permit(:title, :amount, :currency, :date, :split_type)
  end
end