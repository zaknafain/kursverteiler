function registerStudentClick() {
  let studentElements = document.querySelectorAll('.student--container');

  studentElements.forEach(studentElement => studentElement.addEventListener('click', () => {
    let isSelected = studentElement.dataset.selected === 'true';

    if (isSelected) {
      studentElement.classList.remove('bg-info');
      studentElement.dataset.selected = false;
    } else {
      studentElement.classList.add('bg-info');
      studentElement.dataset.selected = true;
    }
  }));
}

$(document).on('rails_admin.dom_ready', function() {
  setTimeout(registerStudentClick, 1);
});
