#!/usr/bin/env python3
"""
Auto-translate InTouch localization strings
Translates all English strings to: Spanish, Japanese, Chinese (Simplified, Traditional, Hong Kong), Hindi
"""

import json

# Professional translations for InTouch app
translations = {
    "InTouch": {
        "es": "InTouch",
        "ja": "InTouch",
        "zh-Hans": "InTouch",
        "zh-Hant": "InTouch",
        "zh-HK": "InTouch",
        "hi": "InTouch"
    },
    "Ready to reconnect?": {
        "es": "¿Listo para reconectar?",
        "ja": "再接続の準備はできましたか？",
        "zh-Hans": "准备好重新联系了吗？",
        "zh-Hant": "準備好重新聯繫了嗎？",
        "zh-HK": "準備好重新聯繫了嗎？",
        "hi": "फिर से जुड़ने के लिए तैयार?"
    },
    "Tap the button below to discover who you should reach out to today": {
        "es": "Toca el botón a continuación para descubrir con quién deberías contactar hoy",
        "ja": "下のボタンをタップして、今日連絡すべき人を見つけましょう",
        "zh-Hans": "点击下方按钮查看今天应该联系谁",
        "zh-Hant": "點擊下方按鈕查看今天應該聯繫誰",
        "zh-HK": "點擊下方按鈕查看今天應該聯繫誰",
        "hi": "आज किससे संपर्क करना चाहिए यह जानने के लिए नीचे दिए गए बटन पर टैप करें"
    },
    "Spin the Wheel": {
        "es": "Girar la Rueda",
        "ja": "ホイールを回す",
        "zh-Hans": "转转轮",
        "zh-Hant": "轉轉輪",
        "zh-HK": "轉轉輪",
        "hi": "चक्का घुमाएं"
    },
    "Picking someone special...": {
        "es": "Eligiendo a alguien especial...",
        "ja": "特別な人を選んでいます...",
        "zh-Hans": "正在挑选特别的人...",
        "zh-Hant": "正在挑選特別的人...",
        "zh-HK": "正在挑選特別的人...",
        "hi": "किसी विशेष को चुन रहे हैं..."
    },
    "%lld spin left": {
        "es": "%lld giro restante",
        "ja": "残り%lld回",
        "zh-Hans": "剩余%lld次",
        "zh-Hant": "剩餘%lld次",
        "zh-HK": "剩餘%lld次",
        "hi": "%lld घुमाव बचा"
    },
    "%lld spins left": {
        "es": "%lld giros restantes",
        "ja": "残り%lld回",
        "zh-Hans": "剩余%lld次",
        "zh-Hant": "剩餘%lld次",
        "zh-HK": "剩餘%lld次",
        "hi": "%lld घुमाव बचे"
    },
    "Out of spins": {
        "es": "Sin giros",
        "ja": "回数がありません",
        "zh-Hans": "次数用完",
        "zh-Hant": "次數用完",
        "zh-HK": "次數用完",
        "hi": "घुमाव समाप्त"
    },
    "Next refill: %@": {
        "es": "Próxima recarga: %@",
        "ja": "次の補充: %@",
        "zh-Hans": "下次补充：%@",
        "zh-Hant": "下次補充：%@",
        "zh-HK": "下次補充：%@",
        "hi": "अगली रीफिल: %@"
    },
    "Refills at %@": {
        "es": "Recarga a las %@",
        "ja": "%@に補充",
        "zh-Hans": "%@补充",
        "zh-Hant": "%@補充",
        "zh-HK": "%@補充",
        "hi": "%@ पर रीफिल"
    },
    "Get Unlimited": {
        "es": "Obtener Ilimitado",
        "ja": "無制限を取得",
        "zh-Hans": "获取无限次",
        "zh-Hant": "獲取無限次",
        "zh-HK": "獲取無限次",
        "hi": "असीमित प्राप्त करें"
    },
    "Call": {
        "es": "Llamar",
        "ja": "電話",
        "zh-Hans": "致电",
        "zh-Hant": "致電",
        "zh-HK": "致電",
        "hi": "कॉल करें"
    },
    "Message": {
        "es": "Mensaje",
        "ja": "メッセージ",
        "zh-Hans": "消息",
        "zh-Hant": "訊息",
        "zh-HK": "訊息",
        "hi": "संदेश"
    },
    "Exclude Contact": {
        "es": "Excluir Contacto",
        "ja": "連絡先を除外",
        "zh-Hans": "排除联系人",
        "zh-Hant": "排除聯絡人",
        "zh-HK": "排除聯絡人",
        "hi": "संपर्क बहिष्कृत करें"
    },
    "Conversation Starter": {
        "es": "Iniciador de Conversación",
        "ja": "会話のきっかけ",
        "zh-Hans": "对话开场白",
        "zh-Hant": "對話開場白",
        "zh-HK": "對話開場白",
        "hi": "बातचीत शुरू करने वाला"
    },
    "Settings": {
        "es": "Ajustes",
        "ja": "設定",
        "zh-Hans": "设置",
        "zh-Hant": "設定",
        "zh-HK": "設定",
        "hi": "सेटिंग्स"
    },
    "Daily Reminders": {
        "es": "Recordatorios Diarios",
        "ja": "毎日のリマインダー",
        "zh-Hans": "每日提醒",
        "zh-Hant": "每日提醒",
        "zh-HK": "每日提醒",
        "hi": "दैनिक अनुस्मारक"
    },
    "Subscription": {
        "es": "Suscripción",
        "ja": "サブスクリプション",
        "zh-Hans": "订阅",
        "zh-Hant": "訂閱",
        "zh-HK": "訂閱",
        "hi": "सदस्यता"
    },
    "About": {
        "es": "Acerca de",
        "ja": "について",
        "zh-Hans": "关于",
        "zh-Hant": "關於",
        "zh-HK": "關於",
        "hi": "के बारे में"
    },
    "Privacy Policy": {
        "es": "Política de Privacidad",
        "ja": "プライバシーポリシー",
        "zh-Hans": "隐私政策",
        "zh-Hant": "隱私政策",
        "zh-HK": "私隱政策",
        "hi": "गोपनीयता नीति"
    },
    "Contact Support": {
        "es": "Contactar Soporte",
        "ja": "サポートに連絡",
        "zh-Hans": "联系支持",
        "zh-Hant": "聯絡支援",
        "zh-HK": "聯絡支援",
        "hi": "सहायता से संपर्क करें"
    },
    "Unlock Premium": {
        "es": "Desbloquear Premium",
        "ja": "プレミアムを解除",
        "zh-Hans": "解锁高级版",
        "zh-Hant": "解鎖高級版",
        "zh-HK": "解鎖高級版",
        "hi": "प्रीमियम अनलॉक करें"
    },
    "Stay connected with unlimited spins and powerful features": {
        "es": "Mantente conectado con giros ilimitados y características poderosas",
        "ja": "無制限のスピンと強力な機能で繋がり続けましょう",
        "zh-Hans": "通过无限次数和强大功能保持联系",
        "zh-Hant": "透過無限次數和強大功能保持聯繫",
        "zh-HK": "透過無限次數和強大功能保持聯繫",
        "hi": "असीमित स्पिन और शक्तिशाली सुविधाओं के साथ जुड़े रहें"
    },
    "Unlimited Spins": {
        "es": "Giros Ilimitados",
        "ja": "無制限スピン",
        "zh-Hans": "无限次数",
        "zh-Hant": "無限次數",
        "zh-HK": "無限次數",
        "hi": "असीमित स्पिन"
    },
    "Spin as many times as you want, every day": {
        "es": "Gira tantas veces como quieras, cada día",
        "ja": "毎日好きなだけスピンできます",
        "zh-Hans": "每天想转多少次就转多少次",
        "zh-Hant": "每天想轉多少次就轉多少次",
        "zh-HK": "每天想轉多少次就轉多少次",
        "hi": "हर दिन जितनी बार चाहें उतनी बार घुमाएं"
    },
    "Start Free Trial": {
        "es": "Iniciar Prueba Gratuita",
        "ja": "無料トライアルを開始",
        "zh-Hans": "开始免费试用",
        "zh-Hant": "開始免費試用",
        "zh-HK": "開始免費試用",
        "hi": "मुफ्त परीक्षण शुरू करें"
    },
    "Restore Purchases": {
        "es": "Restaurar Compras",
        "ja": "購入を復元",
        "zh-Hans": "恢复购买",
        "zh-Hant": "恢復購買",
        "zh-HK": "恢復購買",
        "hi": "खरीदारी पुनर्स्थापित करें"
    },
    "Analytics": {
        "es": "Análisis",
        "ja": "分析",
        "zh-Hans": "分析",
        "zh-Hant": "分析",
        "zh-HK": "分析",
        "hi": "विश्लेषण"
    },
    "Current Streak": {
        "es": "Racha Actual",
        "ja": "現在の連続記録",
        "zh-Hans": "当前连续天数",
        "zh-Hant": "目前連續天數",
        "zh-HK": "目前連續天數",
        "hi": "वर्तमान स्ट्रीक"
    },
    "Total Spins": {
        "es": "Giros Totales",
        "ja": "合計スピン数",
        "zh-Hans": "总次数",
        "zh-Hant": "總次數",
        "zh-HK": "總次數",
        "hi": "कुल स्पिन"
    },
    "Who misses you?": {
        "es": "¿Quién te extraña?",
        "ja": "誰があなたを恋しがっていますか？",
        "zh-Hans": "谁在想念你？",
        "zh-Hant": "誰在想念你？",
        "zh-HK": "邊個掛住你？",
        "hi": "आपको कौन याद कर रहा है?"
    },
    "Spin now to find out who you should call today ☀️": {
        "es": "Gira ahora para descubrir a quién deberías llamar hoy ☀️",
        "ja": "今日誰に電話すべきか今すぐスピンして見つけましょう ☀️",
        "zh-Hans": "立即转转轮，看看今天应该给谁打电话 ☀️",
        "zh-Hant": "立即轉轉輪，看看今天應該給誰打電話 ☀️",
        "zh-HK": "即刻轉轉輪，睇吓今日應該打俾邊個 ☀️",
        "hi": "आज किसे फोन करना चाहिए यह जानने के लिए अभी घुमाएं ☀️"
    },
    "Last chance today!": {
        "es": "¡Última oportunidad hoy!",
        "ja": "今日最後のチャンス！",
        "zh-Hans": "今天最后机会！",
        "zh-Hant": "今天最後機會！",
        "zh-HK": "今日最後機會！",
        "hi": "आज का आखिरी मौका!"
    },
    "3 fresh spins expire at midnight. Spin now 🌙": {
        "es": "3 giros nuevos expiran a medianoche. Gira ahora 🌙",
        "ja": "3回の新しいスピンは深夜に期限切れです。今すぐスピン 🌙",
        "zh-Hans": "3次新机会将在午夜过期。立即转 🌙",
        "zh-Hant": "3次新機會將在午夜過期。立即轉 🌙",
        "zh-HK": "3次新機會將會喺午夜過期。即刻轉 🌙",
        "hi": "3 नए स्पिन आधी रात को समाप्त हो जाएंगे। अभी घुमाएं 🌙"
    },
    "Done": {
        "es": "Listo",
        "ja": "完了",
        "zh-Hans": "完成",
        "zh-Hant": "完成",
        "zh-HK": "完成",
        "hi": "पूर्ण"
    },
    "Cancel": {
        "es": "Cancelar",
        "ja": "キャンセル",
        "zh-Hans": "取消",
        "zh-Hant": "取消",
        "zh-HK": "取消",
        "hi": "रद्द करें"
    },
    "OK": {
        "es": "OK",
        "ja": "OK",
        "zh-Hans": "确定",
        "zh-Hant": "確定",
        "zh-HK": "確定",
        "hi": "ठीक है"
    },
    "No contacts available": {
        "es": "No hay contactos disponibles",
        "ja": "連絡先がありません",
        "zh-Hans": "没有可用的联系人",
        "zh-Hant": "沒有可用的聯絡人",
        "zh-HK": "冇可用嘅聯絡人",
        "hi": "कोई संपर्क उपलब्ध नहीं"
    },
    "Please enable contacts access in Settings": {
        "es": "Por favor, habilita el acceso a contactos en Ajustes",
        "ja": "設定で連絡先へのアクセスを有効にしてください",
        "zh-Hans": "请在设置中启用联系人访问权限",
        "zh-Hant": "請在設定中啟用聯絡人存取權限",
        "zh-HK": "請喺設定中啟用聯絡人存取權限",
        "hi": "कृपया सेटिंग्स में संपर्क एक्सेस सक्षम करें"
    }
}

def load_xcstrings():
    with open('/Users/joshking/InTouch/InTouch/Localizable.xcstrings', 'r', encoding='utf-8') as f:
        return json.load(f)

def save_xcstrings(data):
    with open('/Users/joshking/InTouch/InTouch/Localizable.xcstrings', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def add_translations():
    data = load_xcstrings()

    for key, entry in data['strings'].items():
        if 'localizations' not in entry:
            continue

        en_value = None

        # Get English value
        if 'en' in entry['localizations']:
            if 'stringUnit' in entry['localizations']['en']:
                en_value = entry['localizations']['en']['stringUnit']['value']
            elif 'variations' in entry['localizations']['en']:
                # Handle plural variations
                for variation_type, variation_data in entry['localizations']['en']['variations'].items():
                    for form, form_data in variation_data.items():
                        if 'stringUnit' in form_data:
                            # For now, just handle the 'other' case
                            if form == 'other':
                                en_value = form_data['stringUnit']['value']

        if not en_value or en_value not in translations:
            continue

        trans = translations[en_value]

        # Add Spanish
        if 'es' in trans:
            entry['localizations']['es'] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans['es']
                }
            }

        # Add Japanese
        if 'ja' in trans:
            entry['localizations']['ja'] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans['ja']
                }
            }

        # Add Chinese Simplified
        if 'zh-Hans' in trans:
            entry['localizations']['zh-Hans'] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans['zh-Hans']
                }
            }

        # Add Chinese Traditional
        if 'zh-Hant' in trans:
            entry['localizations']['zh-Hant'] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans['zh-Hant']
                }
            }

        # Add Chinese Hong Kong
        if 'zh-HK' in trans:
            entry['localizations']['zh-HK'] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans['zh-HK']
                }
            }

        # Add Hindi
        if 'hi' in trans:
            entry['localizations']['hi'] = {
                "stringUnit": {
                    "state": "translated",
                    "value": trans['hi']
                }
            }

    save_xcstrings(data)
    print("✅ Successfully added translations for all 6 languages!")
    print("📊 Translations added:")
    print("   - Spanish (es)")
    print("   - Japanese (ja)")
    print("   - Chinese Simplified (zh-Hans)")
    print("   - Chinese Traditional (zh-Hant)")
    print("   - Chinese Hong Kong (zh-HK)")
    print("   - Hindi (hi)")

if __name__ == '__main__':
    add_translations()
