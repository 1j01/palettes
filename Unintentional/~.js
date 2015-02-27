
var tilde_havers = "ÃÑÕãñõĨĩŨũƟȬȭɫᵬᵭᵮᵯᵰᵱᵲᵳᵴᵵᵶḚḛḬḭṌṍṎṏṴṵṸṹṼṽẪẫẴẵẼẽỄễỖỗỠỡỮữỸỹⱢ";var math_tilde_havers = "≁≂≃≄≅≆≇≉≊≾≿≵≴≳≲⋍⋦⋧⋨⋩～";
var tildes = "~∼≈∽∿〜〰﹋﹏≈≋～";//ס⁓    ◌◌◌◌◌
var tilde_combiners = "̴̰̃᷉͊͌͌͠~◌֘◌͊◌͋͋̃˜֮◌͌̾";//some repeats
tilde_havers += math_tilde_havers;
tilde_havers += tildes;

var str = "";
for(var i=0;i<tildes.length;i++){
	for(var j=0;j<tildes.length;j++){
		//console.log(tildes[j]+tildes[i]);
		str += tildes[j]+tildes[i];
	}
}
console.log(str);
var str = "";
for(var i=0;i<tilde_combiners.length;i++){
	for(var j=0;j<tilde_havers.length;j++){
		//console.log(tilde_havers[j]+tildes[i]);
		str += tilde_havers[j]+tilde_combiners[i];
	}
}
console.log(str);