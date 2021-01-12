# frozen_string_literal: true

# Service to transform a course with distributed students to a xslx spreadsheet
class CourseListService
  FONT              = 'Arial'
  FONT_BIG_SIZE     = 14
  FONT_REGULAR_SIZE = 10
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

  def format_orange
    return @format_orange if @format_orange

    @format_orange = workbook.add_format
    @format_orange.set_font(FONT)
    @format_orange.set_bold
    @format_orange.set_size(FONT_REGULAR_SIZE)
    @format_orange.set_border(1)
    @format_orange.set_bg_color('#ffcc99')
    @format_orange.set_align('center')

    @format_orange
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

  def set_column_widths
    worksheet.set_column('A:A', 4)
    worksheet.set_column('B:B', 22.1)
    worksheet.set_column('C:C', 6.5)
    worksheet.set_column('D:AA', 4)
  end

  def write_headline
    worksheet.merge_range('A1:L1', 'Arbeitsgemeinschaften / Halbjahr', format_big_bold)
    worksheet.merge_range('M1:AA1', course.poll.title, format_big_regular)
  end

  def write_course_details
    worksheet.write('A3', 'Nr.', format_normal_bold_centered)
    worksheet.write('B3', 'LehrerIn', format_normal_bold_centered)
    worksheet.write('B4', course.teacher_name, format_normal_bold_centered)
    worksheet.merge_range('C3:H3', 'Bezeichnung', format_normal_bold_centered)
    worksheet.merge_range('C4:H4', course.title, format_normal_bold_centered)
  end

  def write_student_list
    worksheet.merge_range('B6:B7', 'TeilnehmerIn', format_normal_bold_centered)
    worksheet.write('C6', 'Datum:', format_normal_bold_centered)
    worksheet.write('C7', 'Klasse:', format_normal_bold_border)
    worksheet.write('Y6', 'Note', format_orange)
    worksheet.merge_range('Z6:AA6', 'Fehlzeiten', format_yellow)
    worksheet.write('Z7', 'E', format_yellow)
    worksheet.write('AA7', 'UE', format_yellow)
  end

  def merge_date_fields
    worksheet.merge_range('A6:A7', '', format_normal_bold_centered)
    ('D'..'X').to_a.each do |col|
      worksheet.merge_range("#{col}6:#{col}7", '', format_normal_bold_centered)
    end
  end

  def write_students
    course.students.sort_by { |s| [s.grade.name, s.last_name, s.first_name] }.each_with_index do |student, index|
      worksheet.write("A#{8 + index}", "#{index + 1}.", format_big_regular_right)
      worksheet.write("B#{8 + index}", student.full_name, format_big_regular_border)
      worksheet.write("C#{8 + index}", student.grade.name, format_normal_bold_border)
    end
  end

  def write_borders
    worksheet.write('A4', '', format_normal_bold_centered)
    (8..(course.students.length + 7)).to_a.each do |row|
      ('D'..'X').to_a.each do |col|
        worksheet.write("#{col}#{row}", '', format_normal_bold_centered)
      end
    end
  end

  def fill_with_colors
    worksheet.write('Y7', '', format_orange)
    (8..(course.students.length + 7)).to_a.each do |row|
      worksheet.write("Y#{row}", '', format_orange)
      worksheet.write("Z#{row}", '', format_yellow)
      worksheet.write("AA#{row}", '', format_yellow)
    end
  end

  def write_footer
    row_last_student = course.students.length + 8

    worksheet.merge_range("A#{row_last_student}:C#{row_last_student}", 'E = entschuldigt', format_normal_bold)
    worksheet.merge_range("H#{row_last_student}:Z#{row_last_student}",
                          'Bitte zählen Sie die Fehlzeiten rechtzeitig vor Ende des Halbjahres zusammen, damit sie',
                          format_normal_bold)
    worksheet.merge_range("A#{row_last_student + 1}:C#{row_last_student + 1}", '| = unentschuldigt', format_normal_bold)
    worksheet.merge_range("H#{row_last_student + 1}:Z#{row_last_student + 1}",
                          'der Klassenleitung bei der Zensurenkonferenz zur Verfügung stehen.', format_normal_bold)
  end

end