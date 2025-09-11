module ApplicationHelper
  include Pagy::Frontend

  def application_status_class(status)
    case status.to_sym
    when :pending
      "bg-yellow-100 text-yellow-800"
    when :approved
      "bg-green-100 text-green-800"
    when :rejected
      "bg-red-100 text-red-800"
    when :withdrawn
      "bg-gray-100 text-gray-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
