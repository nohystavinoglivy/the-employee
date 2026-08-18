extends Node

# Procedural audio via AudioStreamGenerator
# All sounds are synthesized — no asset files required

var _bus_master: int = 0
var _ambient_player: AudioStreamPlayer = null
var _sfx_player: AudioStreamPlayer = null
var _impact_player: AudioStreamPlayer = null

const AMBIENT_VOLUME_DB := -18.0
const SFX_VOLUME_DB     := -6.0

func _ready() -> void:
	_ambient_player = _make_player(AMBIENT_VOLUME_DB)
	_sfx_player     = _make_player(SFX_VOLUME_DB)
	_impact_player  = _make_player(SFX_VOLUME_DB)
	add_child(_ambient_player)
	add_child(_sfx_player)
	add_child(_impact_player)

func _make_player(vol_db: float) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.volume_db = vol_db
	return p

# ── Ambient ───────────────────────────────────────────────────────────────────

func play_ambient_hum() -> void:
	# Electrical hum: 60 Hz fundamental
	_play_tone(_ambient_player, 60.0, 4.0, 0.12, true)

func play_ambient_office() -> void:
	# HVAC-style low rumble
	_play_tone(_ambient_player, 45.0, 4.0, 0.08, true)

func play_ambient_street() -> void:
	_play_tone(_ambient_player, 80.0, 4.0, 0.06, true)

func stop_ambient() -> void:
	_ambient_player.stop()

# ── SFX ──────────────────────────────────────────────────────────────────────

func play_impact() -> void:
	# Heavy single sonic event — low thud
	_play_tone(_impact_player, 55.0, 0.15, 0.9, false)

func play_footstep() -> void:
	_play_tone(_sfx_player, 180.0, 0.05, 0.15, false)

func play_interact() -> void:
	_play_tone(_sfx_player, 440.0, 0.08, 0.25, false)

func play_dialogue_advance() -> void:
	_play_tone(_sfx_player, 880.0, 0.04, 0.12, false)

func play_scrape() -> void:
	# The scrape sound from founders' hallway day 3
	_play_noise(_sfx_player, 0.1, 0.3)

func play_task_complete() -> void:
	_play_tone(_sfx_player, 523.0, 0.2, 0.4, false)

# ── Internal synthesis ────────────────────────────────────────────────────────

func _play_tone(player: AudioStreamPlayer, freq: float, duration: float, amp: float, loop: bool) -> void:
	var sample_rate := 22050
	var samples := int(sample_rate * duration)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED

	var data := PackedByteArray()
	data.resize(samples * 2)
	for i in range(samples):
		var t := float(i) / float(sample_rate)
		var envelope := 1.0
		if not loop:
			# Simple ADSR envelope
			var attack := minf(t / 0.005, 1.0)
			var decay_start := duration * 0.1
			var sustain := 0.7
			if t > decay_start:
				var decay_t := (t - decay_start) / (duration - decay_start)
				envelope = sustain + (1.0 - sustain) * (1.0 - decay_t)
			envelope *= attack
		var sample := int(sin(TAU * freq * t) * amp * envelope * 32767.0)
		sample = clampi(sample, -32768, 32767)
		data[i * 2]     = sample & 0xFF
		data[i * 2 + 1] = (sample >> 8) & 0xFF

	stream.data = data
	player.stream = stream
	player.play()

func _play_noise(player: AudioStreamPlayer, duration: float, amp: float) -> void:
	var sample_rate := 22050
	var samples := int(sample_rate * duration)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED

	var data := PackedByteArray()
	data.resize(samples * 2)
	for i in range(samples):
		var t := float(i) / float(sample_rate)
		var env := 1.0 - (t / duration)
		var noise := randf_range(-1.0, 1.0) * amp * env
		var sample := int(noise * 32767.0)
		sample = clampi(sample, -32768, 32767)
		data[i * 2]     = sample & 0xFF
		data[i * 2 + 1] = (sample >> 8) & 0xFF

	stream.data = data
	player.stream = stream
	player.play()
