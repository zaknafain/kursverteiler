/*
 * Sets the forms given priority to the given course id.
 */
function courseIdToForm(courseId, priority) {
  let form    = document.querySelector('form');
  let input   = form.querySelector(`input[data-priority='${priority}']`);
  input.value = courseId;
}

/*
 * Looks for the course with the selected given priority and deselects it.
 * To deselect the course it removes the css classes for visual deselection.
 * Also it updates the dataset selected attribute.
 */
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

/*
 * Looks for the course with the given course id and selects it with the given priority.
 * To select the course it adds the css classes for visual selection.
 * Also it updates the dataset selected attribute.
 */
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

/*
 * Sets the forms guaranteed value to a given value.
 * Only sets it to true if the given value is boolean true value;
 */
function setGuaranteed(value) {
  document.querySelector('#guaranteed_chosen').value = value === true;
}

/*
 * Returns the forms guaranteed value.
 * The returned value is a boolean.
 */
function getGuaranteed() {
  return document.querySelector('#guaranteed_chosen').value === 'true';
}

// All priority buttons that are not disabled.
let buttons = document.querySelectorAll('.course-priority--container:not(.course-priority--container__disabled)')

// Adds click event listener to all those buttons.
buttons.forEach(button => button.addEventListener('click', () => {
  let buttonCourseId = button.dataset.courseId;                    // Id of course the button is in.
  let buttonPriority = button.dataset.priority;                    // Priority of the button
  let buttonSelected = button.dataset.selected === buttonPriority; // Whether the button is already selected
  let coursePriority = button.dataset.selected;                    // Priority of the selected course before clicking
  let assuredChoice  = button.dataset.guaranteed    === 'true';    // Whether the course is guaranteed if chosen
  let removeAssured  = getGuaranteed();                            // Whether the current selected top course is a guaranteed one

  deselectPriority(buttonPriority);   // Clear clicked priority in all courses
  if (assuredChoice) {
    deselectPriority('mid');          // Clear mid priority if selection is guaranteed
    deselectPriority('low');          // Clear low priority if selection is guaranteed
  } else if (removeAssured) {
    deselectPriority('top');          // Clear top priority if former selection was guaranteed
    setGuaranteed(false);             // Set guaranteed flag to false
  } else if (coursePriority && !buttonSelected) {
    deselectPriority(coursePriority); // Clear former priority of clicked course
  }

  courseIdToForm(buttonSelected ? null : buttonCourseId, buttonPriority); // Add or remove course id from form at selected priority
  if (assuredChoice) {
    courseIdToForm(null, 'mid');          // Remove any course id from form at mid priority if selection is guaranteed
    courseIdToForm(null, 'low');          // Remove any course id from form at low priority if selection is guaranteed
  } else if (coursePriority && !buttonSelected) {
    courseIdToForm(null, coursePriority); // Remove course id from form at former priority
  }

  if (!buttonSelected) {
    selectCourse(buttonCourseId, buttonPriority); // Select priority of course when it wasn't selected already
    setGuaranteed(assuredChoice);                 // Set the guaranteed flag to the course attribute
  }
}));
