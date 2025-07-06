import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cardBack", "showAnswerBtn", "timeButtons"]

  showAnswer() {
    this.cardBackTarget.classList.remove("hidden")
    this.showAnswerBtnTarget.style.display = "none"
    this.timeButtonsTarget.classList.remove("hidden")
  }

  selectTime(event) {
    event.preventDefault() // 기본 동작 방지

    const button = event.target.closest('button') // 버튼 요소 확실히 찾기
    const minutes = button.dataset.minutes
    const cardId = button.dataset.cardId

    // 카드 ID가 유효하지 않으면 요청하지 않음
    if (!cardId || cardId === 'undefined' || cardId === '' || cardId === 'null') {
      console.error('Invalid card ID:', cardId)
      alert('카드 ID가 올바르지 않습니다. 페이지를 새로고침해 주세요.')
      return
    }

    // 버튼 비활성화로 중복 클릭 방지
    button.disabled = true
    button.style.opacity = '0.5'

    // 폼 데이터로 전송
    const formData = new FormData()
    formData.append('next_review_minutes', minutes)

    // 서버에 시간 정보를 전송
    fetch(`/cards/${cardId}/schedule`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: formData
    }).then(response => {
      if (response.ok) {
        // 다음 카드로 이동하거나 퀴즈 완료 처리
        window.location.reload()
      } else {
        console.error('Failed to schedule card:', response.status)
        alert('카드 스케줄링에 실패했습니다.')
        // 버튼 다시 활성화
        button.disabled = false
        button.style.opacity = '1'
      }
    }).catch(error => {
      console.error('Error scheduling card:', error)
      alert('네트워크 오류가 발생했습니다.')
      // 버튼 다시 활성화
      button.disabled = false
      button.style.opacity = '1'
    })
  }
}
