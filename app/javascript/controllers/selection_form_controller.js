import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["topId", "midId", "lowId"];

  toggle(event) {
    const courseId = event.params.courseId;
    const coursePrio = event.params.coursePrio;

    console.log("courseId", courseId);
    console.log("coursePrio", coursePrio);

    if (coursePrio === "low") {
      this.lowIdTarget.value = courseId;
    }
    if (coursePrio === "mid") {
      this.midIdTarget.value = courseId;
    }
    if (coursePrio === "top") {
      this.topIdTarget.value = courseId;
    }
  }
}
