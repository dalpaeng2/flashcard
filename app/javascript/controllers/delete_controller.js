import { Controller } from "@hotwired/stimulus"

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
    // 폼을 동적으로 생성하여 DELETE 요청 전송
    const form = document.createElement('form')
    form.method = 'POST'
    form.action = this.urlValue

    // _method hidden input (Rails의 method spoofing을 위해)
    const methodInput = document.createElement('input')
    methodInput.type = 'hidden'
    methodInput.name = '_method'
    methodInput.value = 'delete'
    form.appendChild(methodInput)

    // CSRF 토큰
    const csrfInput = document.createElement('input')
    csrfInput.type = 'hidden'
    csrfInput.name = 'authenticity_token'
    csrfInput.value = csrfToken
    form.appendChild(csrfInput)

    // 폼을 body에 추가하고 제출
    document.body.appendChild(form)
    form.submit()
  }
}
