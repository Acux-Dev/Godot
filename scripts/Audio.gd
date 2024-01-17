extends TabBar
 
func _ready():
	%Master.value = Persistence.config.get_value("Audio", '0')
	AudioServer.set_bus_volume_db(0,linear_to_db(%Master.value))
 
	%Music.value = Persistence.config.get_value("Audio", '1')
	AudioServer.set_bus_volume_db(1,linear_to_db(%Music.value))
 
	%SFX.value = Persistence.config.get_value("Audio", '2')
	AudioServer.set_bus_volume_db(0,linear_to_db(%SFX.value))
	
	%Tower_Sounds.value = Persistence.config.get_value("Audio", '3')
	AudioServer.set_bus_volume_db(0,linear_to_db(%Tower_Sounds.value))
	
	%Enemy_Sounds.value = Persistence.config.get_value("Audio", '4')
	AudioServer.set_bus_volume_db(0,linear_to_db(%Enemy_Sounds.value))
 
 
func _on_master_value_changed(value):
	set_volume(0,value)
 
 
func _on_music_value_changed(value):
	set_volume(1,value)
 
 
func _on_sfx_value_changed(value):
	set_volume(2,value)
 

func _on_tower_slider_value_changed(value):
	set_volume(3,value)


func _on_enemy_slider_value_changed(value):
	set_volume(4,value)


func set_volume(idx,value):
	AudioServer.set_bus_volume_db( idx, linear_to_db(value) )
	Persistence.config.set_value("Audio",str(idx),value)
	Persistence.save_data()
