class PurchasesController < ApplicationController
  require 'csv'
  include ActionView::Helpers::TextHelper

  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index

    # If new purchases were just uploaded, show them

    if session[:new_ids]
      @new_purchases = Purchase.where(["id in (?)", session[:new_ids]])
      @total_uploaded_revenue = @new_purchases.sum("qty * price") if @new_purchases
      session.delete(:new_ids)
    end

    @purchases = Purchase.all
    @total_revenue = Purchase.sum("qty * price")
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render action: 'show', status: :created, location: @purchase }
      else
        format.html { render action: 'new' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :no_content }
    end
  end

  def upload_csv
    @file_errors = []

    @error_hash = {}

    if request.post?

      msg               = nil                 # Gets error msg if applicable
      recs_uploaded     = 0
      file              = params[:csvfile]
      items_added       = 0
      merchants_added   = 0
      new_purchases     = []

      begin

        unless file
            raise "No input file"
        end

        @file_name = file.original_filename

        if (@file_name =~ /.\.tab$/i)


            CSV.foreach(file.tempfile, {:headers => true, :col_sep => "\t"}) do |row|
              #Car.create(:make => row[0], :model => row[1], :year => row[2])
              #puts "#{row[0]} | #{row[1]} | #{row[2]}"
              puts CSV.generate_line(row)
              merchant, exists = Merchant.fetch_or_create(row['merchant name'], row['merchant address'])
              merchants_added += 1 unless exists
              item, exists = Item.fetch_or_create(row['item description'], row['item price'], merchant.id)
              items_added += 1 unless exists

              p = Purchase.create(  name: row.fetch('purchaser name'),
                                    price: row.fetch('item price'),
                                    item_id: item.id,
                                    qty: row.fetch('purchase count')
                                  )
              recs_uploaded += 1
              new_purchases << p.id
            end
        else
          raise "Not Tab Delimited"
        end
      rescue Exception => e
        msg = case e.to_s
                when /^Not Tab Delimited/
                  "Uploaded file is not a Tab delimited file (name should end with .tab)!"
                when /^key not found/ then
                  "Invalid Input File"
                when /^No input file/ then
                  "Please select an input file"
                else
                  "Error \"#{e.to_s}\" occured during upload. "
              end
        logger.debug msg
      end

      if msg
        flash[:error] = msg
        flash.delete(:notice)
      else
        flash[:notice] = "Uploaded #{pluralize(recs_uploaded, 'purchase')} successfully.  #{pluralize(items_added, 'item')} added. #{pluralize(merchants_added, 'merchant')} added."
        flash.delete(:error)
        session[:new_ids] = new_purchases
      end

    end


    redirect_to :action => :index

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:name, :description, :price, :qty, :merchant_address, :merchant_name)
    end
end
