$(function(){

	function alerta(sensor){

		toWho = { "iangelmx@hotmail.com" : "Angel Rmz" };
		asunto = "Alerta! Tu "+sensor+" ha registrado actividad anormal.";
		remitente = "rumy@telmex.com";
		nombre = "RÜMY de Telmex";
		cuerpo = `
		<html>
		<!doctype html>
		<html>
		<head>
		<meta charset="utf-8">
		<title>Untitled Document</title>
			
		</head>

		<body>


		<table style="border: 1px solid #C3C3C3;font-family:Segoe,'Segoe UI','DejaVu Sans','Trebuchet MS',Verdana,'sans-serif';font-size:12px;background-color:#FFF" width="720px" cellspacing="2" cellpadding="2">
		  	<tbody>
		    	<tr>
		      		<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  			<tbody>
		   				<tr>
		      				<td width="75%">
								<span style="color:#008AD7;font-size:20px">
		     						<strong>Direcci&oacute;n de Desarrollo Tecnol&oacute;gico</strong>
		            			</span>
		            			<br>
		            			<span style="color:#008AD7;font-size:14px">
		            				Subdirecci&oacute;n de Desarrollo de Soluciones
		            			</span>
							</td>
		      				<td width="25%" align="right"><img alt="TELMEX" src="http://201.107.5.3/pdstelmex/images/Logo_RSS.jpg" border="0" title="Desarrollo de Soluciones"></td>
		    			</tr>
		  			</tbody>
					</table>
				</td>
		    </tr>
		    <tr>
		      	<td>
					<table width="100%" height="40px" style="border:0px solid #C3C3C3;background-color: #CEEFFF" cellspacing="2" cellpadding="2">
						<tr>
							<td width="20%">
								Nombre del Proyecto:
							</td>
							<td width="55%" style="font-size:16px;">
								<strong>{#211:Nombre del Proyecto}</strong>
							</td>
							<td align="right" width="15%">
								Avance General:
							</td>
							
							<!-- 
									
							*************************************************
							Version 3.0
							Adecuación JQ - Colorear Porcentaje según estatus
							*************************************************

							-->
							<td align="center" width="10%" id="PercentProy">
								<b>{#227:Porcentaje de Avance %} %</b>
							</td>
						</tr>
					</table>
				</td>
		    </tr>
			<tr>
					<td>
						<hr>	
					</td>
			</tr>
		    <tr>
		      	<td>
					<table width="100%"  style="border: 1px solid #C3C3C3;" cellspacing="2" cellpadding="2">
						<tr>
							<td width="45%">
								<table width="100%" border="0" cellspacing="2" cellpadding="2">
									<tr>
										<td width="25%" id="Tabla_Resumen_Semanal">
											Ejecutivo Responsable:
										</td>
										<td width="15%" style="background-color: #E6F4FF">
											<strong>{#221:Ejecutivo DS}</strong>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Estatus General:
										</td>

										<td width="15%" id="txtEstatusProject">
											<strong id="estatusProject">{#241:Estatus}</strong>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Líder de Producto:
										</td>
										<td width="15%" style="background-color: #E6F4FF">
											<strong>{#224:Líder de producto}</strong>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Etapa del Proyecto:
										</td>
										<td width="15%" style="background-color: #fff">
											<strong id="etapaActual">{#780:Etapa de Proyecto}</strong>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Fin de Etapa Programada:
										</td>
										<td width="15%" style="background-color: #E6F4FF">
											<strong>{#778:Fin de Etapa - Fecha PROGRAMADA}</strong>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Fin de Etapa Real:
										</td>
										<td width="15%" style="background-color: #fff">
											<strong>{#779:Fin de Etapa - Fecha REAL}</strong>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Liberación Comercial:
										</td>
										<td width="15%" style="background-color: #E6F4FF">
											<strong id="fechaLanzComer">{#239:Lanzamiento Comercial Real}</strong>
										</td>
									</tr>
								</table>
							</td>
							<td width="5%">
							
							</td>
							<td valign="top" width="45%">
								<table width="100%" style="border: 0px solid #C3C3C3;" cellspacing="2" cellpadding="2">
									<tr>
										<td align="center" width="100%" style="color:#FFF;background-color:#008AD7;font-size:15px">
											<b>NOTAS DEL EJECUTIVO:</b>
										</td>
									</tr>
									<tr>
										<td>
											{#810:Estatus General}
										</td>
									</tr>
								</table>
								
							</td>
						</tr>
					</table>
				
				</td>
		    </tr>
		    <tr>
		      	<td>
					<table width="100%" style="border: 1px solid #C3C3C3;" cellspacing="2" cellpadding="2">
						<tr>
							<td align="center" width="100%" style="color:#FFF;background-color:#008AD7;font-size:15px" id="TimelineRSS">
								<b>TIMELINE</b>
							</td>
						</tr>
					</table>
					<table width="100%" style="border: 1px solid #C3C3C3;" cellspacing="2" cellpadding="2">
						<tr>
							<td align="center" width="80%" id="imgTimeline"></td>
							<td align="center" width="20%">
								<b>Fin de Etapa Real:</b>
								<br>{#779:Fin de Etapa - Fecha REAL}
							</td>
						</tr>
					</table>
				</td>
		    </tr>
			<tr>
				<td>
							<hr>
				</td>	
			</tr>
			
			<tr>
				<td>
					<table width="100%" style="border: 0px solid #D70000;" cellspacing="2" cellpadding="2">
						<tr>
							<td align="center" width="50%" style="border: 1px solid #FFF;color:#FFF;background-color:#D70000;font-size:15px">
								<b>DEPENDENCIAS CRÍTICAS:</b>
							</td>

						</tr>
						<tr>
							<td align="center" width="50%" style="border: 0px solid #FFF;">
								<table width="100%" style="border: 0px solid #C3C3C3;" cellspacing="2" cellpadding="2">
									<tr>
										<td valign="top" align="center" width="100%" style="border: 0px solid #C3C3C3;">
											{#entity30:1610}
										</td>

									</tr>
								</table>	
							</td>
						</tr>
					</table>
					
				</td>	
			</tr>
			<tr>
				<td height="15px">
							
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" style="border: 0px solid #C3C3C3;" cellspacing="2" cellpadding="2">
						<tr>
							<td align="center" width="100%" style="border: 1px solid #FFF;color:#FFF;background-color:#00B309;font-size:15px">
								<b>ENTREGABLES PRÓXIMOS:</b>
							</td>

						</tr>
						<tr>
						<td align="center" width="100%" style="border: 0px solid #FFF;">
			
							<table width="100%" style="border: 0px solid #C3C3C3;" cellspacing="2" cellpadding="2">
									<tr>
										<td align="center" width="100%" style="border: 0px solid #C3C3C3;">
											{#entity30:1578}
										</td>
									</tr>
							</table>	
						</td>

						</tr>
					</table>
					
				</td>	
			</tr>
			<tr>
				<td height="15px">
							
				</td>
			</tr>
			<tr>
				<td align="center" width="100%" style="border: 0px solid #FFF;color:#848484;background-color:#EFEFEF;font-size:10px">
					<b>
						INFORMACIÓN PROPIEDAD DE TELÉFONOS DE MÉXICO S.A.B. DE C.V. 
						<br>
						PROHIBIDO SU MODIFICACIÓN, USO Y DIFUSIÓN SIN AUTORIZACIÓN EXPRESA - &copy; 2018 - 2019 
					</b>
				</td>	
			</tr>
		  </tbody>
		</table>


			
		</body>
		</html>`;

		$.ajax({ // ESTO ENVIARÍA EL CORREO PARA NOTIFICAR
	        url: "https://pdsinnoserver.ddns.net/pdstelmex/rep/mirrorEmail.php",
	        type: "post",
	        data:{
	        	publicKey: 'fMeMh8zRTGoJpA2JMctnglHCiG',
				mBody: cuerpo,
				toWho: toWho,
				emailToShow: remitente,
				nameToShow: nombre,
				subject: asunto
	        }
	    });
	}

	$("#camara").click( function(event){
		console.log("?");
		alerta(event.currentTarget.id);
	} );

});