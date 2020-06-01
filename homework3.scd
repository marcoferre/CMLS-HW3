s.boot;


Server.default.quit

(

//select t 1/4 for minor scale, 1/3 for major scale
SynthDef.new("pitchFollow1",{
	arg faderPitch=1, v1=0, v2=0, v3=0, v4=0, v5=0, v6=0, v7=0, faderReverb=0, rotaryRoom = 0, tremoloX=0, tremoloY=0, attack=500, release=500, t=1/4;

	var in, amp, freq, hasFreq, out;
    var midinum;
    var partials;

    in = Mix.new(SoundIn.ar([0,1]));
	amp = Amplitude.kr(in, attack, release);

	partials = [
		0.25*faderPitch*v1,
		0.25*faderPitch*2.pow(t)*v2,
		0.5*faderPitch*v3,
		0.5*faderPitch*2.pow(t)*v4,

		1*faderPitch*2.pow(t)*v5,
		2*faderPitch*v6,
		2*faderPitch*2.pow(t)*v7,
    ];

	out = HPF.kr(out, 120);

    out = PitchShift.ar(in, 0.1, partials, 0, 0.004, amp);

	//TREMOLO
	out=SinOsc.kr(freq: tremoloX*6, mul: tremoloY*1.125, add:out);
	//REVERB
	out=Mix.new(FreeVerb.ar(out, faderReverb, rotaryRoom)) + (in*0.1);

	Out.ar([0,1],out/partials.size);

}).add;

)

//osc controller
(

z = Synth(\pitchFollow1);

i = NetAddr("192.168.1.23", 57120);
o = NetAddr("192.168.1.23", 9000);

//initialising GUI
o.sendMsg("/Harmonizer/ModeMajor", 1);
o.sendMsg("/Harmonizer/RotaryAttack", 500);
o.sendMsg("/Harmonizer/RotaryRelease", 500);
o.sendMsg("/Harmonizer/FaderPitch", 0.5);
o.sendMsg("/Harmonizer/FaderReverb", 0);
o.sendMsg("/Harmonizer/RotaryReverb", 0);
o.sendMsg("/Harmonizer/TremoloXY", 0, 0);
o.sendMsg("/Harmonizer/harm1", 0);
o.sendMsg("/Harmonizer/harm2", 0);
o.sendMsg("/Harmonizer/harm3", 0);
o.sendMsg("/Harmonizer/harm4", 0);
o.sendMsg("/Harmonizer/harm5", 0);
o.sendMsg("/Harmonizer/harm6", 0);
o.sendMsg("/Harmonizer/harm7", 0);



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

		z.set(\v1, msg[1]);
 },
 "/Harmonizer/harm1");

OSCdef('Harm2',
 {
  arg msg;
  msg.postln;

		z.set(\v2, msg[1]);
 },
 "/Harmonizer/harm2");

OSCdef('Harm3',
 {
  arg msg;
  msg.postln;
		z.set(\v3, msg[1]);
 },
 "/Harmonizer/harm3");

OSCdef('Harm4',
 {
  arg msg;
  msg.postln;

		z.set(\v4, msg[1]);
 },
 "/Harmonizer/harm4");

OSCdef('Harm5',
 {
  arg msg;
  msg.postln;

		z.set(\v5, msg[1]);
 },
 "/Harmonizer/harm5");

OSCdef('Harm6',
 {
  arg msg;
  msg.postln;

		z.set(\v6, msg[1]);
 },
 "/Harmonizer/harm6");

OSCdef('Harm7',
 {
  arg msg;
  msg.postln;

		z.set(\v7, msg[1]);
 },
 "/Harmonizer/harm7");

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

OSCdef('TremoloXY',
 {
  arg msg;
  msg.postln;

  z.set(\tremoloX, msg[2]);
  z.set(\tremoloY, msg[1]);
 },
 "/Harmonizer/TremoloXY");

OSCdef('Attack',
 {
  arg msg;
  msg.postln;

  z.set(\attack, msg[1]);

 },
 "/Harmonizer/RotaryAttack");

OSCdef('Release',
 {
  arg msg;
  msg.postln;

  z.set(\release, msg[1]);

 },
 "/Harmonizer/RotaryRelease");

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