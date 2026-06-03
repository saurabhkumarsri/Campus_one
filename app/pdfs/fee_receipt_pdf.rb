class FeeReceiptPdf
  def initialize(fee_collection)
    @fee = fee_collection
    @student = fee_collection.student
    @school = @student.school
  end

  def render
    Prawn::Document.new(page_size: "A5", margin: 30) do |pdf|
      pdf.font_size(20) { pdf.text "FEE RECEIPT", style: :bold, align: :center }
      pdf.move_down 5
      pdf.font_size(10) { pdf.text @school.name, align: :center }
      pdf.move_down 20

      pdf.stroke_color "000000"
      pdf.stroke_horizontal_rule
      pdf.move_down 15

      data = [
        ["Receipt No:", @fee.receipt_no],
        ["Date:", @fee.paid_date&.strftime("%d %b %Y") || "N/A"],
        ["Student:", @student.name],
        ["Class:", @student.classroom&.name || "N/A"],
        ["Fee Type:", @fee.fee_structure.name],
        ["Amount Paid:", "Rs. #{@fee.amount}"],
        ["Payment Mode:", @fee.payment_mode.to_s.humanize],
        ["Status:", @fee.status.humanize]
      ]

      data.each do |label, value|
        pdf.font_size(11)
        pdf.text "<b>#{label}</b>  #{value}", inline_format: true
        pdf.move_down 6
      end

      pdf.move_down 20
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      pdf.font_size(9) { pdf.text "This is a computer generated receipt and does not require signature.", align: :center, style: :italic }
    end.render
  end
end
