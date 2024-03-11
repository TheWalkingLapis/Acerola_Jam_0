extends CanvasLayer

@onready var mail_list: ItemList = $Window/List/ItemList
@onready var from: LineEdit = $Window/Text/From
@onready var to: LineEdit = $Window/Text/To
@onready var subject: LineEdit = $Window/Text/Subject
@onready var content: TextEdit = $Window/Text/Content

var mails = []
var selected_mail = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Window/Text/div1.visible = false
	$Window/Text/div2.visible = false
	$Window/Text/div3.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_items(items: Array[Resource]):
	for i in items:
		mails.append(i)
		mail_list.add_item(i.subject)


func _on_item_list_item_selected(index):
	selected_mail = mails[index]
	from.text = "From: " + selected_mail.from
	to.text = "To: " + selected_mail.to
	subject.text = "Subject: " + selected_mail.subject
	content.text = selected_mail.content
	$Window/Text/div1.visible = true
	$Window/Text/div2.visible = true
	$Window/Text/div3.visible = true
	
func reset():
	mail_list.deselect_all()
	from.text = ""
	to.text = ""
	subject.text = ""
	content.text = ""
	$Window/Text/div1.visible = false
	$Window/Text/div2.visible = false
	$Window/Text/div3.visible = false
	selected_mail = null
