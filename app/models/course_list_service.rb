# frozen_string_literal: true

# Service to transform a course with distributed students to a xslx spreadsheet
class CourseListService
  FONT              = 'Arial'
  FONT_BIG_SIZE     = 14
  FONT_REGULAR_SIZE = 10
  FONT_SMALL_SIZE   = 8
  attr_accessor :course

  def initialize(course_id)
    @course = Course.find(course_id)
  end

  def to_xlsx
    set_column_widths
    write_headline
    write_course_details
    write_student_list
    write_students
    merge_date_fields
    write_borders
    fill_with_colors
    write_footer
    set_printer
    workbook.close
    io.rewind

    io.read
  end

  private

  def io
    @io ||= StringIO.new
  end

  def workbook
    @workbook ||= WriteXLSX.new(io)
  end

  def worksheet
    @worksheet ||= workbook.add_worksheet
  end

  def format_big_bold
    return @format_big_bold if @format_big_bold

    @format_big_bold = workbook.add_format
    @format_big_bold.set_font(FONT)
    @format_big_bold.set_bold
    @format_big_bold.set_size(FONT_BIG_SIZE)

    @format_big_bold
  end

  def format_big_regular
    return @format_big_regular if @format_big_regular

    @format_big_regular = workbook.add_format
    @format_big_regular.set_font(FONT)
    @format_big_regular.set_size(FONT_BIG_SIZE)

    @format_big_regular
  end

  def format_big_regular_border
    return @format_big_regular_border if @format_big_regular_border

    @format_big_regular_border = workbook.add_format
    @format_big_regular_border.set_font(FONT)
    @format_big_regular_border.set_size(FONT_BIG_SIZE)
    @format_big_regular_border.set_border(1)

    @format_big_regular_border
  end

  def format_big_regular_right
    return @format_big_regular_right if @format_big_regular_right

    @format_big_regular_right = workbook.add_format
    @format_big_regular_right.set_font(FONT)
    @format_big_regular_right.set_size(FONT_BIG_SIZE)
    @format_big_regular_right.set_align('right')
    @format_big_regular_right.set_border(1)

    @format_big_regular_right
  end

  def format_normal_bold_centered
    return @format_normal_bold_centered if @format_normal_bold_centered

    @format_normal_bold_centered = workbook.add_format
    @format_normal_bold_centered.set_font(FONT)
    @format_normal_bold_centered.set_bold
    @format_normal_bold_centered.set_size(FONT_REGULAR_SIZE)
    @format_normal_bold_centered.set_align('center')
    @format_normal_bold_centered.set_align('vcenter')
    @format_normal_bold_centered.set_border(1)

    @format_normal_bold_centered
  end

  def format_normal_bold
    return @format_normal_bold if @format_normal_bold

    @format_normal_bold = workbook.add_format
    @format_normal_bold.set_font(FONT)
    @format_normal_bold.set_bold
    @format_normal_bold.set_size(FONT_REGULAR_SIZE)

    @format_normal_bold
  end

  def format_normal_bold_border
    return @format_normal_bold_border if @format_normal_bold_border

    @format_normal_bold_border = workbook.add_format
    @format_normal_bold_border.set_font(FONT)
    @format_normal_bold_border.set_bold
    @format_normal_bold_border.set_size(FONT_REGULAR_SIZE)
    @format_normal_bold_border.set_border(1)

    @format_normal_bold_border
  end

  def format_yellow
    return @format_yellow if @format_yellow

    @format_yellow = workbook.add_format
    @format_yellow.set_font(FONT)
    @format_yellow.set_bold
    @format_yellow.set_size(FONT_REGULAR_SIZE)
    @format_yellow.set_border(1)
    @format_yellow.set_bg_color('#ffff99')
    @format_yellow.set_align('center')

    @format_yellow
  end

  def format_small_right
    return @format_small_right if @format_small_right

    @format_small_right = workbook.add_format
    @format_small_right.set_font(FONT)
    @format_small_right.set_size(FONT_SMALL_SIZE)
    @format_small_right.set_align('right')

    @format_small_right
  end

  def set_column_widths
    worksheet.set_column('A:A', 4)
    worksheet.set_column('B:B', 22.1)
    worksheet.set_column('C:C', 10.4)
    worksheet.set_column('D:Z', 4)
  end

  def write_headline
    worksheet.merge_range('A1:L1', course.poll.title, format_big_bold)
    worksheet.merge_range('M1:Z1', 'SEMESTER', format_big_regular)
  end

  def write_course_details
    worksheet.merge_range('A3:B3', 'Nr.', format_normal_bold_centered)
    worksheet.merge_range('C3:H3', 'LehrerIn', format_normal_bold_centered)
    worksheet.merge_range('C4:H4', course.teacher_name, format_normal_bold_centered)
    worksheet.merge_range('I3:Z3', 'Bezeichnung', format_normal_bold_centered)
    worksheet.merge_range('I4:Z4', course.title, format_normal_bold_centered)
  end

  def write_student_list
    worksheet.merge_range('B6:B7', 'TeilnehmerIn', format_normal_bold_centered)
    worksheet.write('C6', 'Datum:', format_normal_bold_centered)
    worksheet.write('C7', 'Klasse:', format_normal_bold_border)
    worksheet.merge_range('X6:Z6', 'Gesamt', format_yellow)
    worksheet.write('X7', 'E', format_yellow)
    worksheet.write('Y7', '|', format_yellow)
    worksheet.write('Z7', 'X', format_yellow)
  end

  def merge_date_fields
    worksheet.merge_range('A6:A7', '', format_normal_bold_centered)
    ('D'..'W').to_a.each do |col|
      worksheet.merge_range("#{col}6:#{col}7", '', format_normal_bold_centered)
    end
  end

  def write_students
    course.students.sort_by { |s| [s.grade.name, s.last_name, s.first_name] }.each_with_index do |student, index|
      worksheet.write("A#{8 + index}", "#{index + 1}.", format_big_regular_right)
      worksheet.write("B#{8 + index}", student.full_name, format_normal_bold_border)
      worksheet.write("C#{8 + index}", student.grade.name, format_normal_bold_border)
    end
  end

  def write_borders
    worksheet.merge_range('A4:B4', '', format_normal_bold_centered)
    (8..(course.students.length + 7)).to_a.each do |row|
      ('D'..'W').to_a.each do |col|
        worksheet.write("#{col}#{row}", '', format_normal_bold_centered)
      end
    end
  end

  def fill_with_colors
    (8..(course.students.length + 7)).to_a.each do |row|
      worksheet.write("X#{row}", '', format_yellow)
      worksheet.write("Y#{row}", '', format_yellow)
      worksheet.write("Z#{row}", '', format_yellow)
    end
  end

  def write_footer
    row_last_student = course.students.length + 8

    worksheet.merge_range("A#{row_last_student}:B#{row_last_student}", 'E = entschuldigt', format_normal_bold)
    worksheet.merge_range("C#{row_last_student}:T#{row_last_student}",
                          'Bitte zählen Sie die Fehlzeiten rechtzeitig vor Ende des Halbjahres zusammen, damit sie',
                          format_normal_bold)
    worksheet.merge_range("A#{row_last_student + 1}:B#{row_last_student + 1}", '| = unentschuldigt', format_normal_bold)
    worksheet.merge_range("C#{row_last_student + 1}:T#{row_last_student + 1}",
                          'der Klassenleitung bei der Zensurenkonferenz zur Verfügung stehen.', format_normal_bold)
    worksheet.merge_range("A#{row_last_student + 2}:B#{row_last_student + 2}", 'X = anwesend', format_normal_bold)
    worksheet.merge_range("C#{row_last_student + 2}:T#{row_last_student + 2}",
                          'Nutzen Sie hierzu bitte die grauen Kästchen.', format_normal_bold)
    worksheet.merge_range("V#{row_last_student + 2}:Z#{row_last_student + 2}",
                          "erstellt am #{I18n.l Time.zone.today}", format_small_right)
  end

  def set_printer
    last_row = course.students.length + 10

    worksheet.hide_gridlines(1)
    worksheet.paper = 9
    worksheet.set_landscape
    worksheet.fit_to_pages(1, 1)
    worksheet.print_area("A1:Z#{last_row}")
  end

end
