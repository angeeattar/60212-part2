﻿#includepath "~/Documents/;%USERPROFILE%Documents";#include "basiljs/bundle/basil.js";// Relevant links// http://basiljs.ch/tutorials/modifying-typography/// http://basiljs.ch/wp-content/uploads/2013/03/basiljs_b_typo_cheatsheet_v0_2.pdffunction setup() {  b.textFont("Mrs Eaves XL Serif Nar OT",["Bold Italic"]);  //b.textSize(20);  swatches = ["a","b","c","d","e","f","g","h","i","j","k","l","m"];  typeColour = swatches[6];  b.fill(typeColour);  b.fillTint(70);  b.rect(0, 0, (b.width)*2,b.height)  var allTweets = ["i see where i stand ","love you xx ","I love you most ","its a maybe from me X ","Ill see you in a bit Im gonna nap ","doing advert of love ","everything will be ","oh she kisses his forehead ","I hope you are ","Hi been thinking about you lately and havent heard much from you please tell me that your okay ","eric smiles softly and sits down on a bench as he waits ","know how that feels you xx ","she tilts her head Are you ","yeah fine ", "hope everything is ","men arent supposed to be able to search you without another female officer present","he looks at his ", "now youre just teasing me ", "if you say so X ","Hope your love ","please dont stress out about it x ", "and then you know what you are ","just those days x ","are you Here for you ","I love you ", "let your heart recover eh ","just smile Ok ","why ","you ", "x ", "Never heard of it You can manage Have faith ","you have me to keep you busy ", "Goodnight ", "my mom loves you ","you were just like the 5th person ", "i shall ", "its okay for the all wishes ","you dont say that again ", "Only four posts about this cup ","you can work at a car wash now I heard they name good tip ","see you soon ", "Ill call u later ", "as long as you would do the same ","same here ", "let it all out "]  allS = b.random(0,allTweets.length)  var myString = allTweets[26];  var copiedText = [myString];  for(var k = 0; k<200; k++){    copiedText[0] +=  myString;  }  var myFrame = b.text(copiedText[0], 0,0, b.width*2,b.height);   var myChars = b.characters(myFrame);  var stringLen = myString.length;  for(var i = 0; i < myChars.length; i++){    var typeSize = 8;    typeSize+=(i%stringLen);    b.typo(myChars[i], "pointSize", typeSize); //getting bigger  }  b.typo(myFrame,"capitalization",Capitalization.ALL_CAPS);  b.typo(myFrame, 'hyphenation', false);  b.rotate(b.PI)  var dup = b.duplicate(myFrame);  b.pushMatrix();  b.itemPosition(dup, -14,21);  b.popMatrix();}b.go(b.MODESILENT);