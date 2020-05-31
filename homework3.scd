s.boot;


Server.default.quit

(
SynthDef.new("pitchFollow1",{
	arg faderPitch=1, v=#[0, 0, 0, 0, 0, 0, 0, 0], faderReverb=0, rotaryRoom = 0, vibratoX=0, vibratoY=0, attack=0, t=1/4;

	var in, amp, freq, hasFreq, out;
    var midinum;
    var partials;

    in = Mix.new(SoundIn.ar([0,1]));
    //amp = Amplitude.kr(in, 0.05, 1);
	amp = Amplitude.kr(in, 5, 1000);
    # freq, hasFreq = Pitch.kr(in);
    midinum = freq.cpsmidi.round(1);
    midinum.postln;
    freq = Lag.kr(midinum.midicps, 0.05);

	//set the desired number of harmonics

	//select t 1/4 for minor scale, 1/3 for major scale

	partials = [
		0.25*faderPitch*v[0],
		0.25*faderPitch*2.pow(t)*v[1],
		0.5*faderPitch*v[2],
		0.5*faderPitch*2.pow(t)*v[3],
		1*faderPitch*v[4],
		1*faderPitch*2.pow(t)*v[5],
		2*faderPitch*v[6],
		2*faderPitch*2.pow(t)*v[7],
    ];

	out = HPF.kr(out, 120);

    out = PitchShift.ar(in, 0.1, partials, 0, 0.004, amp);

	//VIBRATO
	out=SinOsc.kr(freq: vibratoX*6, mul: vibratoY*1.125, add:out);
	//REVERB
	out=Mix.new(FreeVerb.ar(out, faderReverb, rotaryRoom));

	Out.ar([0,1],out/partials.size);

}).add;

)

(

z = Synth(\pitchFollow1);

i = NetAddr("192.168.1.23", 57120);
o = NetAddr("192.168.1.23", 9000);


o.sendMsg("/Harmonizer/ModeMajor", 1);

OSCdef('Pitch',
 {
  arg msg;
  msg.postln;

  z.set(\faderPitch, msg[1]);
 },
 "/Harmonizer/FaderPitch");


OSCdef('Harm1',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm2", 0);
  o.sendMsg("/Harmonizer/harm3", 0);
  o.sendMsg("/Harmonizer/harm4", 0);
  o.sendMsg("/Harmonizer/harm5", 0);
  o.sendMsg("/Harmonizer/harm6", 0);
  o.sendMsg("/Harmonizer/harm7", 0);
  o.sendMsg("/Harmonizer/harm8", 0);
		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm1", 1);
		},{});

  h = #[1,0,0,0,0,0,0,0];

  z.set(\v, h);
 },
 "/Harmonizer/harm1");

OSCdef('Harm2',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm3", 0);
  o.sendMsg("/Harmonizer/harm4", 0);
  o.sendMsg("/Harmonizer/harm5", 0);
  o.sendMsg("/Harmonizer/harm6", 0);
  o.sendMsg("/Harmonizer/harm7", 0);
  o.sendMsg("/Harmonizer/harm8", 0);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm2", 1);
		},{});
  z.set(\v, [1,1,0,0,0,0,0,0]);
 },
 "/Harmonizer/harm2");

OSCdef('Harm3',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm2", 1);
  o.sendMsg("/Harmonizer/harm4", 0);
  o.sendMsg("/Harmonizer/harm5", 0);
  o.sendMsg("/Harmonizer/harm6", 0);
  o.sendMsg("/Harmonizer/harm7", 0);
  o.sendMsg("/Harmonizer/harm8", 0);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm3", 1);
		},{});

  z.set(\v, [1,1,1,0,0,0,0,0]);
 },
 "/Harmonizer/harm3");

OSCdef('Harm4',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm2", 1);
  o.sendMsg("/Harmonizer/harm3", 1);
  o.sendMsg("/Harmonizer/harm5", 0);
  o.sendMsg("/Harmonizer/harm6", 0);
  o.sendMsg("/Harmonizer/harm7", 0);
  o.sendMsg("/Harmonizer/harm8", 0);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm4", 1);
		},{});

  z.set(\v, [1,1,1,1,0,0,0,0]);
 },
 "/Harmonizer/harm4");

OSCdef('Harm5',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm2", 1);
  o.sendMsg("/Harmonizer/harm3", 1);
  o.sendMsg("/Harmonizer/harm4", 1);
  o.sendMsg("/Harmonizer/harm6", 0);
  o.sendMsg("/Harmonizer/harm7", 0);
  o.sendMsg("/Harmonizer/harm8", 0);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm5", 1);
		},{});

  z.set(\v, [1,1,1,1,1,0,0,0]);
 },
 "/Harmonizer/harm5");

OSCdef('Harm6',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm2", 1);
  o.sendMsg("/Harmonizer/harm3", 1);
  o.sendMsg("/Harmonizer/harm4", 1);
  o.sendMsg("/Harmonizer/harm5", 1);
  o.sendMsg("/Harmonizer/harm7", 0);
  o.sendMsg("/Harmonizer/harm8", 0);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm6", 1);
		},{});


  z.set(\v, [1,1,1,1,1,1,0,0]);
 },
 "/Harmonizer/harm6");

OSCdef('Harm7',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm2", 1);
  o.sendMsg("/Harmonizer/harm3", 1);
  o.sendMsg("/Harmonizer/harm4", 1);
  o.sendMsg("/Harmonizer/harm5", 1);
  o.sendMsg("/Harmonizer/harm6", 1);
  o.sendMsg("/Harmonizer/harm8", 0);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm7", 1);
		},{});

  z.set(\v, [1,1,1,1,1,1,1,0]);
 },
 "/Harmonizer/harm7");

OSCdef('Harm8',
 {
  arg msg;
  msg.postln;

  o.sendMsg("/Harmonizer/harm1", 1);
  o.sendMsg("/Harmonizer/harm2", 1);
  o.sendMsg("/Harmonizer/harm3", 1);
  o.sendMsg("/Harmonizer/harm4", 1);
  o.sendMsg("/Harmonizer/harm5", 1);
  o.sendMsg("/Harmonizer/harm6", 1);
  o.sendMsg("/Harmonizer/harm7", 1);

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/harm8", 1);
		},{});

  h = [1,1,1,1,1,1,1,1];

  z.set(\v, h);
 },
 "/Harmonizer/harm8");

OSCdef('ReverbFader',
 {
  arg msg;
  msg.postln;

  z.set(\faderReverb, msg[1]);
 },
 "/Harmonizer/FaderReverb");

OSCdef('ReverbRoom',
 {
  arg msg;
  msg.postln;

  z.set(\rotaryRoom, msg[1]);
 },
 "/Harmonizer/RotaryReverb");

OSCdef('VibratoXY',
 {
  arg msg;
  msg.postln;

  z.set(\vibratoX, msg[2]);
  z.set(\vibratoY, msg[1]);
 },
 "/Harmonizer/VibratoXY");

OSCdef('Attack',
 {
  arg msg;
  msg.postln;

  z.set(\attack, msg[1]);

 },
 "/Harmonizer/RotaryPitch");

OSCdef('ModeMajor',
 {
  arg msg;
  msg.postln;

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/ModeMajor", 1);
			o.sendMsg("/Harmonizer/ModeMinor", 0);
		},{
			o.sendMsg("/Harmonizer/ModeMinor", 0);
		});

  z.set(\t, 1/4);

 },
 "/Harmonizer/ModeMajor");

OSCdef('ModeMinor',
 {
  arg msg;
  msg.postln;

		if (msg[1] == 0, {
			o.sendMsg("/Harmonizer/ModeMinor", 1);
			o.sendMsg("/Harmonizer/ModeMajor", 0);
		},{
			o.sendMsg("/Harmonizer/ModeMajor", 0);
		});

  z.set(\t, 1/3);

 },
 "/Harmonizer/ModeMinor");
)

s.record(duration: 15);