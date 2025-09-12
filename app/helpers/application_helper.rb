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
   def document_type_badge(document_type)
    case document_type.to_sym
    when :id_proof
      "bg-blue-100 text-blue-800"
    when :proof_of_income
      "bg-green-100 text-green-800"
    when :employment_verification
      "bg-purple-100 text-purple-800"
    when :rental_history
      "bg-yellow-100 text-yellow-800"
    else
      "bg-gray-100 text-gray-800"
    end
   end

def user_role_badge(role)
  case role.to_sym
  when :admin
    "bg-purple-100 text-purple-800"
  when :landlord
    "bg-blue-100 text-blue-800"
  when :tenant
    "bg-green-100 text-green-800"
  else
    "bg-gray-100 text-gray-800"
  end
end

  def payment_status_class(status)
   case status.to_sym
   when :pending
        "bg-yellow-100 text-yellow-800"
   when :completed
        "bg-green-100 text-green-800"
   when :failed
        "bg-red-100 text-red-800"
   when :refunded
        "bg-blue-100 text-blue-800"
   else
        "bg-gray-100 text-gray-800"
   end
  end
end
