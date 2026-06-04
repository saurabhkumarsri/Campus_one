module StudentPortal
  class MessagesController < BaseController
    def inbox
      @messages = scope_query(Message).for_user(current_user.id).order(created_at: :desc).limit(50)
      @unread_count = @messages.unread.count
      @teachers = scope_query(User).where(role: "teacher").order(:name)
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
        redirect_to student_portal_chat_path(@receiver), notice: "Message sent."
      else
        redirect_back fallback_location: student_portal_inbox_path, alert: "Failed to send."
      end
    end
  end
end
