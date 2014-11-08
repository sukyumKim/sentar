class ConversationsController < ApplicationController

  before_action :set_user, :logged_in_user
  helper_method :mailbox, :conversation





def index
   @mailbox ||= mailbox
   @conversations = @mailbox.conversations.paginate(page: params[:page], per_page: 7  )

   
 end


 def create
  recipient_emails = conversation_params(:recipients).split(',')
  recipients = User.where(email: recipient_emails).all

  if @conversation = already_have_conversation?(recipients)
  body = conversation_params(:body)
  @user.reply_to_conversation( @conversation, body )
  
  else
  
 @conversation = @user.send_message(recipients, *conversation_params(:body, :subject)).conversation




  
end
  redirect_to conversation_path(@conversation)
end

def reply
  
  @receipt= @user.reply_to_conversation(conversation, *message_params(:body, :subject))
  

  respond_to do |format|
      format.html { redirect_to conversation_path(conversation) }
      format.js
    end
  
  
end

def show
  
  conversation.mark_as_read(@user)
  

end


def trash
  conversation.move_to_trash(@user)
  redirect_to :conversations
end

def untrash
  conversation.untrash(@user)
  redirect_to :conversations
end


def readable_off

      @user.redable_off
      
    end


private

def mailbox
  @mailbox ||= @user.mailbox
end

def conversation
  # ids = mailbox.conversations.ids
  # id = params[:id].to_i
  # if ids.include?id

  @conversation ||= mailbox.conversations.find(params[:id])

# else
#   flash[:danger] = "다른 유저들의 방은 안되여 :("
#   redirect_to conversations_path
# end

end

def conversation_params(*keys)
  fetch_params(:conversation, *keys)
end

def message_params(*keys)
  fetch_params(:message, *keys)
end


def already_have_conversation?(recipients)

  conversations = mailbox.conversations
  conversations.each do |conversation|
    participants = conversation.participants
    participants.delete(@user)
    if recipients == participants
      @conversation = conversation
      return @conversation
    end

  end
  
  return false
  
end



  


def fetch_params(key, *subkeys)
  params[key].instance_eval do
    case subkeys.size
    when 0 then self
    when 1 then self[subkeys.first]
    else subkeys.map{|k| self[k] }
    end
  end
end

def correct_user
  unless conversation
    flash[:danger] = "잘 못된 접근 :("
      redirect_to conversations_path

    end
  end


def set_user
@user ||= current_user
end


end