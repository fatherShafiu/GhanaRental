class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(:notifiable).recent
    authorize @notifications
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    authorize @notification
    @notification.mark_as_read

    respond_to do |format|
      format.html { redirect_to notifications_path, notice: "Notification marked as read" }
      format.turbo_stream
    end
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read: true)

    respond_to do |format|
      format.html { redirect_to notifications_path, notice: "All notifications marked as read" }
      format.turbo_stream
    end
  end
end
