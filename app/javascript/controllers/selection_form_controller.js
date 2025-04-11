import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["topId", "midId", "lowId"];

  toggle(event) {
    const courseId = event.params.courseId;
    const coursePrio = event.params.coursePrio;

    this.clearCourse(courseId);
    if (coursePrio === "low") {
      const currentLowId = this.lowIdTarget.value;
      this.clearCourse(currentLowId);
      this.lowIdTarget.value = courseId;
    }
    if (coursePrio === "mid") {
      const currentMidId = this.midIdTarget.value;
      this.clearCourse(currentMidId);
      this.midIdTarget.value = courseId;
    }
    if (coursePrio === "top") {
      const currentTopId = this.topIdTarget.value;
      this.clearCourse(currentTopId);
      this.topIdTarget.value = courseId;
    }

    const courseCardElement = document.querySelector(`div[data-course-id='${courseId}']`);

    courseCardElement.classList.remove("selected", "low", "mid", "top");
    const firstSvg = courseCardElement.querySelector("div:first-child svg");
    if (firstSvg) {
      firstSvg.classList.remove("hidden");
    }
    courseCardElement.classList.add("selected", coursePrio);

    const buttonClicked = event.currentTarget;
    const buttonSvg = buttonClicked.querySelector("svg");

    buttonSvg.classList.remove("hidden");
  }

  clearCourse(courseId) {
    if (courseId === "") {
      return;
    }

    if (this.lowIdTarget.value === courseId) {
      this.lowIdTarget.value = "";
    }
    if (this.midIdTarget.value === courseId) {
      this.midIdTarget.value = "";
    }
    if (this.topIdTarget.value === courseId) {
      this.topIdTarget.value = "";
    }
    const courseCardElement = document.querySelector(`div[data-course-id='${courseId}']`);
    this.clearCard(courseCardElement);
    courseCardElement.classList.remove("selected", "low", "mid", "top");
  }

  clearCard(courseCardElement) {
    courseCardElement.classList.remove("selected", "low", "mid", "top");

    const svgs = courseCardElement.querySelectorAll("svg");
    svgs.forEach(svg => svg.classList.add("hidden"));
  }
}
