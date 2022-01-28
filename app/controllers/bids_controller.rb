class BidsController < ApplicationController
  before_action :set_bid, only: %i[ show update destroy ]

  # GET /bids
  def index
    @bids = Bid.all

    render json: @bids
  end

  # GET /bids/1
  def show
    render json: @bid
  end

  # POST /bids
  def create
    @bid = Bid.new(bid_params)
    potential_bid = Bid.find_by(owner: @bid.owner, post_id: @bid.post_id)
    puts 'found it!'
    if potential_bid
      if potential_bid.update(pay: @bid.pay, notes: @bid.notes)
        puts 'saved it!'
        render json: BidSerializer.to_hal(potential_bid)
      else
        render json: potential_bid.errors, status: :unprocessable_entity
      end
      return
    end

    if @bid.save
      render json: BidSerializer.to_hal(@bid), status: :created, location: @bid
    else
      render json: @bid.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bids/1
  def update
    if @bid.update(bid_params)
      render json: BidSerializer.to_hal(@bid)
    else
      render json: @bid.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bids/1
  def destroy
    @bid.destroy
  end

  def open_post_bids
    post = params[:post_id]
    bids = Bid.where(post_id: post)
    render json: BidSerializer.to_collection(bids)
  end

  def accept_bid
    bids = Bid.where(post_id: params[:post_id])
    accepted_bid_id = params[:bid_id]
    bids.each do |bid|
      if bid.id == accepted_bid_id
        bid.update(accepted: true)
        bid_notification = create_bid_notifications(bid)
      else
        create_rejected_bid(bid.attributes)
        Bid.destroy(bid.id)
      end
      render json: nil, status: :ok
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bid
    @bid = Bid.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bid_params
    params.require(:bid).permit(:pay, :notes, :post_id, :owner)
  end
  def create_bid_notifications(bid)
    Notification.create(
      subject: "Bid for Post #{bid.post.hash_id} accepted",
      message: "Your bid for post titled #{bid.post.title}, marker: #{bid.post.hash_id} has "\
          "been accepted. Please contact #{bid.post.owner} for arrangements",
      owner: bid.owner
    )
  end
end
