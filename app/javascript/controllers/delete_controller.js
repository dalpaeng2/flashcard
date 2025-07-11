import { Controller } from "@hotwired/stimulus"
import { submitDeleteForm } from "utils/form_helper"

export default class extends Controller {
  static values = {
    url: String,
    message: String
  }

  delete(event) {
    event.preventDefault()

    // CSRF 토큰 가져오기
    const csrfToken = document.querySelector('[name="csrf-token"]')?.content

    if (!csrfToken) {
      alert('보안 토큰을 찾을 수 없습니다. 페이지를 새로고침해 주세요.')
      return
    }

    // 전역 모달 인스턴스를 통해 모달 표시
    if (window.deleteModal) {
      window.deleteModal.show(this.messageValue, this.urlValue, csrfToken)
    } else {
      // 모달이 없는 경우 기본 confirm으로 fallback
      if (confirm(this.messageValue)) {
        this.executeDelete(csrfToken)
      }
    }
  }

  executeDelete(csrfToken) {
    submitDeleteForm(this.urlValue, csrfToken)
  }
}
