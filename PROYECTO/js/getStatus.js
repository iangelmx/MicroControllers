$(function(){
	var a = 0;
	var edoSiguiente = "inicio";
	var terminarInterval = "false";
	var altura = "";
	function esperaInundacion(){
		proceso=setInterval(function(){
			a=a+1;
			if( terminarInterval == "true" ){
				clearInterval(proceso);
			}
			try{
				urlSitio = "./php/getStatus.php"
				$.ajax({ // ESTO ENVIARÍA EL CORREO PARA NOTIFICAR
			        url: urlSitio,
			        type: "post",
			        async: false,
			        data:{
						modoAlerta : "inundacion"
			        },
			        headers: {
			    		'Auth':"mLctE2cOq3grtg9F"
			    	},
			        success: function(data){
				    	jsonResp = JSON.parse(data);
				    	//console.log(jsonResp);
				    	if(jsonResp['ok'] == "true"){
				    		jsonDesc = JSON.parse(jsonResp['description']);
				    		console.log(jsonDesc)

				    		if(jsonDesc[0]['estatus'] == "no_alerta"){
				    			escena = `<img src="media/llave.jpg" width="100%">`;
				    		}else{
				    			escena = `<img src="media/encendido.jpg" width="100%">`;
				    		}

				    		

				    		if( terminarInterval == "false"){
				    			document.getElementById('workspace').innerHTML = escena;// jsonResp['description'] ;
				    		}
				    		//$("#workspace").html( jsonResp['description'] );
				    	}
				    	else{
				    		console.log("Error con la petición");
				    		console.log(jsonResp);
				    	}
				    }
			    });

			}
			catch(err){
				console.log("Err -> "+err.message);
			}
		},1500);
	}


	$("#workspace").click(function(){
		if(edoSiguiente=="inicio"){
			tag = `
			<center>
				<video height="100%" autoplay>
				  <source src="media/intro.mp4" type="video/mp4">
					  Your browser does not support the video tag.
				</video>
			</center>`;
			//$("#workspace").html(tagVideo);
			edoSiguiente="dispositivos";
			terminarInterval = "false";
		}
		else if(edoSiguiente == "dispositivos"){
			tag = `<img src="media/dispositivos.jpg" width="100%">`;
			edoSiguiente = "apagado";
		}
		else if(edoSiguiente == "apagado"){
			tag = `<img src="media/apagado.jpg" width="100%">`;
			edoSiguiente = "llave";
		}
		else if(edoSiguiente == "llave"){
			tag="";
			esperaInundacion();
			edoSiguiente = "fin";
		}
		else if(edoSiguiente == "fin"){
			console.log("Pondrá a true el terminarInterval");
			terminarInterval = "true";
			tag = `
			<center>
				<video height="100%" autoplay>
				  <source src="media/fin.mp4" type="video/mp4">
					  Your browser does not support the video tag.
				</video>
			</center>`;
			edoSiguiente = "pant0";
		}
		else if(edoSiguiente == "pant0"){
			tag = `<img src="media/inicio.jpg" width="100%">`;
			edoSiguiente = "inicio";
		}
		console.log(edoSiguiente);
		$("#workspace").html(tag);
		
	});
	
});