class NotificationMailer < ApplicationMailer
  default from: "PropertyRental <notifications@propertyrental.com>"

  def new_message_email(message)
    @message = message
    @conversation = message.conversation
    @recipient = @conversation.other_participant(message.user)

    mail(
      to: @recipient.email,
      subject: "New message from #{message.user.profile&.full_name || message.user.email}"
    )
  end

  def application_status_email(application)
    @application = application
    @tenant = application.tenant
    @property = application.property

    mail(
      to: @tenant.email,
      subject: "Your application for #{@property.title} has been #{application.status}"
    )
  end

  def payment_receipt_email(payment)
    @payment = payment
    @tenant = payment.rental_application.tenant
    @property = payment.rental_application.property

    mail(
      to: @tenant.email,
      subject: "Payment receipt for #{@property.title}"
    )
  end

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to PropertyRental!"
    )
  end

  def landlord_application_notification(application)
    @application = application
    @landlord = application.property.landlord
    @property = application.property

    mail(
      to: @landlord.email,
      subject: "New rental application for #{@property.title}"
    )
  end
end
