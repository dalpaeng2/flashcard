import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "content"]

  connect() {
    // 모달이 연결되면 전역 참조 저장
    window.deleteModal = this
  }

  show(message, deleteUrl, csrfToken) {
    // 메시지 설정
    const messageElement = document.getElementById('deleteMessage')
    if (messageElement) {
      messageElement.textContent = message
    }

    // 삭제 URL과 CSRF 토큰 저장
    this.deleteUrl = deleteUrl
    this.csrfToken = csrfToken

    // 모달 표시
    this.element.style.display = 'flex'

    // 애니메이션을 위해 약간의 지연 후 클래스 추가
    setTimeout(() => {
      if (this.hasContentTarget) {
        this.contentTarget.classList.remove('scale-95', 'opacity-0')
        this.contentTarget.classList.add('scale-100', 'opacity-100')
      }
    }, 10)

    // ESC 키로 닫기 이벤트 추가
    document.addEventListener('keydown', this.handleEscape.bind(this))

    // 배경 클릭으로 닫기
    this.element.addEventListener('click', this.handleBackgroundClick.bind(this))
  }

  close() {
    // 닫기 애니메이션
    if (this.hasContentTarget) {
      this.contentTarget.classList.remove('scale-100', 'opacity-100')
      this.contentTarget.classList.add('scale-95', 'opacity-0')
    }

    // 애니메이션 완료 후 모달 숨김
    setTimeout(() => {
      this.element.style.display = 'none'
    }, 300)

    // 이벤트 리스너 제거
    document.removeEventListener('keydown', this.handleEscape.bind(this))
    this.element.removeEventListener('click', this.handleBackgroundClick.bind(this))
  }

  confirmDelete() {
    if (this.deleteUrl && this.csrfToken) {
      // 폼을 동적으로 생성하여 DELETE 요청 전송
      const form = document.createElement('form')
      form.method = 'POST'
      form.action = this.deleteUrl

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
      csrfInput.value = this.csrfToken
      form.appendChild(csrfInput)

      // 폼을 body에 추가하고 제출
      document.body.appendChild(form)
      form.submit()
    }

    this.close()
  }

  handleEscape(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }

  handleBackgroundClick(event) {
    // 모달 배경을 클릭했을 때만 닫기 (모달 내용 클릭 시에는 닫지 않음)
    if (event.target === this.element) {
      this.close()
    }
  }
}
