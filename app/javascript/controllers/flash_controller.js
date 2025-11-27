// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

// フラッシュメッセージを制御するコントローラー
export default class extends Controller {
  connect() {
    // 画面に表示されてから3秒後（3000ミリ秒後）に dismiss() を実行
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    // 1. まず透明にする（フェードアウト）
    this.element.classList.add("opacity-0")
    
    // 2. アニメーションが終わるまで1秒待ってから、HTML自体を削除する
    setTimeout(() => {
      this.element.remove()
    }, 1000)
  }
}