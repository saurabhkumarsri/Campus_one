module ApplicationHelper
  include Pagy::Frontend

  def badge_for(value)
    css = case value.to_s
          when "active", "present", "paid"
            "badge-success"
          when "inactive", "absent", "unpaid"
            "badge-danger"
          when "partial", "leave"
            "badge-warning"
          else
            "badge-neutral"
          end
    content_tag(:span, value.to_s.humanize, class: "badge #{css}")
  end

  def gender_options
    [
      ["Male", "male"],
      ["Female", "female"],
      ["Other", "other"]
    ]
  end

  def frequency_options
    [
      ["Monthly", "monthly"],
      ["Quarterly", "quarterly"],
      ["Yearly", "yearly"],
      ["One Time", "one_time"]
    ]
  end

  def status_options
    [
      ["Active", "active"],
      ["Inactive", "inactive"]
    ]
  end

  def payment_mode_options
    [
      ["Cash", "cash"],
      ["Card", "card"],
      ["Bank Transfer", "bank_transfer"],
      ["UPI", "upi"],
      ["Cheque", "cheque"]
    ]
  end

  def plan_icon(months)
    case months
    when 1 then "📅"
    when 6 then "📆"
    when 12 then "🗓️"
    else "💳"
    end
  end

  def plan_duration_label(months)
    case months
    when 1 then "Billed monthly"
    when 6 then "Billed every 6 months"
    when 12 then "Billed yearly"
    else "#{months} months"
    end
  end
end
