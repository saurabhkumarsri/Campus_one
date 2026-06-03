class IdCardPdf
  def initialize(student)
    @student = student
  end

  def render
    Prawn::Document.new(page_size: [280, 420], margin: 20) do |pdf|
      pdf.fill_color "2563eb"
      pdf.fill_rectangle [0, pdf.bounds.top], pdf.bounds.width, 60

      pdf.fill_color "ffffff"
      pdf.font_size(16) { pdf.text_box "CAMPUS ONE", at: [0, pdf.bounds.top - 15], width: pdf.bounds.width, align: :center }
      pdf.font_size(10) { pdf.text_box "Student ID Card", at: [0, pdf.bounds.top - 35], width: pdf.bounds.width, align: :center }

      pdf.fill_color "0f172a"
      pdf.move_down 70

      pdf.bounding_box([70, pdf.cursor], width: 100, height: 100) do
        pdf.stroke_color "e2e8f0"
        pdf.stroke_bounds
        pdf.font_size(20) { pdf.text_box "PHOTO", at: [0, pdf.cursor], width: 100, align: :center }
      end

      pdf.move_down 10

      pdf.font_size(10)
      info = [
        ["Name:", @student.name],
        ["Roll No:", @student.roll_no || "N/A"],
        ["Class:", @student.classroom&.name || "N/A"],
        ["Section:", @student.section&.name || "N/A"],
        ["Father:", @student.father_name || "N/A"],
        ["Mobile:", @student.mobile || "N/A"],
      ]

      info.each do |label, value|
        pdf.text "<b>#{label}</b> #{value}", inline_format: true
        pdf.move_down 4
      end

      pdf.move_down 10
      pdf.stroke_color "2563eb"
      pdf.stroke_horizontal_rule
      pdf.move_down 5
      pdf.font_size(8) { pdf.text "This card is the property of Campus One. If found, please return to the school office.", align: :center }
    end.render
  end
end
