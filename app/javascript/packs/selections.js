function courseIdToForm(courseId, priority) {
  let form = document.querySelector('form');
  let input = form.querySelector(`input[data-priority='${priority}']`);
  input.value = courseId;
}

function deselectPriority(priority) {
  let form = document.querySelector('form');
  let selectedCourseDiv = form.querySelector(`.course__selected--${priority}`);

  if (selectedCourseDiv) {
    selectedCourseDiv.classList.remove('course__selected');
    selectedCourseDiv.classList.remove(`course__selected--${priority}`);
    delete selectedCourseDiv.dataset.selected;

    let prioDiv = selectedCourseDiv.querySelector('.course-priority--container__selected');
    prioDiv.classList.remove('course-priority--container__selected');

    let prioDivs = selectedCourseDiv.querySelectorAll('.course-priority--container');
    prioDivs.forEach(div => delete div.dataset.selected);
  }
}

function selectCourse(courseId, priority) {
  let form = document.querySelector('form');
  let selectedCourseDiv = form.querySelector(`#course-container-${courseId}`);

  selectedCourseDiv.classList.add('course__selected');
  selectedCourseDiv.classList.add(`course__selected--${priority}`);
  selectedCourseDiv.dataset.selected = priority;

  let prioDiv = selectedCourseDiv.querySelector(`#course-${courseId}-priority-${priority}`);
  prioDiv.classList.add('course-priority--container__selected');

  let prioDivs = selectedCourseDiv.querySelectorAll('.course-priority--container');
  prioDivs.forEach(div => div.dataset.selected = priority);
}

let buttons = document.querySelectorAll('.course-priority--container')

buttons.forEach(button => button.addEventListener('click', () => {
  let buttonCourseId = button.dataset.courseId;
  let buttonPriority = button.dataset.priority;
  let buttonSelected = button.dataset.selected === buttonPriority;
  let coursePriority = button.dataset.selected;

  deselectPriority(buttonPriority);
  if (coursePriority && !buttonSelected) { deselectPriority(coursePriority); }

  courseIdToForm(buttonSelected ? null : buttonCourseId, buttonPriority);
  if (coursePriority && !buttonSelected) { courseIdToForm(null, coursePriority); }

  if (!buttonSelected) { selectCourse(buttonCourseId, buttonPriority); }
}));
