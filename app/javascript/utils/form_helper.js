// 동적으로 폼을 생성하여 DELETE 요청을 전송하는 유틸리티 함수
export function submitDeleteForm(url, csrfToken) {
  // 폼을 동적으로 생성하여 DELETE 요청 전송
  const form = document.createElement('form')
  form.method = 'POST'
  form.action = url

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
