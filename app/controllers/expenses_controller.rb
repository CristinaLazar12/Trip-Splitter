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
    if @expense.save
      #1. trebuie adaugati useri la expense dupa ce se creeaza expensul
      #2. userii trebuie sa existe deja in trip
      #3. imi trebuie user_ids ca sa creez expense_users; deci parcurgem prin useri cu ecah do si apoi pentru fiecare
      # user_id creez un expenseuser
      params[:expense][:user_ids].each do |user_id|
        next if user_id.blank?
        ExpensesUser.create!(
        expense_id: @expense.id,
        user_id: user_id
      )
      end 

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
    params.require(:expense).permit(:title, :amount, :currency, :date, :split_type, :payer_id)
  end

end
