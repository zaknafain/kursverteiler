function registerStudentClick() {
  let studentElements = document.querySelectorAll('.student--container');

  studentElements.forEach(studentElement => studentElement.addEventListener('click', () => {
    let isSelected = studentElement.dataset.selected === 'true';

    if (isSelected) {
      studentElement.classList.remove('student-selected');
      studentElement.dataset.selected = false;
    } else {
      studentElement.classList.add('student-selected');
      studentElement.dataset.selected = true;
    }
  }));
}

function registerDistributeAllClick() {
  document.querySelector('#distribute-all').addEventListener('click', () => {
    let notDistributedElements = document.querySelectorAll('.not-distributed .students--container .student--container');
    let notDistributedStudents = [];

    notDistributedElements.forEach(studentElement => {
      notDistributedStudents.push({
        student_id: studentElement.dataset.studentId,
        course_id: studentElement.dataset.topCourseId,
      });
    });

    $.ajax({
      url: window.location.pathname,
      type: 'PUT',
      data: { poll: { courses_students: notDistributedStudents }},
      success: function(result) {
        console.log('SUCCESS');
      }
  });

  });
}

function registerResetAllClick() {
  document.querySelector('#reset-all').addEventListener('click', () => {
    let studentElements = document.querySelectorAll('.student--container');
    let students = [];

    studentElements.forEach(studentElement => {
      students.push({
        student_id: studentElement.dataset.studentId,
        course_id: null,
      });
    });

    $.ajax({
      url: window.location.pathname,
      type: 'PUT',
      data: { poll: { courses_students: students }},
      success: function(result) {
        console.log('SUCCESS');
      }
  });

  });
}

$(document).on('rails_admin.dom_ready', function() {
  setTimeout(registerStudentClick, 1);
  setTimeout(registerDistributeAllClick, 1);
  setTimeout(registerResetAllClick, 1);
});
