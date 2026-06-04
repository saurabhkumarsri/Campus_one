module SchoolAdmin
  class MessagesController < BaseController
    include SchoolScope

    def inbox
      @messages = scope_query(Message).for_user(current_user.id).order(created_at: :desc).limit(50)
      @unread_count = @messages.unread.count
      @recent_conversations = User.where(id: @messages.pluck(:sender_id, :receiver_id).flatten.uniq - [current_user.id]).limit(20)
    end

    def chat
      @other_user = scope_query(User).find(params[:id])
      @messages = scope_query(Message).between(current_user.id, @other_user.id).order(:created_at)
      @messages.where(receiver_id: current_user.id, read_at: nil).update_all(read_at: Time.current)
    end

    def send_message
      @receiver = scope_query(User).find(params[:receiver_id])
      @message = scope_query(Message).new(
        sender: current_user,
        receiver: @receiver,
        content: params[:content]
      )
      if @message.save
        redirect_to school_admin_chat_path(@receiver), notice: "Message sent."
      else
        redirect_back fallback_location: school_admin_inbox_path, alert: "Failed to send message."
      end
    end
  end
end
