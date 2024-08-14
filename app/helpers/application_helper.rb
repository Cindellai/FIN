module ApplicationHelper
  def alert_class_for(flash_type)
    {
      notice: "bg-blue-500",
      alert: "bg-red-500",
      error: "bg-red-500",
      success: "bg-green-500"
    }.stringify_keys[flash_type.to_s] || "bg-gray-500"
  end
end
