class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations.includes(:property, :sender, :recipient, messages: :user)
                                 .order(updated_at: :desc)
    authorize @conversations
  end

  def show
    @conversation = Conversation.includes(:property, :sender, :recipient, messages: :user).find(params[:id])
    authorize @conversation
    @conversation.mark_as_read(current_user)
    @message = Message.new
  end

  def create
    recipient = User.find(params[:recipient_id])
    property = Property.find(params[:property_id]) if params[:property_id]

    @conversation = Conversation.between(current_user.id, recipient.id, property&.id).first ||
                    Conversation.create!(sender: current_user, recipient: recipient, property: property)

    authorize @conversation
    redirect_to conversation_path(@conversation)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:recipient_id, :property_id)
  end
end
