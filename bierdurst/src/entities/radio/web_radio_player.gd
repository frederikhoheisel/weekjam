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

func _start_radio_with_effect():
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("""
		    var audio = new Audio('%s');
		    audio.crossOrigin = 'anonymous';
		    
		    var ctx = new AudioContext();
		    var source = ctx.createMediaElementSource(audio);
		    
		    // 1. High-pass filter — cuts the boomy low end
		    var highpass = ctx.createBiquadFilter();
		    highpass.type = 'highpass';
		    highpass.frequency.value = 800;
		    
		    // 2. Low-pass filter — cuts the crisp high end
		    var lowpass = ctx.createBiquadFilter();
		    lowpass.type = 'lowpass';
		    lowpass.frequency.value = 2000;
		    
		    // 3. Distortion — cheap speaker crunch
		    var distortion = ctx.createWaveShaper();
		    distortion.curve = makeDistortionCurve(40);
		    distortion.oversample = '2x';
		    
		    // 4. Gain — distortion lowers volume so compensate
		    var gainNode = ctx.createGain();
		    gainNode.gain.value = 1.4;
		    
		    // chain everything together
		    source
		        .connect(highpass)
		        .connect(lowpass)
		        .connect(distortion)
		        .connect(gainNode)
		        .connect(ctx.destination);
		    
		    audio.play().catch(() => {
		        document.addEventListener('click', () => audio.play(), { once: true });
		    });
		    
		    window._radio = audio;
		    window._radioGain = gainNode;
		    window._audioCtx = ctx;
		    
		    function makeDistortionCurve(amount) {
		        var samples = 256;
		        var curve = new Float32Array(samples);
		        for (var i = 0; i < samples; i++) {
		            var x = (i * 2) / samples - 1;
		            curve[i] = ((Math.PI + amount) * x) / (Math.PI + amount * Math.abs(x));
		        }
		        return curve;
		    }
		""" % radio_url)
	
func set_volume(vol: float):
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("if (window._radioAudio) window._radioAudio.volume = %f;" % vol)

# use when radio is playing with effects
func _set_radio_volume(linear_volume: float):
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("""
            if (window._radioGain) window._radioGain.gain.value = %f * 1.4;
		""" % linear_volume)

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
