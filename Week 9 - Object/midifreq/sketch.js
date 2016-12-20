var noteList =  ["c","d","e","f","g","a","b"];
var noteScale = [72, 74, 76, 77, 79, 81, 83]; // 48 is base note
var i = 0;

function setup() {
  osc = new p5.Oscillator('Triangle');
  osc.start();
  frameRate(1);
}

function draw() {
  var freq = midiToFreq(noteScale[i]);
  osc.freq(freq);
  i++;
  if (i >= noteScale.length){
    i = 0;
  }
}