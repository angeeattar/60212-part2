var mySound, myPhrase, myPart;
// var note = 1;
var pattern = [0,0,0,0];
var msg = 'click to play';
1
function preload() {
  mySound = loadSound('assets/beatbox.mp3');
  // mySound = loadSound('assets/02 Ivy.m4a');
}

function setup() {
  noStroke();
  fill(255);
  textAlign(CENTER);
  masterVolume(0.1);

  myPhrase = new p5.Phrase('bbox', makeSound, pattern);
  myPart = new p5.Part();
  myPart.addPhrase(myPhrase);
  myPart.setBPM(128);
}

function draw() {
  background(0);
  text(msg, width/2, height/2);
  for (var i = 0; i<4 ; i++){
    pattern[i] = random(1);
  }
}

function makeSound(time, playbackRate) {
  mySound.rate(playbackRate);
  mySound.play(time);
}

function mouseClicked() {
  if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
    myPart.start();
    msg = 'playing pattern';
  }
}