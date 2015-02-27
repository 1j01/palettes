
////////////////////////
/*
http://ak.picdn.net/shutterstock/videos/1387399/preview/stock-footage-monochromatic-gray-gears-turn-next-to-old-steel-pipes.jpg
http://fc03.deviantart.net/fs70/f/2012/222/6/7/the_old_pipes_by_chribba-d5ak6te.jpg
http://s3.amazonaws.com/spoonflower/public/design_thumbnails/0132/0575/SteampunkPanel-Gears-Pipes-Brass1_shop_preview.png
*/

/*
document.addEventListener("keypress",function(e){
	if(e.keyCode===96){
		console.log("~");
		delete localStorage.world;
		history.go(0);
	}else{
		console.log("pressed",e.keyCode);
	}
},false);*/

//PropertyTypes need to be instanced, so they can hold their data.
//They need get/set data functions.
//They need a callback function for displaying themselves in the editor. It will be called with an empty HTMLDivElement.
//They may need a default property name (as opposed to property type name)
//				and some default data? 

propertyTypes = [];

addPropertyType = function(name, display){
	
};
addPropertyValidator = function(property_name, name, validator){
	
};


addPropertyType("bool",function($div){
	var $cb = E("input");
	$cb.type = "checkbox";
	$div.appendChild($cb);
	$cb.onclick = function(){
		this.data = $cb.checked;
	};
});
addPropertyType("text",function($div){
	var $cb = E("input");
	$cb.type = "text";
	$div.appendChild($cb);
	$cb.onchange = function(){
		this.data = $cb.value;
	};
});


//// Storage

recovery=false;
if(localStorage.world){
	try{
		world=JSON.parse(localStorage.world);
	}catch(e){
		if(prompt("Error loading the world. Enter RESET to reset the ENTIRE WORLD.")=="RESET"){
			
		}else{
			gui.err(e);
			recovery=true;
		}
	}
}
if(!recovery){
	if(!window.world){
		world={
			start: {width:100, height:100, grid:[], instances:[
				{type:"player", x:120, y:120, w:ts*0.9, h:ts*1.5, vx:0, vy:0, f:1}
			]}
		};
		
		for(var x=0;x<world.start.width;x++){
			var col=[];
			for(var y=0;y<world.start.height;y++){
				col.push({type:"air"});
			}
			world.start.grid.push(col);
		}
	}
}

//// Storage / Level Editor
setInterval(function(){
	if(recovery){
		console.log("Not saving. Recovery mode active.");
	}else{
		localStorage.world=JSON.stringify(world);
	}
}, 100);

//// Game / Level Editor

var ts=16;
var room=world.start;
var view={x:0,y:0};

var blocktypes = {
	air: {
		draw: null,
		solid: false
	},
	sand: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#EB7";
			ctx.fillRect(x,y,w,h);
			ctx.fillStyle="#D94";
			ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
			ctx.fillStyle="#FD9";
			ctx.fillRect(x+irandom(w-1),y+irandom(h-1),1,1);
			ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
			ctx.fillRect(x+irandom(w-1),y+irandom(h-2),1,2);
			ctx.fillRect(x+irandom(w-2),y+irandom(h-2),2,2);
		},
		solid: true
	},
	dirt: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#A60";
			/*ctx.beginPath();
			var r=3,rl=2;
			w+=r*1.1;h+=r*1.1;
			x-=r;y-=r;
			ctx.moveTo(x+rand(r),y+rand(r));
			for(var i=1;i<ts;i+=ts/9){	ctx.lineTo(x+i+rand(rl),	y+rand(r));			}
			for(var i=1;i<ts;i+=ts/9){	ctx.lineTo(x+w+rand(r),		y+rand(rl)+i);		}
			for(var i=1;i<ts;i+=ts/9){	ctx.lineTo(x+w-i+rand(rl),	y+rand(r)+h);		}
			for(var i=1;i<ts;i+=ts/9){	ctx.lineTo(x+rand(r),		y+rand(rl)+h-i);	}
			ctx.closePath();
			ctx.fill();*/
			ctx.fillRect(x,y,w,h);
			ctx.fillStyle="rgba(0,20,20,0.1)";
			ctx.fillRect(x+irandom(w-3),y+irandom(h-3),3,3);
			ctx.fillStyle="rgba(20,20,0,0.1)";
			ctx.fillRect(x+irandom(w-3),y+irandom(h-3),3,3);
			for(var i=0; i<2; i++){
				ctx.fillStyle="rgba(200,140,20,0.8)";
				ctx.fillRect(x+irandom(w-2),y+irandom(h-2),2,2);
				ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
			}
		},
		solid: true
	},
	rock: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#AAA";
			ctx.fillRect(x,y,w,h);
			ctx.fillStyle="rgba(0,0,0,0.1)";
			ctx.fillRect(x+irandom(w-2),y+irandom(h-2),2,2);
			ctx.fillStyle="rgba(140,70,20,0.1)";
			ctx.fillRect(x+irandom(w-3),y+irandom(h-2),3,2);
			ctx.fillStyle="rgba(255,255,255,0.1)";
			ctx.fillRect(x+irandom(w-3),y+irandom(h-3),3,3);
			ctx.fillStyle="rgba(0,0,0,0.1)";
			ctx.fillRect(x+irandom(w-4),y+irandom(h-4),4,4);
			for(var i=0; i<5; i++){
				ctx.fillStyle="rgba(0,0,0,0.1)";
				ctx.fillRect(x+irandom(w-2),y+irandom(h-2),2,2);
				ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
				ctx.fillStyle="rgba(255,255,255,0.1)";
				ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
				ctx.fillRect(x+irandom(w-1),y+irandom(h-2),1,2);
				ctx.fillStyle="rgba(255,255,255,0.1)";
				ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
			}
		},
		solid: true
	},
	flowers: {
		draw: function(ctx,x,y,w,h,b){
			var fx1=x+Math.random()*w/2+w/4;
			var fy1=y+h;
			for(var i=0; i<Math.random()+1; i++){
				var fx2=x+Math.random()*(w-6)+3;
				var fy2=y+Math.random()*7+3;
				ctx.strokeStyle="green";
				ctx.beginPath();
				ctx.moveTo(fx1,fy1);
				ctx.lineTo(fx2,fy2);
				ctx.stroke();
				ctx.fillStyle="hsl("+(Math.random()*30)+",100%,50%)";
				ctx.fillRect(fx2-1,fy2-1,3,3);
			}
		},
		solid: false
	},
	concrete: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#BBBBBF";
			ctx.fillRect(x,y,w,h);
			for(var i=0; i<40; i++){
				ctx.fillStyle="rgba(0,0,0,0.1)";
				ctx.fillRect(x+irandom(w-1),y+irandom(h-1),1,1);
				ctx.fillStyle="rgba(255,255,255,0.1)";
				ctx.fillRect(x+irandom(w-1),y+irandom(h-1),1,1);
				ctx.fillStyle="rgba(255,255,255,0.1)";
				ctx.fillRect(x+irandom(w-2),y+irandom(h-1),2,1);
			}
		},
		solid: true
	},
	grate: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#AAA";
			ctx.fillRect(x,y,w,h);
			for(var i=1; i<=h; i+=2){
				ctx.fillStyle="rgba(0,0,0,0.5)";
				ctx.fillRect(x+1,y+i,w-1,1);
			}
		},
		solid: true
	},
	door: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#964";
			ctx.fillRect(x,y,w,h);
		},
		solid: true
	},
	note: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#FFF";
			ctx.fillRect(x+1,y+1,w-2,h-1);
			ctx.fillStyle="rgba(0,0,0,0.5)";
			for(var x1=1, y1=2; y1<=h; x1++){
				var ll=Math.random()*5+1;
				if(x1+ll+3>=w || Math.random()>0.9){
					x1=1;
					y1+=2;
				}else{
					ctx.fillRect(x+x1,y+y1,ll,1);
					x1+=ll;
				}
			}
		},
		solid: false
	},
	platform: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#888";
			ctx.fillRect(x,y,w,h/4);
		},
		solid: 0.4
	},
	platformOneWay: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#AAA";
			ctx.fillRect(x,y,w,h/4);
		},
		solid: 0.6
	},
	pipe: {
		draw: function(ctx,x,y,w,h,b){
			var bx=x/ts;
			var by=y/ts;
			ctx.fillStyle="#DDD";
			if(bx==0.5){
				ctx.fillRect(x,y+2.5,w,h-5);
				return;
			}
			if(room.grid[bx+1][by].type==="pipe"){
				ctx.fillRect(x,y,w,h);
			}
			ctx.fillStyle="#990";
			ctx.fillRect(x+w/2-1,y+h/2-1,3,3);
		},
		nearchanged: function(){
			
		},
		solid: 0.6
	},
	teleporter: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#3CF";
			ctx.fillRect(x,y,w,h);
		},
		solid: false
	},
	spike: {
		draw: function(ctx,x,y,w,h,b){
			ctx.fillStyle="#AAA";
			ctx.beginPath();
			ctx.moveTo(x,y+h);
			ctx.lineTo(x+w/4,y+3);
			ctx.lineTo(x+w/2,y+h);
			ctx.lineTo(x+w*3/4,y+3);
			ctx.lineTo(x+w,y+h);
			ctx.fill();
		},
		solid: true
	},
};
for(var i in blocktypes){
	blocktypes[i].type = i;
}

gui.overlay();
ctx = $c.getContext("2d");

var $gc=E("canvas");
$gc.width=ts*room.height;
$gc.height=ts*room.width;
var gctx=$gc.getContext("2d");

function redrawRegion(x1,y1,x2,y2){
	gctx.clearRect(x1*ts,y1*ts,(x2-x1)*ts,(y2-y1)*ts);
	for(var x=x1||0; x<room.width && x<x2; x++){
		for(var y=y1||0; y<room.height && y<y2; y++){
			var b=room.grid[x][y];
			var bt=blocktypes[b.type];
			if(!bt||!bt.draw)continue;
			bt.draw(gctx,x*ts,y*ts,ts,ts,b);
			//gctx.drawImage(img,x*ts,y*ts);
			//else throw new Error("No blocktype "+room.grid[x][y].type);
		}
	}
}
redrawRegion(0,0,room.width,room.height);
/*
function drawRoom(){
	for(var i=0; i<=1; i++){
		for(var x=Math.floor(view.x/ts); x<room.width && x<(view.x+window.innerWidth)/ts; x++){
			for(var y=Math.floor(view.y/ts); y<room.height && y<(view.y+window.innerHeight)/ts; y++){
				var b=room.grid[x][y];
				var f=sprites[b.type];
				if(!f||!f[i])continue;
				f[i](ctx,x*ts-view.x,y*ts-view.y,ts,ts,b);
				//else throw new Error("No blocktype "+room.grid[x][y].type);
			}
		}
	}
}*/

//// Level Editor

var mouse={bx:3, by:3, left:false, right:false, overGUI:false};
addEventListener("contextmenu",function(e){
	e.preventDefault();
});
addEventListener("mousemove",function(e){
	if(!mouse.down)return;
	mouse.bx=Math.floor((e.clientX+view.x)/ts);
	mouse.by=Math.floor((e.clientY+view.y)/ts);
});
$c.addEventListener("mousemove",function(e){
	mouse.bx=Math.floor((e.clientX+view.x)/ts);
	mouse.by=Math.floor((e.clientY+view.y)/ts);
	mouse.overGUI=false;
});
gui.element.addEventListener("mousemove",function(e){
	if(mouse.down)return;
	mouse.bx=-1;
	mouse.by=-1;
	mouse.overGUI=true;
});
$c.addEventListener("mousedown",function(e){
	if(e.button===0){
		mouse.left=true;
	}else{
		mouse.right=true;
	}
});
addEventListener("mouseup",function(e){
	if(e.button===0){
		mouse.left=false;
	}else{
		mouse.right=false;
	}
});
var mBlocks=new Modal()
	.title("Blocks")
	.position("top left");

var selectedBlockType="dirt";
for(k in blocktypes){
	var bt=blocktypes[k];
	if(k==="air")continue;
	var $bc=E("canvas");
	var $b=E("span","choose-block"+(selectedBlockType===k?" selected":""));
	$b.onclick=function(){
		var $$b=mBlocks.$$(".choose-block");
		for(var i in $$b){
			$$b[i].className="choose-block";
		}
		this.className="selected choose-block";
		selectedBlockType=this.type;
	};
	$b.type=k;
	$b.appendChild($bc);
	$bc.width=$bc.height=ts*2;
	var bctx=$bc.getContext("2d");
	bt.draw(bctx,ts/2,ts/2,ts,ts);
	
	mBlocks.$c.appendChild($b);
}

var mActions=new Modal()
	.title("Actions")
	.position("bottom left")
	.content("<button id='reset'>Reset game state</button><br>"
			+"<button id='clear'>Clear Room</button><br>");

mActions.$("#reset").onclick=function(){
	
};
mActions.$("#clear").onclick=function(){
	gui.confirm("Are you sure?","This will clear all blocks and instances from this room.",function(ok){
		
		for(var x=0;x<room.width;x++){
			for(var y=0;y<room.height;y++){
				col[x][y]={type:"air"};
			}
		}
	});
};

function levelEditorUpdate(){
	if(!mouse.overGUI){
		ctx.strokeStyle="#AAA";
		ctx.strokeRect(mouse.bx*ts, mouse.by*ts, ts, ts);
		if(mouse.left){
			if(room.grid[mouse.bx][mouse.by].type!=selectedBlockType){
				room.grid[mouse.bx][mouse.by]={type:selectedBlockType};
				redrawRegion(mouse.bx,mouse.by,mouse.bx+1,mouse.by+1);
			}
		}else if(mouse.right){
			if(room.grid[mouse.bx][mouse.by].type!="air"){
				room.grid[mouse.bx][mouse.by]={type:"air"};
				redrawRegion(mouse.bx,mouse.by,mouse.bx+1,mouse.by+1);
			}
		}
	}
}
function playerUpdate(){
	ctx.fillStyle="#AAA";
	ctx.fillRect(player.x, player.y, player.w, player.h);
	player.vy += 0.5;
	player.x += player.vx;
	player.y += player.vy;
}

function collisionRectangle(x,y,w,h){
	
}

// */

/*
setInterval(function(){
	var m=systemErrorWarning();
	for(i in gui.modals){
		if(Math.random()<0.01)gui.modals[i].position("random");
		else if(Math.random()<0.005)gui.modals[i].close();
	}
},100);
setInterval(function(){
	for(i in gui.modals){
		gui.modals[i].close();
	}
},60000);
function systemErrorWarning(){
	var m = gui.msg(
		/(ERROR|ERROR|(((FILE)?SYSTEM) |REGISTRY )?ERROR|(WARNING|WARNING|ALERT|(SYSTEM )?FAILURE|(ALERT|ALERT|ERROR 0x[0-9A-F]{6})))/
			.generate(),
		"<div style='font-family:monospace;'>"
			+ /((((((THERE WAS AN )?UNEXPECTED|(THERE WAS AN )?UNKNOWN|(THERE WAS AN )?UNHANDLED|(THERE WAS A )?RUNTIME|(THERE WAS A )?FATAL) )?(ERROR|ERROR|EXCEPTION)( 0x[0-9A-F]{4,8})?( WITH (A (VITAL )?(SYSTEM )?(PROGRAM|PROCESS|TASK)|THE (SYSTEM|(ERROR|(VIRUS|MALWARE|EXPLOIT)) (HANDLING|PROTECTION|RECOVERY) SYSTEMS?))|( IN (THE (REGISTRY|FILESYSTEM|((ERROR (HANDLING|PROTECTION|RECOVERY)|OPERATING) SYSTEM)))))))|(THE (SYSTEM|PROGRAM|REGISTRY) HAS (BEEN CORRUPTED|CRASHED)))(\n((THE (SYSTEM|PROGRAM) WILL NOW (SHUT DOWN|EXIT|TERMINATE))|(THE PROBLEM (HAS NOT BEEN FIXED|PERSISTS|(SHOULD NOT|MAY) AFFECT (USER EXPERIENCE|THE REST OF THE SYSTEM|THE OPERATING SYSTEM)))|(THE (ERROR|PROBLEM|REASON) IS (NOT |UN)KNOWN)|(PLEASE (REPORT THE PROBLEM|DESTROY THE (SYSTEM|EVIDENCE)|SHUT DOWN THE SYSTEM))))?\n((ERROR CODE:? 0x[0-9A-F]{6})\n|((MEMORY DUMP|(POSSIBLE )?CORRUPTED (AREAS|DATA):?)\n((0x[0-9A-F]{6}: ([0-9A-F]{2} ){4}\n){4})|(0x[0-9A-F]{6}: ([0-9A-F]{4} ){2}\n){4,8}))?/
				.generate().replace(/\n/g,"<br>")
			+ "</div>"
	).position("random");
	m.$(".ok").textContent =
		/OK|OK|OK|OK|ABORT|DENY|SHUT DOWN|END( TASK)?/
			.generate();
	return m;
}*/

var stats = new Stats();
var m=new Modal();
m.title("Stats");
m.$m.appendChild(this.stats.domElement);
m.$t.style.fontSize=9+"px";
m.position("bottom right");


(window.onresize=function(){
	w = document.body.clientWidth;
	h = document.body.clientHeight;
	$c.width = w;
	$c.height = h;
	draw();
})();

setInterval(draw,10);
function draw(){
	ctx.clearRect(0,0,w,h);
	ctx.fillStyle="#fff";
	ctx.drawImage($gc,0,0);
	levelEditorUpdate();
	for(var i=0;i<room.instances;i++){
		instanceTypes[room.instances[i].type].step(room.instances[i]);
	}
	//playerUpdate();
	stats.update();
}