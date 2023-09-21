@tool
extends Window

const REGEX_STR:String = "(?<=description\")(.*)(?=property=\"og:description)"
const URL:String = "https://www.bible.com/verse-of-the-day"

@onready var http:HTTPRequest = $HTTPRequest
@onready var text:RichTextLabel = $RichTextLabel


func _ready() -> void:
	http.request(URL)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response := body.get_string_from_utf8()
	filter_message(response.strip_escapes())


func filter_message(message:String) -> void:
	var regex = RegEx.new()
	regex.compile(REGEX_STR)
	var result :RegExMatch = regex.search(message)
	if result:
		var edit_res: String = result.get_string(0).get_slice("=",1).replace("\"","")
		text.text = edit_res
		show()
		print(edit_res)
		pass
	
	pass


func _on_bt_thanks_pressed() -> void:
	hide()
