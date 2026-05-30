extends Node

var radio_url = "https://your-radio-stream-url.com/stream"  # e.g. an Icecast/Shoutcast stream

const STREAMS = {
	"country": "https://somafm.com/bootliquor",
	"anime": "https://radio.plaza.one/mp3"
}

func _ready():
	if OS.get_name() == "Web":
		_start_radio()
		play_station("anime")

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
		
func play_station(key: String):
	if OS.get_name() == "Web":
		var url = STREAMS[key]
		JavaScriptBridge.eval("""
            if (window._radio) { window._radio.pause(); }
            window._radio = new Audio('%s');
            window._radio.volume = 0.5;
            window._radio.play().catch(() => {
                document.addEventListener('click', () => window._radio.play(), { once: true });
            });
		""" % url)
