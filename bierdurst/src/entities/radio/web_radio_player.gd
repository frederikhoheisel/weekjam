extends Node

var radio_url = "https://your-radio-stream-url.com/stream"  # e.g. an Icecast/Shoutcast stream

const STREAMS: Array[String] = [
	"https://somafm.com/bootliquor",
	"https://radio.plaza.one/mp3"
]

var current_station_id: int = 1

func _ready():
	if OS.get_name() == "Web":
		_start_radio()
		play_station(current_station_id)


func _start_radio():
	JavaScriptBridge.eval("""
        var radioAudio = new Audio('%s');
        radioAudio.volume = 0.5;
        radioAudio.play().catch(function(e) {
            // Autoplay blocked — need a user gesture first
            document.addEventListener('click', function() { radioAudio.play(); }, { once: true });
        });
        window._radioAudio = radioAudio;
	""" % radio_url)

func set_volume(vol: float):
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("if (window._radioAudio) window._radioAudio.volume = %f;" % vol)

func stop_radio():
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("if (window._radioAudio) window._radioAudio.pause();")


func play_next() -> void:
	play_station((current_station_id + 1) % STREAMS.size())


func play_station(id: int):
	if OS.get_name() == "Web":
		var url = STREAMS[id]
		JavaScriptBridge.eval("""
            if (window._radio) { window._radio.pause(); }
            window._radio = new Audio('%s');
            window._radio.volume = 0.5;
            window._radio.play().catch(() => {
                document.addEventListener('click', () => window._radio.play(), { once: true });
            });
		""" % url)
