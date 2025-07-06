import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cardBack", "showAnswerBtn", "timeButtons"]

  showAnswer() {
    this.cardBackTarget.classList.remove("hidden")
    this.showAnswerBtnTarget.style.display = "none"
    this.timeButtonsTarget.classList.remove("hidden")
  }

  selectTime(event) {
    const minutes = event.target.dataset.minutes
    const cardId = event.target.dataset.cardId

    // 서버에 시간 정보를 전송
    fetch(`/cards/${cardId}/schedule`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        next_review_minutes: minutes
      })
    }).then(response => {
      if (response.ok) {
        // 다음 카드로 이동하거나 퀴즈 완료 처리
        window.location.reload()
      }
    })
  }
}
